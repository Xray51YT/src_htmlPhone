import Vue from 'vue'
import PhoneAPI from './../../PhoneAPI'

const state = {
  show: process.env.NODE_ENV !== 'production',
  tempoHide: false,
  myPhoneNumber: '555#####',
  background: JSON.parse(window.localStorage['gc_background'] || null),
  currentCover: JSON.parse(window.localStorage['gc_cover'] || null),
  myCovers: [],
  sonido: JSON.parse(window.localStorage['gc_sonido'] || null),
  zoom: window.localStorage['gc_zoom'] || '100%',
  volume: parseFloat(window.localStorage['gc_volume']) || 0.5,
  tts: window.localStorage['gc_tts'] || false,
  lang: window.localStorage['gc_language'],
  notification: (window.localStorage['gc_notification'] === null || window.localStorage['gc_notification'] === undefined) ? true : window.localStorage['gc_notification'],
  config: {
    reseau: 'Code',
    useFormatNumberFrance: false,
    apps: [],
    themeColor: '#3399FF',
    colors: ['#0066CC'],
    language: {}
  }
}

const getters = {
  show: ({ show }) => show,
  tempoHide: ({ tempoHide }) => tempoHide,
  myPhoneNumber: ({ myPhoneNumber }) => myPhoneNumber,
  volume: ({ volume }) => volume,
  tts: ({ tts }) => tts,
  notification: ({ notification }) => notification,
  enableTakePhoto: ({ config }) => config.enableTakePhoto === true,
  background: ({ background, config }) => {
    if (background === null) {
      if (config.background_default !== undefined) {
        return config.background_default
      }
      return {
        label: 'Default',
        value: 'default.jpg'
      }
    }
    return background
  },
  backgroundLabel: (state, getters) => getters.background.label,
  backgroundURL: (state, getters) => {
    if (getters.background.value !== undefined) {
      if (getters.background.value.startsWith('http') === true) {
        return getters.background.value
      }
    }
    return '/html/static/img/background/' + getters.background.value
  },
  sonido: ({ sonido, config }) => {
    if (sonido === null) {
      if (config && config.sonido_default !== undefined) {
        return config.sonido_default
      }
      return {
        label: 'Panters',
        value: 'ring.ogg'
      }
    }
    return sonido
  },
  currentCover: ({ currentCover, config }) => {
    if (currentCover === null) {
      if (window.localStorage['gc_cover'] !== undefined && window.localStorage['gc_cover'] !== null) {
        return JSON.parse(window.localStorage['gc_cover'])
      }
      return {
        label: 'Nessuna cover',
        value: 'base.png'
      }
    }
    return currentCover
  },
  myCovers: ({ myCovers }) => myCovers,
  sonidoLabel: (state, getters) => getters.sonido.label,
  zoom: ({ zoom }) => zoom,
  config: ({ config }) => config,
  warningMessageCount: ({ config }) => config.warningMessageCount || 250,
  useFormatNumberFrance: ({ config }) => config.useFormatNumberFrance,
  themeColor: ({ config }) => config.themeColor,
  colors: ({ config }) => config.colors,
  Apps: ({ config, lang }, getters) => config.apps
    .filter(app => app.enabled !== false)
    .map(app => {
      if (app.puceRef !== undefined) {
        app.puce = getters[app.puceRef]
      }
      const keyName = `${lang}__name`
      app.intlName = app[keyName] || app.name
      return app
    }),
  AppsHome: (state, getters) => getters.Apps.filter(app => app.inHomePage === true),
  availableLanguages ({ config }) {
    const langKey = Object.keys(config.language)
    const AvailableLanguage = {}
    for (const key of langKey) {
      AvailableLanguage[config.language[key].NAME] = {value: key, icons: 'fa-flag'}
    }
    return AvailableLanguage
  },
  IntlString ({ config, lang }) {
    lang = lang || config.defaultLanguage
    if (config.language[lang] === undefined) {
      return (LABEL) => LABEL
    }
    return (LABEL, defaultValue) => {
      return config.language[lang][LABEL] || defaultValue || LABEL
    }
  }
}

