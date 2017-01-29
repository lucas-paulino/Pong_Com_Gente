import processing.serial.*;
Serial perto;
int ariaDeteccao = 60;
float valor01 = 3, valor02 = 3;

boolean gameStart = false;
int leftColor = 128, rightColor = 128, diam = 30, rectSize1 = 200, rectSize2 = 200;
float x, y, speedX = -5, speedY = -5;
int posY1, posY2, pontos_p1=0, pontos_p2=0;
int direcao_partida;

  
void setup() {
  fullScreen();
  //size(700, 400);
  ellipseMode(CENTER);
  println(Serial.list());
  perto = new Serial(this, Serial.list()[0], 4800);
  perto.bufferUntil('\n');
  x = width/2; 
  y = height/2;
  while( direcao_partida == 0 ){
    direcao_partida = (int)random(-2, 2);
  }
  speedX = speedX*direcao_partida;
  speedY = speedY*direcao_partida;
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
  rect(0, posY2-rectSize1/2, 10, rectSize1);
  fill(240);
  rect(width-10, posY1-rectSize2/2, 10, rectSize2);
  
  if (gameStart) {
    x = x + speedX;
    y = y + speedY;
 
    if ( x > width-20 && x < width-10 && y > posY1-rectSize1/2 && y < posY1+rectSize1/2 ) { // se a bola colidir com a barra em motimento, inverte a direção de x
      speedX = speedX * -1;
      x = x + speedX;    
    }else if (x < 10 && y > posY2-rectSize2/2 && y < posY2+rectSize2/2) {       //se a bola colidir com a parede, inverte a direção de x
      speedX = speedX * -1.1;
      x = x + speedX;
    }
    
    if (x < 0) {    // Se a bola sair do lado do jogodor 1, o jogo recomeça
      gameStart = false;
     x = width/2;
      y = height/2 ;
      partidaAleatoria();
      speedX = speedX*direcao_partida;
      speedY = speedY*direcao_partida;
      pontos_p2++;
      //rectSize1 -= 20;
    }
    
    if (x > width) {    // Se a bola sair do lado do jogodor 2, o jogo recomeça
      gameStart = false;
     x = width/2;
      y = height/2 ;
      partidaAleatoria();
      speedX = speedX*direcao_partida;
      speedY = speedY*direcao_partida;
      pontos_p1++;
      //rectSize2 -= 20;
    }
    
    if ( y > height-(diam/2) || y < diam/2 ) {   // se a bola bater em cima ou em baixa o muda a direção de y  
      speedY = speedY * -1;
      y = y + speedY;
    }
    
    if ( rectSize1 <= 0 || rectSize2 <= 0) {   // jogo reinicia quando o tamanho de alguem chega a 0  
        gameStart = false;
       x = width/2;
        y = height/2 ;
        partidaAleatoria();
        speedX = speedX*direcao_partida;
        speedY = speedY*direcao_partida;
        pontos_p2++;
        rectSize1 = 100;
        rectSize2 = 100;
        pontos_p1=0;
        pontos_p2=0;
    }
  }
  
  if(valor01<=2 || valor02<=2){ // o jogo começa quando se aproxima do sensor
    gameStart = true;
  }
}

void keyPressed() {
  if (keyCode == UP && posY1>0) {
      posY1 -= 20;
  }else if (keyCode == DOWN && posY1<height ) {
      posY1 += 20;
  }
  
  if (key == 'w' && posY2>0) {
      posY2 -= 20;
  }else if(key == 's' && posY2<height ){
      posY2 += 20;
  }
}

void serialEvent (Serial perto){
  String inString = perto.readStringUntil('\n');
  
  if(inString.charAt(0)=='b'){
    
    inString = inString.replace('b', '0');
    valor01 = float(inString);
    
    if(valor01>ariaDeteccao){ 
      valor01 = ariaDeteccao; 
    }
    
    float posicao01 = map(valor01, 3, ariaDeteccao, 0, height);
    posY1 = int(posicao01);
  
  } 
  
  if(inString.charAt(0)=='a'){
    
    inString = inString.replace('a', '0');
    valor02 = float(inString);
    
    if(valor02>ariaDeteccao){ 
      valor02 = ariaDeteccao; 
    }
    
    float posicao02 = map(valor02, 3, ariaDeteccao, 0, height);
    posY2 = int(posicao02);
    
  }

}

void partidaAleatoria(){
  while( direcao_partida == 0 ){
    direcao_partida = (int)random(-2, 2);
  }
}