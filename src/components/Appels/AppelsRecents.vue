<template>
  <div class="elements">
    <div class="element" :class="{'active': selectIndex === key}" v-for='(histo, key) in _callsHistory' :key="key">
      <!--<div @click.stop="selectItem(histo)" class="elem-pic" :style="stylePuce(histo)">{{histo.letter}}</div>-->
      <img style="width: 32px; margin-left: 10px;" src="/html/static/img/icons_app/borrado.png">

      <div class="elem-content">
        <div class="elem-content-p">{{ histo.display }}</div>

        <div class="elem-content-s">
          <div class="elem-histo-pico" :class="{'reject': hc.accept === false}" v-for="(hc, i) in histo.lastCall" :key="i">
            <svg v-if="hc.accepts === 1 && hc.incoming === 1" viewBox="0 0 24 24" fill="#c5c5c7">
              <path d="M9,5v2h6.59L4,18.59L5.41,20L17,8.41V15h2V5H9z"/>
            </svg>

            <svg v-else-if="hc.accepts === 1 && hc.incoming === 0" viewBox="0 0 24 24" fill="#c5c5c7">
              <path d="M20,5.41L18.59,4L7,15.59V9H5v10h10v-2H8.41L20,5.41z"/>
            </svg>

            <svg v-else-if="hc.accepts === 0 && hc.incoming === 1" viewBox="0 0 24 24" fill="#c5c5c7">
              <path d="M3,8.41l9,9l7-7V15h2V7h-8v2h4.59L12,14.59L4.41,7L3,8.41z"/>
            </svg>

            <svg v-else-if="hc.accepts === 0 && hc.incoming === 0" viewBox="0 0 24 24" fill="#c5c5c7">
              <path d="M19.59,7L12,14.59L6.41,9H11V7H3v8h2v-4.59l7,7l9-9L19.59,7z"/>
            </svg>
          </div>

          <!--<div v-if="histo.lastCall.length !==0" class="lastCall">
            <timeago :since='histo.lastCall[0].date' :auto-update="20"></timeago>
          </div>-->
        </div>
        <div style="float: right; margin-top: -43px;" v-if="histo.lastCall.length !==0" class="lastCall">
          <timeago class="time" :since='histo.lastCall[0].date' :auto-update="20"></timeago>
        </div>
      </div>
      <!--<div class="elem-icon" @click.stop="selectItem(histo)">
        <i class="fa fa-phone" @click.stop="selectItem(histo)"></i>
      </div>-->

    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import { groupBy, generateColorForStr } from '@/Utils'
import Modal from '@/components/Modal/index.js'

