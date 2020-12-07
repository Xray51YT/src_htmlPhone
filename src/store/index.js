import Vue from 'vue'
import Vuex from 'vuex'

import phone from './modules/phone'
import contacts from './modules/contacts'
import messages from './modules/messages'
import appels from './modules/appels'
import bank from './modules/bank'
import bourse from './modules/bourse'
import tchat from './modules/tchat'
import twitter from './modules/twitter'
import dati from './modules/dati'
import wifi from './modules/wifi'
import instagram from './modules/instagram'
import whatsapp from './modules/whatsapp'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    phone,
    contacts,
    messages,
    appels,
    bank,
    bourse,
    tchat,
    twitter,
    dati,
    wifi,
    instagram,
    whatsapp
  },
  strict: true
})
