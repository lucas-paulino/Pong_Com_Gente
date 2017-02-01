int trigPin1 = 7;
int echoPin1 = 6;
int trigPin2 = 4;
int echoPin2 = 5;

long duracao1, duracao2;

void setup() {
  Serial.begin(4800);
  pinMode(trigPin1, OUTPUT);
  pinMode(echoPin1, INPUT);
  pinMode(trigPin2, OUTPUT);
  pinMode(echoPin2, INPUT);
  digitalWrite(trigPin1, LOW);
  digitalWrite(trigPin2, LOW);
}

void loop() {
  
//Sensor da Direita
  digitalWrite(trigPin2, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin2, LOW);
  
  duracao2 = pulseIn(echoPin2, HIGH);
  
  long distancia2 = duracao2/58;
  
  Serial.print("d");
  Serial.println(distancia2);  
//---------------------------------  

//Sensor da Esquerda
  digitalWrite(trigPin1, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin1, LOW);

  duracao1 = pulseIn(echoPin1, HIGH);
  
  long distancia1 = duracao1/58;
  
  Serial.print("e");
  Serial.println(distancia1);

//---------------------------------  
  delay(100);
}
