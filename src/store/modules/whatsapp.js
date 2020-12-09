import PhoneAPI from './../../PhoneAPI'
import Vue from 'vue'

const state = {
  gruppi: [],
  messaggi: [],
  tempGroupInfo: []
}

const getters = {
  gruppi: ({ gruppi }) => gruppi,
  messaggi: ({ messaggi }) => messaggi,
  tempGroupInfo: ({ tempGroupInfo }) => tempGroupInfo
}

const actions = {
  leaveGroup ({ state, commit }, gruppo) {
    PhoneAPI.abbandonaGruppo(gruppo)
    commit('EXIT_GRUPPO', gruppo)
  },
  requestWhatsappInfo ({ state, commit }, groupId) {
    PhoneAPI.requestWhatsappMessaggi(groupId)
  },
  sendMessageInGroup ({ state, commit }, data) {
    PhoneAPI.sendMessageOnGroup(data.message, data.gruppo.id, data.phoneNumber)
  },
  updateGroupVars ({ state, commit }, data) {
    commit('UPDATE_GROUP_VARS', data)
  },
  creaGruppo ({ state, commit }, data) {
    PhoneAPI.postCreazioneGruppo(data)
  },
  showMessageNotification ({ state, commit }, data) {
    // console.log('showMessageNotification is triggered')
    // console.log(data.sender, data.label, data.message)
    PhoneAPI.sendAudioNotification()
    Vue.notify({
      message: data.message,
      title: data.sender + ' | ' + data.label + ':',
      icon: 'whatsapp',
      backgroundColor: 'rgba(0, 163, 0, 0.384)'
    })
    commit('ADD_MESSAGE_TO_GROUP', data)
  },
  editGroupTitle ({ commit }, data) {
    commit('UPDATE_GROUP_TITLE', data)
  },
  editGroupIcon ({ commit }, data) {
    commit('UPDATE_GROUP_ICON', data)
  }
}

const mutations = {
  EXIT_GRUPPO (state, data) {
    state.gruppi = state.gruppi.filter(gruppo => { return gruppo.id !== data.id })
  },
  UPDATE_MESSAGGI (state, data) {
    // console.log('updating messages in VUE mutuator')
    state.messaggi = data
    // console.log(JSON.stringify(data))
    // console.log(JSON.stringify(state.messaggi))
    // console.log('ho printato il json dei messaggi')
  },
  UPDATE_GROUP_VARS (state, data) {
    state.tempGroupInfo[data.key] = data.value
  },
  CLEAR_GROUP (state, data) {
    // console.log('clearing state.gruppi')
    // pulisco la table e la preparo per i nuovi valori
    state.gruppi = []
  },
  UPDATE_GROUP (state, data) {
    // console.log('updating state.gruppi with data, index is', state.gruppi.length)
    // console.log(JSON.stringify(data))
    // console.log('ho loggato il json di update_group')
    // qui aggiorno la lista dei gruppi di whatsapp
    state.gruppi[Number(state.gruppi.length)] = data
  },
  ADD_MESSAGE_TO_GROUP (state, data) {
    // console.log('sto inviando il messaggio', data.message, 'da', data.sender)
    // prima mi definisco una variabile temporanea
    // per salvare il messaggio nella table
    var message = { sender: data.sender, message: data.message }
    // qui controllo se la table con quell'id esiste o no quandoa aggiungo un messaggio
    if (state.messaggi === undefined || state.messaggi === null) { state.messaggi = [] }
    if (state.messaggi[String(data.id)] === undefined || state.messaggi[String(data.id)] === null) { state.messaggi[String(data.id)] = [] }
    // console.log('sto mettendo messaggi su', data.id)
    // poi li inserisco nella table dei messaggi
    state.messaggi[String(data.id)].push(message)
  },
  UPDATE_GROUP_TITLE (state, data) {
    for (var key in state.gruppi) {
      if (state.gruppi[key].id === data.gruppo.id) {
        state.gruppi[key].gruppo = data.text
        PhoneAPI.updateGroupInfo(state.gruppi[key])
        break
      }
    }
  },
  UPDATE_GROUP_ICON (state, data) {
    for (var key in state.gruppi) {
      if (state.gruppi[key].id === data.gruppo.id) {
        state.gruppi[key].icona = data.text
        PhoneAPI.updateGroupInfo(state.gruppi[key])
        break
      }
    }
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}

if (process.env.NODE_ENV !== 'production') {
  state.gruppi = [
    {
      id: 1,
      icona: 'https://u.trs.tn/tohqw.jpg',
      gruppo: 'Provo',
      partecipanti: ['5552828', '5552828'],
      partecipantiString: 'tanto questa viene rimpiazzata dal lua'
    },
    {
      id: 2,
      gruppo: 'Sto testando',
      partecipanti: ['5554444'],
      partecipantiString: 'tanto questa viene rimpiazzata dal lua'
    },
    {
      id: 520,
      gruppo: 'EZ CHAT',
      partecipanti: ['5554444'],
      partecipantiString: 'tanto questa viene rimpiazzata dal lua'
    }
  ]
  // Zona messaggi a gruppi //
  state.messaggi['2'] = []
  for (var i = 0; i < 100; i++) {
    state.messaggi['2'].push({sender: 'developer', message: 'message ' + i + ' mio'}, {sender: '4647278', message: 'messaggio ' + i + ' di altri'})
  }
  state.messaggi['1'] = [
    {
      sender: '5555555',
      message: 'provo il messaggio questo messaggio è superlungo | questo messaggio è superlungo | questo messaggio è superlungo | questo messaggio è superlungo'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: '5555555',
      message: 'provo il messaggio questo messaggio è superlungo | questo messaggio è superlungo | questo messaggio è superlungo | questo messaggio è superlungo'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: '5555555',
      message: 'provo il messaggio questo messaggio è superlungo | questo messaggio è superlungo | questo messaggio è superlungo | questo messaggio è superlungo'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: '5555555',
      message: 'provo il messaggio questo messaggio è superlungo | questo messaggio è superlungo | questo messaggio è superlungo | questo messaggio è superlungo'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: '5555555',
      message: 'provo il messaggio questo messaggio è superlungo | questo messaggio è superlungo | questo messaggio è superlungo | questo messaggio è superlungo'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: '5555555',
      message: 'provo il messaggio questo messaggio è superlungo | questo messaggio è superlungo | questo messaggio è superlungo | questo messaggio è superlungo'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: '5555555',
      message: 'provo il messaggio questo messaggio è superlungo | questo messaggio è superlungo | questo messaggio è superlungo | questo messaggio è superlungo'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'https://i.imgur.com/gthahbs.png'
    }
  ]
  state.messaggi['520'] = [
    {
      sender: '5555555',
      message: 'provo il messaggio questo messaggio è superlungo | questo messaggio è superlungo | questo messaggio è superlungo | questo messaggio è superlungo'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    },
    {
      sender: 'developer',
      message: 'provo il messaggio 2'
    }
  ]
}
