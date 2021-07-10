// import PhoneAPI from './../../PhoneAPI'
// import CurrentTime from './CurrentTime'
// tutto questo codice è trovabile sulle impostazioni del telefono

const state = {
  fotografie: JSON.parse(window.localStorage['gc_fotografie'] || null) || []
}

const getters = {
  fotografie: ({ fotografie }) => fotografie
}

const actions = {
  addPhoto ({ commit, state }, data) {
    commit('APP_PHOTO', data)
    window.localStorage['gc_fotografie'] = JSON.stringify(state.fotografie)
    // console.log(JSON.stringify(window.localStorage['gc_fotografie']))
  },
  clearGallery ({ commit, state }) {
    commit('CLEAR_GALLERY')
    window.localStorage['gc_fotografie'] = []
  },
  deleteSinglePicture ({ commit, state }, index) {
    commit('DELETE_PICTURE', index)
  }
}

const mutations = {
  APP_PHOTO (state, data) {
    var foto = { link: data.link }
    state.fotografie.push(foto)
  },
  CLEAR_GALLERY (state) {
    state.fotografie = []
  },
  DELETE_PICTURE (state, index) {
    state.fotografie.splice(index - 1, 1)
    window.localStorage['gc_fotografie'] = JSON.stringify(state.fotografie)
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}

if (process.env.NODE_ENV !== 'production') {
  state.fotografie = [
    {
      link: 'https://u.trs.tn/tohqw.jpg',
      data: 'bo forse'
    },
    {
      link: 'https://i.imgur.com/rNXepFS.jpeg',
      data: 'bo forse'
    },
    {
      link: 'https://i.imgur.com/InUodqS.jpeg',
      data: 'bo forse'
    },
    {
      link: 'https://i.imgur.com/LQukntX.jpeg',
      data: 'bo forse'
    },
    {
      link: 'https://i.imgur.com/KIpi534.jpeg',
      data: 'bo forse'
    }
  ]
}
