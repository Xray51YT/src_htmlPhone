<template>
  <div style="width: 100%; height: 630px; overflow: hidden;">

    <div class="chat-container">

      <div class="chat-messages-container">
        <div class="chat-message-container" v-for="(elem, key) in aziendaMessages" :key="key">
          <div :class="{ selected: key === currentSelected }" class="chat-message-bouble-mine" v-if="elem.mine">
            <span class="chat-message-bouble-author">{{ elem.author }}</span>
            <p class="chat-message-bouble-message">{{ formatEmoji(elem.message) }}</p>
          </div>
          <div :class="{ selected: key === currentSelected }" class="chat-message-bouble" v-else>
            <span class="chat-message-bouble-author">{{ elem.author }} ({{ elem.authorPhone }})</span>
            <p class="chat-message-bouble-message">{{ formatEmoji(elem.message) }}</p>
          </div>
        </div>
      </div>

      <div class="chat-send-container">
        <div class="chat-send-bg">
          <span class="chat-send-placeholder">{{ LangString("APP_AZIENDA_MESSAGE_PLACEHOLDER") }}</span>
          <i class="chat-send-placeholder-icon fa fa-paper-plane" aria-hidden="true"></i>
        </div>
      </div>

    </div>

  </div>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from 'vuex'
import Modal from '@/components/Modal/index.js'

export default {
  name: 'azienda-chat',
  components: {},
  data () {
    return {
      currentSelected: -1
    }
  },
  computed: {
    ...mapGetters(['LangString', 'aziendaMessages', 'aziendaIngoreControls', 'myAziendaInfo', 'myPhoneNumber'])
  },
  watch: {
  },
  methods: {
    ...mapMutations(['SET_AZIENDA_IGNORE_CONTROLS', 'SET_ALL_MESSAGES_AS_READ']),
    ...mapActions([]),
    formatEmoji (message) {
      return this.$phoneAPI.convertEmoji(message)
    },
    scrollIntoView () {
      this.$nextTick(() => {
        const elem = this.$el.querySelector('.selected')
        if (elem !== null) {
          elem.scrollIntoView({ behavior: 'smooth', block: 'start', inline: 'nearest' })
        }
      })
    },
    onUp () {
      if (this.aziendaIngoreControls) return
      if (this.currentSelected === -1) return
      this.currentSelected = this.currentSelected - 1
      this.scrollIntoView()
    },
    onDown () {
      if (this.aziendaIngoreControls) return
      if (this.currentSelected === this.aziendaMessages.length - 1) return
      this.currentSelected = this.currentSelected + 1
      this.scrollIntoView()
    },
    onEnter () {
      if (this.aziendaIngoreControls) return
      this.SET_AZIENDA_IGNORE_CONTROLS(true)
      Modal.CreateTextModal({
        title: this.LangString('TYPE_MESSAGE'),
        color: 'rgb(255, 180, 89)'
      })
      .then(resp => {
        if (resp !== undefined && resp.text !== undefined) {
          this.SET_AZIENDA_IGNORE_CONTROLS(false)
          const message = resp.text.trim()
          if (message !== '') {
            this.$phoneAPI.sendAziendaMessage({ azienda: this.myAziendaInfo.name, number: this.myPhoneNumber, message: message })
          }
        }
      })
      .catch(e => { this.SET_AZIENDA_IGNORE_CONTROLS(false) })
    },
    onRight () {
      if (this.aziendaIngoreControls) return
      this.SET_AZIENDA_IGNORE_CONTROLS(true)
      try {
        let currentMessage = this.aziendaMessages[this.currentSelected]
        let isGPS = /(-?\d+(\.\d+)?), (-?\d+(\.\d+)?)/.test(currentMessage.message)
        let scelte = [
          {id: 1, title: this.LangString('APP_AZIENDA_SEND_POSITION'), icons: 'fa-location-arrow'},
          {id: -1, title: this.LangString('CANCEL'), icons: 'fa-undo', color: 'red'}
        ]
        if (!currentMessage.mine) {
          scelte = [{id: 2, title: this.LangString('APP_AZIENDA_CALL_NUMBER'), icons: 'fa-phone'}, ...scelte]
        }
        if (isGPS) {
          scelte = [{id: 3, title: this.LangString('APP_AZIENDA_SET_POSITION'), icons: 'fa-location-arrow'}, ...scelte]
        }
        Modal.CreateModal({ scelte })
        .then(resp => {
          switch(resp.id) {
            case 1:
              this.$phoneAPI.sendAziendaMessage({ azienda: this.myAziendaInfo.name, number: currentMessage.authorPhone, message: '%pos%' })
              this.SET_AZIENDA_IGNORE_CONTROLS(false)
              break
            case 2:
              this.$phoneAPI.startCall({ numero: currentMessage.authorPhone })
              this.SET_AZIENDA_IGNORE_CONTROLS(false)
              break
            case 3:
              let val = currentMessage.message.match(/(-?\d+(\.\d+)?), (-?\d+(\.\d+)?)/)
              this.$phoneAPI.setGPS(val[1], val[3])
              this.SET_AZIENDA_IGNORE_CONTROLS(false)
              break
            case -1:
              this.SET_AZIENDA_IGNORE_CONTROLS(false)
          }
        })
        .catch(e => { this.SET_AZIENDA_IGNORE_CONTROLS(false) })
      } catch (e) { }
    },
    onBack () {
      if (this.aziendaIngoreControls) {
        this.SET_AZIENDA_IGNORE_CONTROLS(false)
      }
    }
  },
  created () {
    this.$bus.$on('keyUpArrowUp', this.onUp)
    this.$bus.$on('keyUpArrowDown', this.onDown)
    this.$bus.$on('keyUpEnter', this.onEnter)
    this.$bus.$on('keyUpArrowRight', this.onRight)
    this.$bus.$on('keyUpBackspace', this.onBack)
    this.currentSelected = this.aziendaMessages.length - 1
    setTimeout(() => {
      this.scrollIntoView()
    }, 500)
  },
  mounted () {
  },
  beforeDestroy () {
    this.$bus.$off('keyUpArrowUp', this.onUp)
    this.$bus.$off('keyUpArrowDown', this.onDown)
    this.$bus.$off('keyUpEnter', this.onEnter)
    this.$bus.$off('keyUpArrowRight', this.onRight)
    this.$bus.$off('keyUpBackspace', this.onBack)
  }
}
</script>

