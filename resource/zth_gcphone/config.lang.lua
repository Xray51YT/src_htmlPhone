Config.ChosenLanguage = "it"

Config.Language = {
    ["it"] = {
        -- DEBUG
        ["ANIMATIONS_CLEANUP_DEBUG_1"] = "Eliminando props extra per restart o overflow",
        ["ANIMATIONS_CLEANUP_DEBUG_2"] = "L'utnete %s è uscito dal server: pulizia dei prop avviata",
        ["CACHING_STARTUP_1"] = "Cache dei numeri caricata dal database",
        ["CACHING_STARTUP_2"] = "Cache dei contatti caricata dal database",
        ["CACHING_STARTUP_3"] = "Cache dei messaggi caricati dal database",
        ["CACHING_STARTUP_4"] = "Telefono inizializzato",
        ["WIFI_LOAD_DEBUG_1"] = "Caricamento delle torri radio da database completato",
        ["WIFI_LOAD_DEBUG_2"] = "Caricamento dei router da database completato",
        ["WIFI_LOAD_DEBUG_3"] = "Sync state con database completato",
        ["WIFI_LOAD_DEBUG_4"] = "Modem wifi aggiornati con successo",
        ["WIFI_LOAD_DEBUG_5"] = "Controllo scadenze dei modem in corso",
        ["WIFI_LOAD_DEBUG_6"] = "Modem di %s è scaduto. Rimozione dal database in corso",
        ["WIFI_LOAD_DEBUG_7"] = "Modem di %s non può scadere",
        ["WIFI_LOAD_DEBUG_8"] = "Cache delle sim caricata dal database",
        ["DEBUG_STARTED_SAVING_OF_TARIFFS"] = "Avviato il salvataggio delle tariffe. Il server potrebbe laggare un pò",
        ["FIRSTNAME_LASTNAME_ERROR"] = "Impossibile ottenere il nome e il cognome, identifier non specificato: usando la source",
        ["CACHE_NUMBERS_1"] = "Aggiornato il numero %s per l'identifier %s",
        ["CACHE_NUMBERS_2"] = "Rimosso il numero %s dalla cache",
        ["CACHE_NUMBERS_3"] = "Utente %s sta entrando nel server, registrando %s come numero 'inUse'",
        ["CACHE_TWITTER_1"] = "Messaggi di twitter caricati in cache",
        ["CACHE_TWITTER_2"] = "Like di twitter caricati in cache",
        ["CACHE_INSTAGRAM_1"] = "Messaggi di instagram caricati in cache",
        ["CACHE_INSTAGRAM_2"] = "Like di instagram caricati in cache",

        -- CLIENT FILES
        ["APP_AZIENDA_NEW_EMERGENCY_CALL"] = "Nuova chiamata di emergenza",
        ["BLUETOOTH_CANNOT_GET_IMAGE"] = "~r~Impossibile ricevere l'immagine, bluetooth spento",
        ["BOURSE_CRYPTO_BOUGHT_OK"] = "~g~Hai comprato %sx %s per %s$ l'uno",
        ["BOURSE_CRYPTO_BOUGHT_ERROR"] = "~r~La trasnazione non è avvenuta con successo",
        ["BOURSE_CRYPTO_SELL_OK"] = "~g~Hai venduto %sx %s per %s$ l'uno",
        ["BOURSE_CRYPTO_SELL_ERROR"] = "~r~La trasnazione non è avvenuta con successo",
        ["SETTINGS_KEY_LABEL"] = "Apri il telefono",
        ["NO_PHONE_ITEM"] = "~r~Non hai un telefono con te",
        ["NO_PHONE_WHILE_DEAD"] = "~r~Non puoi usare il telefono da morto",
        ["NO_PHONE_WHILE_ARRESTED"] = "~r~Non puoi usare il telefono da ammanettato",
        ["SINGLE_UNREAD_MESSAGE_NOTIFICATION"] = "Hai ricevuto %s nuovo messaggo",
        ["MULTIPLE_UNREAD_MESSAGES_NOTIFICATION"] = "Hai ricevuto %s nuovi messaggi",
        ["MESSAGE_NOTIFICATION_NO_TRANSMITTER"] = "Hai ricevuto un messaggio",
        ["MESSAGE_NOTIFICATION_TRANSMITTER"] = "Hai ricevuto un messaggio da %s",
        ["HELPNOTIFICATION_COVER_SHOP_LABEL"] = "Premi ~INPUT_CONTEXT~ per acquistare una cover",
        ["COVER_SHOP_TITLE"] = "Negozio di cover",
        ["NO_COVER_LABEL"] = "Nessuna cover",
        ["COVER_BOUGHT_OK"] = "~g~Hai comprato una cover",
        ["COVER_BOUGHT_ERROR"] = "~r~Non hai abbastanza soldi per comprare una cover",
        ["HELPNOTIFICATION_MODEM_SHOP_LABEL"] = "Premi ~INPUT_CONTEXT~ per acquistare un modem",
        ["MODEM_CHOOSE_CREDENTIAL_SSID"] = "Digita il nome della rete",
        ["MODEM_CHOOSE_CREDENTIAL_PASSWD"] = "Digita la password della rete",
        ["MODEM_CHOOSE_CREDENTIAL_NEW_PASSWD"] = "Digita la nuova password della rete",
        ["MODEM_SHOP_TITLE"] = "Negozio internet",
        ["MODEM_WRONG_PASSWORD"] = "~r~Password non corretta",
        ["MODEM_CORRECT_PASSWORD"] = "~g~Password corretta, connesso alla rete!",
        ["PHONECALLS_AEREO_MODE_ERROR"] = "~r~Non puoi effetturare chiamate con la modalità aereo",
        ["VIDEOCALLS_AEREO_MODE_ERROR"] = "~r~Non puoi effettuare videochiamate con la modalità aereo",
        ["MESSAGES_AEREO_MODE_ERROR"] = "~r~Non puoi inviare messaggi con la modalità aereo",
        ["HELPNOTIFICATION_PHONE_BOXES_ANSWER"] = "Premi %s per rispondere al telefono",
        ["HELPNOTIFICATION_PHONE_BOXES_CALL"] = "Premi %s per avviare una telefonata",
        ["WHATSAPP_YOU_LABEL"] = "Tu",
        ["WHATSAPP_GROUP_UPDATED_OK"] = "~g~Gruppo aggiornato con successo",
        ["WHATSAPP_GROUP_UPDATED_ERROR"] = "~r~Impossibile aggiornare il gruppo",
        -- MODULES: SERVICES CALL
        ["EMERGENCY_CALL_CODE"] = "911",
        ["EMERGENCY_CALL_LABEL"] = "Chiamata di emergenza",
        ["EMERGENCY_CALL_BLIP_LABEL"] = "Emergenza",
        ["EMERGENCY_CALL_CALLER_LABEL"] = "Ufficio emergenze",
        ["EMERGENCY_CALL_MESSAGE"] = "Chiamata da #%s: %s",
        ["EMERGENCY_CALL_MESSAGE_ERROR"] = "~r~Il numero non è presente nel database del centralino",
        ["EMERGENCY_CALL_NO_NUMBER"] = "Sconosciuto",
        -- MODULES: SIM
        ["HELPNOTIFICATION_SIM_SHOP_LABEL"] = "Premi ~INPUT_CONTEXT~ per acquistare un piano tariffario",
        ["SETTINGS_SIM_KEY_LABEL"] = "Menù sim",
        ["SIM_MENU_TITLE"] = "Carte sim",
        ["SIM_MENU_CHOICE_1"] = "Installa",
        ["SIM_MENU_CHOICE_2"] = "Dai",
        ["SIM_MENU_CHOICE_3"] = "Rinomina",
        ["SIM_MENU_CHOICE_4"] = "Distruggi",
        ["SIM_USED_MESSAGE_OK"] = "Hai installato la sim %s",
        ["SIM_NO_PLAYER_NEARBY"] = "~r~Nessun giocatore nelle vicinanze",
        ["SIM_RENAME_MENU_LABEL"] = "Inserisci un nome, massimo 20 caratteri",
        ["SIM_RENAME_ERROR"] = "~r~Il nome non può superare i 20 caratteri",
        ["SIM_RENAME_OK"] = "~g~Sim rinominata con successo",
        ["SIM_RENAME_CANCEL"] = "~r~Operazione annullata",
        ["SIM_DESTROY_OK"] = "~g~Hai distrutto la sim %s",
        ["SIM_TARIFFS_SHOP_TITLE"] = "Offerte telefoniche",
        ["SIM_TARIFFS_SHOP_NO_OFFER"] = "Offerta: Nessuna offerta",
        ["SIM_TARIFFS_SHOP_CHOOSE_OFFER"] = "Compra un offerta telefonica",
        ["SIM_TARIFFS_OFFER_LABEL_1"] = "Offerta: %s",
        ["SIM_TARIFFS_OFFER_LABEL_2"] = "Minuti: %s",
        ["SIM_TARIFFS_OFFER_LABEL_3"] = "Messaggi: %s",
        ["SIM_TARIFFS_OFFER_LABEL_4"] = "Internet: %s",
        ["SIM_TARIFFS_OFFER_LABEL_5"] = "Cambia offerta",
        ["SIM_TARIFFS_OFFER_LABEL_6"] = "Rinnova offerta",
        ["SIM_TARIFFS_OFFER_LABEL_7"] = "Prezzo: %s$",
        ["SIM_TARIFFS_RENEWED_OK"] = "~g~Offerta rinnovata con successo",
        ["SIM_TARIFFS_RENEWED_ERROR"] = "~r~Non hai abbastanza soldi per rinnovare l'offerta",
        ["SIM_TARIFFS_OFFER_LABEL_BUY"] = "Completa l'acquisto",
        ["SIM_TARIFFS_BUY_OK"] = "~g~Offerta comprata con successo",
        ["SIM_TARIFFS_BUY_ERROR"] = "~r~Non hai abbatsanza soldi per completare l'acquisto",
        ["PHONE_TARIFFS_APP_LABEL_1"] = "Minuti",
        ["PHONE_TARIFFS_APP_LABEL_2"] = "Messaggi",
        ["PHONE_TARIFFS_APP_LABEL_3"] = "Internet",
        ["SIM_CREATED_MESSAGE_OK"] = "~g~Sim creata con successo",
        ["SIM_CREATED_MESSAGE_ERROR"] = "~r~Creazione della sim non riuscita",
        ["SIM_GIVEN_MESSAGE_1"] = "Hai dato la scheda sim %s",
        ["SIM_GIVEN_MESSAGE_2"] = "Hai ricevuto la scheda sim %s",
        -- MODULES: WIFI
        ["HELPNOTIFICATION_WIFI_RADIO_REPAIR"] = "Premi ~INPUT_CONTEXT~ per riparare la torre radio",
        ["WIFI_RADIO_TOWER_BLIP"] = "Torre radio",
        ["WIFI_BROKEN_RADIO_TOWER_BLIP"] = "Torre radio (rotta)",
        ["WIFI_MODEM_CREATED_OK"] = "~g~Rete creata con successo!",
        ["WIFI_MODEM_CREATED_ERROR"] = "~r~Impossibile creare la rete. Ne hai già una a tuo nome!",
        ["WIFI_MODEM_DELETE_OK"] = "~g~Rete rimossa con successo!",
        ["WIFI_MODEM_DELETE_ERROR"] = "~r~Impossibile rimuovere la rete!",
        ["WIFI_MODEM_UPDATE_OK"] = "~g~Rete aggiornata con successo",
        ["WIFI_MODEM_UPDATE_ERROR"] = "~r~Impossibile aggiornare la rete",
        -- SERVER FILES
        ["AZIENDA_PROMOTE_PLAYER_OK"] = "~g~%s %s promosso al grado %s [%s]",
        ["AZIENDA_PROMOTE_PLAYER_ERROR"] = "~r~Non puoi eseguire questa azione",
        ["AZIENDA_DEMOTE_PLAYER_OK_1"] = "~g~%s %s degradato al grado %s [%s]",
        ["AZIENDA_DEMOTE_PLAYER_OK_2"] = "~g~%s %s licenziato con successo",
        ["AZIENDA_DEMOTE_PLAYER_ERROR"] = "~r~Non puoi eseguire questa azione",
        ["BANK_IBAN_NOT_VALID"] = "~r~Iban non trovato o non valido",
        ["BANK_SEND_MONEY_TO_SELF_ERROR"] = "~r~Non puoi inviare soldi a te stesso",
        ["BANK_SENT_MONEY_TO_IBAN"] = "~g~Hai inviato %s$ all'iban %s",
        ["BANK_RECEIVED_MONEY_FROM_IBAN"] = "~g~Hai ricevuto un bonifico di %s$ dall'iban %s",
        ["BANK_SENT_MONEY_TO_OFFLINE_OK"] = "~g~Trasferimento completato con successo",
        ["BANK_SENT_MONEY_TO_OFFLINE_ERROR_1"] = "~r~Il valore inserito non è un numero",
        ["BANK_SENT_MONEY_TO_OFFLINE_ERROR_2"] = "~r~Non hai abbastanza internet per poter eseguire questa azione",
        ["BLUETOOTH_PICTURE_SENT_OK"] = "~g~Immagine inviata con successo",
        ["BLUETOOTH_ON"] = "~g~Bluetooth on",
        ["BLUETOOTH_OFF"] = "~r~Bluetooth off",
        ["MODEM_CREATION_TIMEOUT_MESSAGE"] = "~r~Devi aspettare almeno %s secondi prima di creare una rete",
        ["MODEM_NOT_ENOUGH_MONEY"] = "~r~Non hai abbastanza soldi",
        ["MODEM_BOUGHT_OK"] = "~g~Hai comprato un modem nuovo di zecca",
        ["MODEM_MENU_ARGS_1"] = "Comprato il %s",
        ["MODEM_MENU_ARGS_2"] = "Il tuo modem non scadrà",
        ["MODEM_MENU_ARGS_3"] = "Scade il %s",
        ["MODEM_MENU_ARGS_4"] = "SSID %s",
        ["MODEM_MENU_ARGS_5"] = "Password %s",
        ["MODEM_MENU_ARGS_6"] = "Rinnova il modem per %s$",
        ["MODEM_MENU_ARGS_7"] = "Non hai acquistato un modem",
        ["MODEM_MENU_ARGS_8"] = "Compra un modem per %s$",
        ["PHONEBOX_PHONE_OCCUPIED"] = "~r~Il telefono è occupato",
        ["PHONE_TARIFFS_NO_TARIFF"] = "~r~Non hai un piano tariffario",
        ["PHONE_TARIFFS_NO_MINUTES"] = "~r~Hai finito i minuti previsti dalla tua offerta",
        ["PHONE_TARIFFS_AIRPLANEMODE_ERROR"] = "~r~Non puoi chiamare con la modalità aereo",
        ["EMPTY_FIELD_LABEL"] = "Nessuno",
        ["ADD_CONTACT_ERROR"] = "~r~Devi inserire un numero e un titolo validi",
        ["ADD_MESSAGE_ERROR_1"] = "~r~Hai finito i messaggi previsti dal tuo piano tariffario",
        ["ADD_MESSAGE_ERROR_2"] = "~r~Non c'è segnale per mandare un messaggio",
        ["ADD_MESSAGE_ERROR_3"] = "~r~Impossibile mandare il messaggio, il numero selezionato non esiste",
        ["STARTCALL_MESSAGE_ERROR_1"] = "~r~Non c'è segnale per effettuare una telefonata",
        ["STARTCALL_MESSAGE_ERROR_2"] = "~r~Il telefono è occupato",
        ["STARTCALL_MESSAGE_ERROR_3"] = "~r~Non c'è segnale per effettuare una telefonata",
        ["STARTCALL_NO_SIM_INSTALLED"] = "~r~Devi avere una sim installata",
    },
    ["en"] = {
        -- DEBUG
        ["ANIMATIONS_CLEANUP_DEBUG_1"] = "Cleared extra props for restart or overflow",
        ["ANIMATIONS_CLEANUP_DEBUG_2"] = "User %s quit the server: cleanup started",
        ["CACHING_STARTUP_1"] = "Numbers cache loaded from sim database",
        ["CACHING_STARTUP_2"] = "Contacts cache loaded from phone contacts database",
        ["CACHING_STARTUP_3"] = "Messages cache loaded from phone messages database",
        ["CACHING_STARTUP_4"] = "Phone initialized",
        ["WIFI_LOAD_DEBUG_1"] = "Finished loading towers from database",
        ["WIFI_LOAD_DEBUG_2"] = "Finished loading routers from database",
        ["WIFI_LOAD_DEBUG_3"] = "Sync state with database completed",
        ["WIFI_LOAD_DEBUG_4"] = "Wifi modems updated succesfully",
        ["WIFI_LOAD_DEBUG_5"] = "Checking expired routers",
        ["WIFI_LOAD_DEBUG_6"] = "Modem owned by %s has expired. Removing it from databse",
        ["WIFI_LOAD_DEBUG_7"] = "Modem owned by %s cannot expire",
        ["WIFI_LOAD_DEBUG_8"] = "Tariffs cache loaded from phone sim database",
        ["DEBUG_STARTED_SAVING_OF_TARIFFS"] = "Started saving tariff plans. The server may lag a bit",
        ["FIRSTNAME_LASTNAME_ERROR"] = "Error getting firstname and lastname, identifier not specified: using source insted",
        ["CACHE_NUMBERS_1"] = "Updated number %s for identifier %s",
        ["CACHE_NUMBERS_2"] = "Removed number %s from the cache",
        ["CACHE_NUMBERS_3"] = "User %s is joining, registering %s as 'inUse' number",
        ["CACHE_TWITTER_1"] = "Twitter messages cache loaded",
        ["CACHE_TWITTER_2"] = "Twitter likes cache loaded",
        ["CACHE_INSTAGRAM_1"] = "Instagram messages cache loaded",
        ["CACHE_INSTAGRAM_2"] = "Instagram likes cache loaded",

        -- CLIENT FILES
        ["APP_AZIENDA_NEW_EMERGENCY_CALL"] = "New emergency call",
        ["BLUETOOTH_CANNOT_GET_IMAGE"] = "~r~Cannot receive image, bluetooth off",
        ["BOURSE_CRYPTO_BOUGHT_OK"] = "~g~You bought %sx %s for %s each",
        ["BOURSE_CRYPTO_BOUGHT_ERROR"] = "~r~Transaction went off with an error",
        ["BOURSE_CRYPTO_SELL_OK"] = "~g~You sold %sx %s for %s$ each",
        ["BOURSE_CRYPTO_SELL_ERROR"] = "~r~Transaction went off with an error",
        ["SETTINGS_KEY_LABEL"] = "Open the phone",
        ["NO_PHONE_ITEM"] = "~r~You do not have a phone",
        ["NO_PHONE_WHILE_DEAD"] = "~r~You can't use the phone while dead",
        ["NO_PHONE_WHILE_ARRESTED"] = "~r~You can't use the phone when handcuffed",
        ["SINGLE_MESSAGE_NOTIFICATION"] = "You have recived %s message",
        ["MULTIPLE_MESSAGES_NOTIFICATION"] = "You have recived %s messages",
        ["MESSAGE_NOTIFICATION_NO_TRANSMITTER"] = "You received a message",
        ["MESSAGE_NOTIFICATION_TRANSMITTER"] = "You received a message from %s",
        ["HELPNOTIFICATION_COVER_SHOP_LABEL"] = "Press ~INPUT_CONTEXT~ to buy a cover",
        ["COVER_SHOP_TITLE"] = "Cover shop",
        ["NO_COVER_LABEL"] = "No cover",
        ["COVER_BOUGHT_OK"] = "~g~You have bought a cover",
        ["COVER_BOUGHT_ERROR"] = "~r~You do not have enough money to buy a cover",
        ["HELPNOTIFICATION_MODEM_SHOP_LABEL"] = "Press ~INPUT_CONTEXT~ to buy a modem",
        ["MODEM_CHOOSE_CREDENTIAL_SSID"] = "Insert the WiFi name",
        ["MODEM_CHOOSE_CREDENTIAL_PASSWD"] = "Insert the WiFi password",
        ["MODEM_CHOOSE_CREDENTIAL_NEW_PASSWD"] = "Insert the new WiFi password",
        ["MODEM_SHOP_TITLE"] = "Web store",
        ["MODEM_WRONG_PASSWORD"] = "~r~Wrong password",
        ["MODEM_CORRECT_PASSWORD"] = "~g~You're now connected to the WiFi!",
        ["PHONECALLS_AEREO_MODE_ERROR"] = "~r~You can't make calls while on plane mode",
        ["VIDEOCALLS_AEREO_MODE_ERROR"] = "~r~You can't make video calls while on plane mode",
        ["MESSAGES_AEREO_MODE_ERROR"] = "~r~You can't send messages while on plane mode",
        ["HELPNOTIFICATION_PHONE_BOXES_ANSWER"] = "Press %s to answer the phone",
        ["HELPNOTIFICATION_PHONE_BOXES_CALL"] = "Press %s to use the public phone",
        ["WHATSAPP_YOU_LABEL"] = "You",
        ["WHATSAPP_GROUP_UPDATED_OK"] = "~g~Group updated successfully",
        ["WHATSAPP_GROUP_UPDATED_ERROR"] = "~r~There was an error on updating the group",
        -- MODULES: SERVICES CALL
        ["EMERGENCY_CALL_CODE"] = "911",
        ["EMERGENCY_CALL_LABEL"] = "Emergency call",
        ["EMERGENCY_CALL_BLIP_LABEL"] = "Emergency",
        ["EMERGENCY_CALL_CALLER_LABEL"] = "Dispatch",
        ["EMERGENCY_CALL_MESSAGE"] = "Message from #%s: %s",
        ["EMERGENCY_CALL_MESSAGE_ERROR"] = "~r~This number does not exists",
        ["EMERGENCY_CALL_NO_NUMBER"] = "Unknown",
        -- MODULES: SIM
        ["HELPNOTIFICATION_SIM_SHOP_LABEL"] = "Press ~INPUT_CONTEXT~ to buy a plan for a sim",
        ["SETTINGS_SIM_KEY_LABEL"] = "Sim menù",
        ["SIM_MENU_TITLE"] = "Sim cards",
        ["SIM_MENU_CHOICE_1"] = "Install",
        ["SIM_MENU_CHOICE_2"] = "Give",
        ["SIM_MENU_CHOICE_3"] = "Change name",
        ["SIM_MENU_CHOICE_4"] = "Destroy",
        ["SIM_USED_MESSAGE_OK"] = "You have installed the sim %s",
        ["SIM_NO_PLAYER_NEARBY"] = "~r~No players nearby",
        ["SIM_RENAME_MENU_LABEL"] = "Please type a name, max 20 characters",
        ["SIM_RENAME_ERROR"] = "~r~Name can't contain more than 20 characters",
        ["SIM_RENAME_OK"] = "~g~Sim renamed successfully",
        ["SIM_RENAME_CANCEL"] = "~r~Operation cancelled",
        ["SIM_DESTROY_OK"] = "~g~You have deleted the sim %s",
        ["SIM_TARIFFS_SHOP_TITLE"] = "Telephone offers",
        ["SIM_TARIFFS_SHOP_NO_OFFER"] = "Offer: no offer",
        ["SIM_TARIFFS_SHOP_CHOOSE_OFFER"] = "Buy a telephone offer",
        ["SIM_TARIFFS_OFFER_LABEL_1"] = "Offer name: %s",
        ["SIM_TARIFFS_OFFER_LABEL_2"] = "Minutes: %s",
        ["SIM_TARIFFS_OFFER_LABEL_3"] = "Messages: %s",
        ["SIM_TARIFFS_OFFER_LABEL_4"] = "Internet: %s",
        ["SIM_TARIFFS_OFFER_LABEL_5"] = "Change offer",
        ["SIM_TARIFFS_OFFER_LABEL_6"] = "Renew current offer",
        ["SIM_TARIFFS_OFFER_LABEL_7"] = "Price: %s$",
        ["SIM_TARIFFS_RENEWED_OK"] = "~g~Offer renewed successfully",
        ["SIM_TARIFFS_RENEWED_ERROR"] = "~r~You do not have enough money to renew this offer",
        ["SIM_TARIFFS_OFFER_LABEL_BUY"] = "Buy this offer",
        ["SIM_TARIFFS_BUY_OK"] = "~g~Offer bought successfully",
        ["SIM_TARIFFS_BUY_ERROR"] = "~r~You do not have enough money to buy this offer",
        ["PHONE_TARIFFS_APP_LABEL_1"] = "Minutes",
        ["PHONE_TARIFFS_APP_LABEL_2"] = "Messages",
        ["PHONE_TARIFFS_APP_LABEL_3"] = "Internet",
        ["SIM_CREATED_MESSAGE_OK"] = "~g~Sim created successfully",
        ["SIM_CREATED_MESSAGE_ERROR"] = "~r~There was an error creating the number",
        ["SIM_GIVEN_MESSAGE_1"] = "You gave the sim card %s",
        ["SIM_GIVEN_MESSAGE_2"] = "You got the sim card %s",
        -- MODULES: WIFI
        ["HELPNOTIFICATION_WIFI_RADIO_REPAIR"] = "Press ~INPUT_CONTEXT~ to fix this radio tower",
        ["WIFI_RADIO_TOWER_BLIP"] = "Radio tower",
        ["WIFI_BROKEN_RADIO_TOWER_BLIP"] = "Radio tower (broken)",
        ["WIFI_MODEM_CREATED_OK"] = "~g~Network created successfully",
        ["WIFI_MODEM_CREATED_ERROR"] = "~r~Cannot create this network. You already have one",
        ["WIFI_MODEM_DELETE_OK"] = "~g~Network removed successfully",
        ["WIFI_MODEM_DELETE_ERROR"] = "~r~There was an error while removing this network",
        ["WIFI_MODEM_UPDATE_OK"] = "~g~Network updated successfully",
        ["WIFI_MODEM_UPDATE_ERROR"] = "~r~There was an error while updating the network",
        -- SERVER FILES
        ["AZIENDA_PROMOTE_PLAYER_OK"] = "~g~%s %s has been promoted to grade %s [%s]",
        ["AZIENDA_PROMOTE_PLAYER_ERROR"] = "~r~You can't do this",
        ["AZIENDA_DEMOTE_PLAYER_OK_1"] = "~g~%s %s has been degraded to grade %s [%s]",
        ["AZIENDA_DEMOTE_PLAYER_OK_2"] = "~g~%s %s has been fired from the job",
        ["AZIENDA_DEMOTE_PLAYER_ERROR"] = "~r~You can't do this",
        ["BANK_IBAN_NOT_VALID"] = "~r~Iban not found or not valid",
        ["BANK_SEND_MONEY_TO_SELF_ERROR"] = "~r~You can't send money to your own account",
        ["BANK_SENT_MONEY_TO_IBAN"] = "~g~You've sent %s$ to the account %s",
        ["BANK_RECEIVED_MONEY_FROM_IBAN"] = "~g~You've received %s$ from the account %s",
        ["BANK_SENT_MONEY_TO_OFFLINE_OK"] = "~g~Money transfer completed successfully",
        ["BANK_SENT_MONEY_TO_OFFLINE_ERROR_1"] = "~r~The value you used is not a number",
        ["BANK_SENT_MONEY_TO_OFFLINE_ERROR_2"] = "~r~You have not enough internet to do this",
        ["BLUETOOTH_PICTURE_SENT_OK"] = "~g~Picture sent successfully",
        ["BLUETOOTH_ON"] = "~g~Bluetooth on",
        ["BLUETOOTH_OFF"] = "~r~Bluetooth off",
        ["MODEM_CREATION_TIMEOUT_MESSAGE"] = "~r~You have to wait at least %s seconds before creating a new network",
        ["MODEM_NOT_ENOUGH_MONEY"] = "~r~You don'y have enough money",
        ["MODEM_BOUGHT_OK"] = "~g~You bought a modem successfully",
        ["MODEM_MENU_ARGS_1"] = "Bought on %s",
        ["MODEM_MENU_ARGS_2"] = "Your modem will never expire",
        ["MODEM_MENU_ARGS_3"] = "Expire on %s",
        ["MODEM_MENU_ARGS_4"] = "SSID %s",
        ["MODEM_MENU_ARGS_5"] = "Password %s",
        ["MODEM_MENU_ARGS_6"] = "Renew your network for %s$",
        ["MODEM_MENU_ARGS_7"] = "You did not buy a modem",
        ["MODEM_MENU_ARGS_8"] = "Buy a modem for %s$",
        ["PHONEBOX_PHONE_OCCUPIED"] = "~r~The phone is occupied",
        ["PHONE_TARIFFS_NO_TARIFF"] = "~r~You don't have a phone tariff plan",
        ["PHONE_TARIFFS_NO_MINUTES"] = "~r~You have run out of minutes for your offer",
        ["PHONE_TARIFFS_AIRPLANEMODE_ERROR"] = "~r~You cannot call with airplane mode",
        ["EMPTY_FIELD_LABEL"] = "None",
        ["ADD_CONTACT_ERROR"] = "~r~You need to write valid number and title",
        ["ADD_MESSAGE_ERROR_1"] = "~r~You have finished the messages required by your tariff plan",
        ["ADD_MESSAGE_ERROR_2"] = "~r~There is no signal to send a message",
        ["ADD_MESSAGE_ERROR_3"] = "~r~Unable to send the message, the selected number does not exist",
        ["STARTCALL_MESSAGE_ERROR_1"] = "~r~There is no signal to make a phone call",
        ["STARTCALL_MESSAGE_ERROR_2"] = "~r~The phone is busy",
        ["STARTCALL_MESSAGE_ERROR_3"] = "~r~There is no signal to make a phone call",
        ["STARTCALL_NO_SIM_INSTALLED"] = "~r~You must have a sim in the phone",
    }
}

Config.Language = Config.Language[Config.ChosenLanguage]