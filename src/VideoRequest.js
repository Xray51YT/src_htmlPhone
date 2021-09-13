import {
  OrthographicCamera,
  Scene,
  WebGLRenderTarget,
  LinearFilter,
  NearestFilter,
  RGBAFormat,
  UnsignedByteType,
  CfxTexture,
  ShaderMaterial,
  PlaneBufferGeometry,
  Mesh,
  WebGLRenderer,
  BoxGeometry,
  MeshBasicMaterial
} from '@citizenfx/three'

const appWidth = 330
const appHeight = 710
// this help move the image on the x axis
// 200 is for selfie camera
// 100 is for normal camera
var xModifier = -100
// this help move the image on the y axis
var yModifier = 0

class VideoRequest {
  constructor (mainDiv, video) {
    this.video = video
    this.stop = false
    this.buffer = null
    this.read = null

    this.video.width = appWidth
    this.video.height = appHeight

    // create camera from screen dimensions
    const cameraRTT = new OrthographicCamera(window.innerWidth / -2, window.innerWidth / 2, window.innerHeight / 2, window.innerHeight / -2, -10000, 10000)
    cameraRTT.position.z = 100
    const sceneRTT = new Scene()
    // render what camera see and all elements in image
    const rtTexture = new WebGLRenderTarget(window.innerWidth, window.innerHeight, { minFilter: LinearFilter, magFilter: NearestFilter, format: RGBAFormat, type: UnsignedByteType })
    // use fivem threejs to render all textoures and elements
    const gameTexture = new CfxTexture()
    gameTexture.needsUpdate = true
    // from here i don't know what this code does
    const material = new ShaderMaterial({
      uniforms: { 'tDiffuse': { value: gameTexture } },
      vertexShader: `
        varying vec2 vUv;
        void main() {
          vUv = vec2(uv.x, 1.0-uv.y); // fuck gl uv coords
          gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
        }
      `,
      fragmentShader: `
        varying vec2 vUv;
        uniform sampler2D tDiffuse;
        void main() {
          gl_FragColor = texture2D( tDiffuse, vUv );
        }
      `
    })

    this.material = material

    if (process.env.NODE_ENV !== 'production') {
      console.log('creating new geometry')
      var geometry = new BoxGeometry(200, 200, 200)
      var material2 = new MeshBasicMaterial({ color: 0x00ff00 })
      this.mesh = new Mesh(geometry, material2)
      this.mesh.position.z = -90
      console.log('adding geometry do scene')
      sceneRTT.add(this.mesh)
      console.log('everything ok')
    } else {
      const plane = new PlaneBufferGeometry(window.innerWidth, window.innerHeight)
      const quad = new Mesh(plane, material)
      quad.position.z = -100
      sceneRTT.add(quad)
    }

    const renderer = new WebGLRenderer({ preserveDrawingBuffer: true })
    renderer.setPixelRatio(window.devicePixelRatio)
    // this will change the size of the camera:
    // smaller the camera lower the resolution
    // imagine a focal point in the center of the screen: if we create a camera with
    // 100 x 100 dimension, the camera will be big 100pixels by 100pixels and the camera
    // will be focused on the focal point at the center of the screen. Imagine as if it is
    // a 3 axes graph so.... yeah....
    renderer.setSize(window.innerWidth, window.innerHeight)
    renderer.autoClear = false

    if (process.env.NODE_ENV !== 'production') {
      let div = mainDiv.appendChild(renderer.domElement)
      div.style.cssText = `
        position: absolute;
        width: 100%;
        height: 100%;
        z-index: -1;
      `
    }

    // create class variables
    this.renderer = renderer
    this.rtTexture = rtTexture
    this.sceneRTT = sceneRTT
    this.cameraRTT = cameraRTT
    // bind animate function to get every element accessible
    // bind this element to everything else
    // this.startVideoRecording = this.startVideoRecording.bind(this)
    // this.stopCapture = this.stopCapture.bind(this)
    this.animate = this.animate.bind(this)
    this.startVideoLive(mainDiv)
    requestAnimationFrame(this.animate)
  }

  setXModifier (value) {
    let check = value
    if (check < 1) check *= -1
    if (check * 2 < window.innerWidth / 2) {
      console.log('now setting', value)
      xModifier = value
    }
  }

  getXModifier () {
    return xModifier
  }

  startVideoLive (mainDiv) {
    this.liveCanvas = document.createElement('canvas')
    this.liveCanvas.style.cssText = `
      display: block;
      width: 330px;
      height: 710px;
      top: 27px;
      position: absolute;
      z-index: 0;
    `
    // this.liveCanvas.width = window.innerWidth
    // this.liveCanvas.height = window.innerHeight
    this.liveCanvas.width = appWidth
    this.liveCanvas.height = appHeight
    mainDiv.appendChild(this.liveCanvas)
    this.liveCtx = this.liveCanvas.getContext('2d')
  }

  startVideoRecording () {
    this.stream = this.liveCanvas.captureStream()
    this.recorder = new MediaRecorder(this.stream, { mimeType: 'video/webm' })
    let allChunks = []
    this.recorder.ondataavailable = function (e) { allChunks.push(e.data) }
    this.recorder.onstop = (e) => {
      // hide canvas
      this.liveCanvas.style.display = 'none'
      // create blob ready to be sent to the web server
      const fullBlob = new Blob(allChunks, { 'type': 'video/webm' })
      const downloadUrl = window.URL.createObjectURL(fullBlob)
      this.video.src = downloadUrl
      this.video.play()
      this.video.onended = () => {
        // after video ends, show canvas again
        this.liveCanvas.style.display = 'block'
        // maybe show what to do with video?
      }
    }
    this.recorder.start()
  }

  stopRecording () {
    if (this.recorder) this.recorder.stop()
  }

  stopCapture () {
    this.stop = true
  }

  animate () {
    try {
      if (this.stop) return
      requestAnimationFrame(this.animate)
      this.renderer.clear()

      if (process.env.NODE_ENV !== 'production') {
        this.mesh.rotation.x += 0.005
        this.mesh.rotation.y += 0.01
        // this.renderer.setRenderTarget(this.rtTexture)
        this.renderer.render(this.sceneRTT, this.cameraRTT)
        this.read = new Uint8Array(window.innerWidth * window.innerHeight * 4)
        this.renderer.readRenderTargetPixels(this.rtTexture, 0, 0, window.innerWidth, window.innerHeight, this.read)
      } else {
        this.renderer.render(this.sceneRTT, this.cameraRTT, this.rtTexture, true)
        this.read = new Uint8Array(window.innerWidth * window.innerHeight * 4)
        this.renderer.readRenderTargetPixels(this.rtTexture, 0, 0, window.innerWidth, window.innerHeight, this.read)
      }

      // create buffer (clumped array) from renderer buffer
      // and save as class element for memory optimization
      this.buffer = new Uint8ClampedArray(this.read.buffer)
      // add buffer to live canvas
      // https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/putImageData?retiredLocale=it
      // ctx.putImageData(imageData, dx, dy, dirtyX, dirtyY, dirtyWidth, dirtyHeight)
      this.liveCtx.putImageData(
        new ImageData(this.buffer, window.innerWidth, window.innerHeight),
        ((appHeight * -1) + xModifier),
        ((appWidth * -1) + yModifier),
        (appHeight - xModifier),
        (appWidth - yModifier),
        appWidth,
        appHeight
      )
    } catch (e) {
      if (process.env.NODE_ENV !== 'production') {
        console.log(e)
      } else {
        console.log(JSON.stringify(e))
      }
    }
  }
}

/* eslint-disable */
(async function () {})()

export default VideoRequest