export default {
  name: 'Recents',
  components: {},
  data () {
    return {
      selectIndex: 0
    }
  },
  methods: {
    ...mapActions(['deletePhoneHistory', 'deleteAllPhoneHistory', 'updateIgnoredControls']),
    getContact (num) {
      const find = this.contacts.find(e => e.number === num)
      return find
    },
    scrollIntoView: function () {
      this.$nextTick(() => {
        const elem = this.$el.querySelector('.active')
        if (elem) elem.scrollIntoView({ behavior: 'smooth', block: 'start', inline: 'nearest' })
      })
    },
    onUp () {
      if (this.ignoreControls) return
      this.selectIndex = Math.max(0, this.selectIndex - 1)
      this.scrollIntoView()
    },
    onDown () {
      if (this.ignoreControls) return
      this.selectIndex = Math.min(this._callsHistory.length - 1, this.selectIndex + 1)
      this.scrollIntoView()
    },
    async selectItem (item) {
      const numero = item.num
      const isValid = numero.startsWith('#') === false
      this.updateIgnoredControls(true)
      let scelte = [
        {id: 4, title: this.LangString('APP_PHONE_ADD'), icons: 'fa-plus'},
        {id: 1, title: this.LangString('APP_PHONE_DELETE'), icons: 'fa-trash', color: 'orange'},
        {id: 2, title: this.LangString('APP_PHONE_DELETE_ALL'), icons: 'fa-trash', color: 'red'},
        {id: 3, title: this.LangString('APP_PHONE_CANCEL'), icons: 'fa-undo', color: 'red'}
      ]
      if (isValid) {
        scelte = [{id: 5, title: this.LangString('APP_PHONE_SEND_MESSAGE'), icons: 'fa-sms'}, ...scelte]
        scelte = [{id: 6, title: this.LangString('APP_PHONE_CALL_ANONYMOUS'), icons: 'fa-mask'}, ...scelte]
        scelte = [{id: 0, title: this.LangString('APP_PHONE_CALL'), icons: 'fa-phone'}, ...scelte]
      }
      Modal.CreateModal({ scelte })
      .then(resp => {
        switch (resp.id) {
          case 0:
            this.$phoneAPI.startCall({ numero })
            this.updateIgnoredControls(false)
            break
          case 1:
            this.deletePhoneHistory({ numero })
            this.updateIgnoredControls(false)
            break
          case 2:
            this.deleteAllPhoneHistory()
            this.updateIgnoredControls(false)
            break
          case 4:
            this.save(numero)
            this.updateIgnoredControls(false)
            break
          case 5:
            this.$router.push({ name: 'messages.view', params: { display: item.display, number: numero } })
            this.updateIgnoredControls(false)
            break
          case 6:
            this.$phoneAPI.startCall({ numero: '#' + numero })
            this.updateIgnoredControls(false)
            break
        }
      })
      .catch(e => { this.updateIgnoredControls(false) })
    },
    async onEnter () {
      if (this.ignoreControls) return
      if (this._callsHistory[this.selectIndex] === null || this._callsHistory[this.selectIndex] === undefined) return
      this.selectItem(this._callsHistory[this.selectIndex])
    },
    save (numero) {
      if (this.id !== -1) {
        this.$router.push({ name: 'contacts.view', params: { id: -1, number: numero } })
      }
      // ma vaffanculo dioporco
      // history.back()
    },
    stylePuce (data) {
      data = data || {}
      if (data.icon !== undefined) {
        return {
          backgroundImage: `url(${data.icon})`,
          backgroundSize: 'cover',
          color: 'rgba(0,0,0,0)'
        }
      }
      return {
        color: data.color || this.color,
        backgroundColor: data.backgroundColor || this.backgroundColor,
        borderRadius: '50%'
      }
    }
  },
  computed: {
    ...mapGetters(['LangString', 'callsHistory', 'contacts', 'ignoreControls', 'contacts', 'messages']),
    _callsHistory () {
      let grpHist = groupBy(this.callsHistory, 'num')
      let hist = []
      for (let key in grpHist) {
        const hg = grpHist[key]
        const histoByDate = hg.map(e => { e.date = new Date(e.time); return e }).sort((a, b) => { return b.date - a.date }).slice(0, 6)
        const contact = this.getContact(key) || { letter: '#' }
        hist.push({
          num: key,
          display: contact.display || key,
          lastCall: histoByDate,
          letter: contact.letter || contact.display[0],
          backgroundColor: contact.backgroundColor || generateColorForStr(key),
          icon: contact.icon
        })
      }
      hist.sort((a, b) => { return b.lastCall[0].time - a.lastCall[0].time })
      return hist
    }
  },
  created () {
    this.$bus.$on('keyUpArrowDown', this.onDown)
    this.$bus.$on('keyUpArrowUp', this.onUp)
    this.$bus.$on('keyUpEnter', this.onEnter)
  },
  beforeDestroy () {
    this.$bus.$off('keyUpArrowDown', this.onDown)
    this.$bus.$off('keyUpArrowUp', this.onUp)
    this.$bus.$off('keyUpEnter', this.onEnter)
  }
}
</script>

<style scoped>
.content {
  height: 100%;
}

.elements {
  overflow-y: auto;
  margin-left: -8px
}

.element {
  height: 58px;
  line-height: 58px;
  display: flex;
  align-items: center;
  position: relative;
  margin: 14px 10px;
  border-radius: 2px;
}

.active {
  background: radial-gradient(rgba(3, 168, 244, 0.14), rgba(3, 169, 244, 0.26));
}

.elem-pic {
  margin-left: 12px;
  height: 48px;
  width: 48px;
  text-align: center;
  line-height: 48px;
  font-weight: 700;
  border-radius: 50%;
  color: white;
}

.time {
  margin-right: 12px;
  font-size: 13px;
  font-weight: 500;
  color: #c8c7cb;
}

.elem-content {
  margin-left: 12px;
  width: auto;
  flex-grow: 1;
  margin-top: 13px;
}

.elem-content-p {
  font-size: 20px;
  margin-top: 15px;
  font-weight: bolder;
  line-height: 20px;
  width: 153px;
}

.elem-content-s {
  font-size: 12px;
  line-height: 18px;
  width: 137px;
  display: flex;
}

.elem-histo-pico {
  display: flex;
  flex-direction: column;
}

.elem-histo-pico svg {
  width: 16px;
  height: 16px;
  margin-left: 6px;
}

.lastCall {
  padding-left: 4px;
}

.elem-icon {
  width: 28px;
}
</style>
