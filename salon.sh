#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ SALON VIP ~~~~~"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nWelcome to SALON VIP, how can I help you?"
  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim\n6) Exit"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) APPOINTMENT ;;
    2) APPOINTMENT ;;
    3) APPOINTMENT ;;
    4) APPOINTMENT ;;
    5) APPOINTMENT ;;
    6) EXIT ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

APPOINTMENT() {
  # get customers info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  # check if customer is already registered
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    #get customers name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    #Insert new customer
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers (phone,name) VALUES ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi
  
  #get customer ID
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  
  #get service name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    
  #Ask to schedule an appointment
  echo -e "\nWhat time would you like your$SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME

  # insert appointment
  NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

  #Confirm appointment info
  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

}

EXIT() {
echo -e "\nThank you for your time."
}
MAIN_MENU