<style scoped>
.chat-container {
  width: 95%;
  height: 96%;

  background-color: rgb(87, 87, 87);
  border-radius: 20px;

  margin-top: 10px;
  margin-left: auto;
  margin-right: auto;
}

.chat-messages-container {
  height: 90%;
  width: 100%;
  border-radius: 20px;
  overflow: hidden;
}

.chat-message-container {
  position: relative;
  overflow: auto;
}

.chat-send-container {
  margin-top: 13px;
  height: 8%;
  width: 100%;
}

/* SINGLE MESSAGES SECTION */

.chat-message-bouble {
  width: 80%;
  height: auto;
  margin-top: 10px;
  margin-left: 10px;
  border-radius: 5px;
  background-color: rgb(255, 244, 230);

  float: left;
}

.chat-message-bouble-mine {
  width: 80%;
  height: auto;
  margin-top: 10px;
  margin-right: 10px;
  border-radius: 5px;
  background-color: rgb(255, 210, 154);

  float: right;
}

.chat-message-bouble-author {
  color: rgb(59, 59, 59);
  font-size: 14px;
  margin-left: 5px;
}

.chat-message-bouble-message {
  margin-left: 10px;
}

.chat-message-container .selected {
  background-color: rgb(255, 180, 89);
}

/* CHAT SEND SECTION */

.chat-send-bg {
  width: 95%;
  height: 40px;
  margin-left: auto;
  margin-right: auto;

  background-color: rgb(214, 214, 214);
  border-radius: 20px;
}

.chat-send-placeholder {
  display: block;
  color: grey;
  font-size: 15px;
  padding-top: 11px;
  padding-left: 35px;
}

.chat-send-placeholder-icon {
  position: absolute;
  color: grey;
  font-size: 15px;
  bottom: 36px;
  left: 27px;
}
</style>
