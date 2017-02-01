import processing.serial.*;
import processing.sound.*;
SoundFile ponto, hit;
Serial perto;
int ariaDeteccao = 60;
float valor01 = 3, valor02 = 3;

boolean gameStart = false;
int leftColor = 128, rightColor = 128, diam = 40, rectSize1 = 200, rectSize2 = 200, rectWidth = 20;
float x, y, speedX = -5, speedY = -5;
int posY1, posY2, pontos_p1=0, pontos_p2=0;
  
void setup() {
  fullScreen();
  ellipseMode(CENTER);
  perto = new Serial(this, Serial.list()[0], 4800);
  perto.bufferUntil('\n');
  x = width/2; 
  y = height/2;
  partidaAleatoria();
  ponto = new SoundFile(this, "ponto.wav");
  hit = new SoundFile(this, "hit.wav");
}
 
void draw() {  
  background(20); 
  stroke(240);
  line(width/2,0,width/2,height);
  
  text(pontos_p1,width/4,40);
  text(pontos_p2,width*0.75,40); 
  
  noStroke();
  fill(240);
  ellipse(x, y, diam, diam);
  fill(240);
  rect(0, posY2-rectSize1/2, rectWidth, rectSize1);
  fill(240);
  rect(width-rectWidth, posY1-rectSize2/2, rectWidth, rectSize2);
  
  if (gameStart) {
    x = x + speedX;
    y = y + speedY;
 
    if ( x > width-rectWidth*2 && x < width-rectWidth && y > posY1-rectSize1/2 && y < posY1+rectSize1/2 ) {   // se a bola colidir com a barra em motimento, inverte a direção de x
      speedX = speedX * -1;
      x = x + speedX;
      hit.play();
    }else if (x < rectWidth && y > posY2-rectSize2/2 && y < posY2+rectSize2/2) {   //se a bola colidir com a barra, inverte a direção de x
      speedX = speedX * -1.1;
      x = x + speedX;
      hit.play();
    }
    
    if (x < 0) {   // Se a bola sair do lado do jogodor 1, o jogo recomeça
      gameStart = false;
      x = width/2;
      y = height/2 ;
      partidaAleatoria();
      pontos_p2++;
      ponto.play();
    }
    
    if (x > width) {   // Se a bola sair do lado do jogodor 2, o jogo recomeça
      gameStart = false;
      x = width/2;
      y = height/2 ;
      partidaAleatoria();
      pontos_p1++;
      ponto.play();
    }
    
    if ( y > height-(diam/2) || y < diam/2 ) {   // Se a bola bater em cima ou em baixa o muda a direção de y  
      speedY = speedY * -1;
      y = y + speedY;
      hit.play();
    } 
    
    if ( pontos_p1 >= 5 || pontos_p2 >= 5) {   // jogo reinicia quando o tamanho de alguem chega a 0  
      gameStart = false;
      x = width/2;
      y = height/2 ;
      partidaAleatoria();
      pontos_p2++;
      rectSize1 = 200;
      rectSize2 = 200;
      pontos_p1=0;
      pontos_p2=0;
    }
  }
  
  if(valor01<=2 || valor02<=2){ gameStart = true; }   // O jogo começa quando se aproxima do sensor
}

void serialEvent (Serial perto){
  String inString = perto.readStringUntil('\n');
  if(inString.charAt(0)=='d'){    
    inString = inString.replace('d', '0');
    valor01 = float(inString);
    
    if(valor01>ariaDeteccao){ 
      valor01 = ariaDeteccao; 
    }
    
    float posicao01 = map(valor01, 3, ariaDeteccao, 0, height);
    posY1 = int(posicao01);  
  } 
  if(inString.charAt(0)=='e'){    
    inString = inString.replace('e', '0');
    valor02 = float(inString);
    
    if(valor02>ariaDeteccao){ 
      valor02 = ariaDeteccao; 
    }
    
    float posicao02 = map(valor02, 3, ariaDeteccao, 0, height);
    posY2 = int(posicao02); 
  }
}

void partidaAleatoria(){
  int direcao_partida = 0;
  while( direcao_partida == 0 ){
    direcao_partida = (int)random(-2, 2);
  }
  speedX = speedX*direcao_partida;
  speedY = speedY*direcao_partida;
}