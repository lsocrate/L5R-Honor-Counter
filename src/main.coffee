ready = ->
  document.removeEventListener('DOMContentLoaded', ready, false)
  new HonorCounter()

document.addEventListener('DOMContentLoaded', ready)