const actions = {
  async loadConfig ({ commit, state }) {
    const config = await PhoneAPI.getConfig()
    const keyLang = Object.keys(config.language)
    for (const key of keyLang) {
      const timeAgoConf = config.language[key].TIMEAGO
      if (timeAgoConf !== undefined) {
        Vue.prototype.$timeago.addLocale(key, timeAgoConf)
      }
    }
    Vue.prototype.$timeago.setCurrentLocale(state.lang)
    if (config.defaultContacts !== undefined) {
      commit('SET_DEFAULT_CONTACTS', config.defaultContacts)
    }
    commit('SET_CONFIG', config)
  },
  setEnableApp ({ commit, state }, { appName, enable = true }) {
    commit('SET_APP_ENABLE', { appName, enable })
  },
  setVisibility ({ commit }, show) {
    commit('SET_PHONE_VISIBILITY', show)
  },
  setZoom ({ commit }, zoom) {
    window.localStorage['gc_zoom'] = zoom
    commit('SET_ZOOM', zoom)
  },
  setBackground ({ commit }, background) {
    window.localStorage['gc_background'] = JSON.stringify(background)
    commit('SET_BACKGROUND', background)
  },
  setCurrentCover ({ commit }, cover) {
    window.localStorage['gc_cover'] = JSON.stringify(cover)
    commit('SET_CURRENT_COVER', cover)
  },
  setSonido ({ commit }, sonido) {
    window.localStorage['gc_sonido'] = JSON.stringify(sonido)
    commit('SET_SONIDO', sonido)
  },
  toggleNotifications ({ commit, state }) {
    commit('TOGGLE_NOTIFICATIONS')
    PhoneAPI.updateNotifications(state.notification)
    window.localStorage['gc_notification'] = state.notification
  },
  setVolume ({ commit }, volume) {
    window.localStorage['gc_volume'] = volume
    commit('SET_VOLUME', volume)
    PhoneAPI.updateVolume({ volume: volume })
  },
  setLanguage ({ commit }, lang) {
    window.localStorage['gc_language'] = lang
    Vue.prototype.$timeago.setCurrentLocale(lang)
    commit('SET_LANGUAGE', lang)
  },
  closePhone () {
    PhoneAPI.closePhone()
  },
  resetPhone ({ dispatch, getters }) {
    dispatch('setZoom', '100%')
    dispatch('setVolume', 1)
    dispatch('setBackground', getters.config.background_default)
    dispatch('setCurrentCover', getters.config.cover_default)
    dispatch('setSonido', getters.config.sonido_default)
    dispatch('setLanguage', 'it_IT')
  },
  sendStartupValues ({ state }) {
    var data = { volume: state.volume, notification: state.notification, cover: state.currentCover }
    PhoneAPI.sendStartupValues(data)
  },
  setTTS ({ state, commit }, bool) {
    commit('UPDATE_TTS', bool)
    window.localStorage['gc_tts'] = bool
    if (bool) { PhoneAPI.speakTTS('Lettura chiamate, attiva', state.volume) }
  }
}

const mutations = {
  SET_CONFIG (state, config) {
    state.config = config
  },
  SET_APP_ENABLE (state, {appName, enable}) {
    const appIndex = state.config.apps.findIndex(app => app.name === appName)
    if (appIndex !== -1) {
      Vue.set(state.config.apps[appIndex], 'enabled', enable)
    }
  },
  SET_PHONE_VISIBILITY (state, show) {
    state.show = show
    state.tempoHide = false
  },
  SET_TEMPO_HIDE (state, hide) {
    state.tempoHide = hide
  },
  SET_MY_PHONE_NUMBER (state, myPhoneNumber) {
    state.myPhoneNumber = myPhoneNumber
  },
  SET_BACKGROUND (state, background) {
    state.background = background
  },
  SET_CURRENT_COVER (state, cover) {
    state.currentCover = cover
    // console.log(state.currentCover)
  },
  UPDATE_MY_COVERS (state, data) {
    state.myCovers = data
  },
  SET_SONIDO (state, sonido) {
    state.sonido = sonido
  },
  SET_ZOOM (state, zoom) {
    state.zoom = zoom
  },
  SET_VOLUME (state, volume) {
    state.volume = volume
  },
  SET_LANGUAGE (state, lang) {
    state.lang = lang
  },
  TOGGLE_NOTIFICATIONS (state) {
    state.notification = !state.notification
  },
  UPDATE_TTS (state, bool) {
    state.tts = bool
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}

if (process.env.NODE_ENV !== 'production') {
  // qui ci andrà l'phoneNumber
  state.myPhoneNumber = 'developer'
}
