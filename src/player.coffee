class Player
  honorRequiredForVictory = 40
  dishonorRequiredForLoss = -20

  constructor: (@player) ->
    @honorContainer = @player.querySelector('.honor')
    honor = parseInt(@honorContainer.innerHTML, 10)
    if isNaN(honor)
      @honor = 0
    else
      @honor = honor

    @controls = @player.querySelector('.controls')

    @setEvents()
    @updateHonorDisplay()

  setEvents: ->
    tap = true
    @controls.addEventListener('touchmove', -> tap = false)
    @controls.addEventListener('touchcancel', -> tap = false)
    @controls.addEventListener('touchend', (ev) =>
      unless tap
        return tap = true

      ev.preventDefault()
      data = ev.target.dataset
      switch data.action
        when 'honor'
          honorChange = parseInt(data.honorChange, 10)
          @changeHonor(honorChange)
    )

  changeHonor: (change) ->
    @honor += change
    @updateHonorDisplay()

  setHonor: (value) ->
    @honor = parseInt(value, 10)
    @updateHonorDisplay()
    @honorContainer.classList.remove('honor-victory')
    @honorContainer.classList.remove('dishonored')

  updateHonorDisplay: ->
    @honorContainer.innerHTML = @honor
    if @honor >= honorRequiredForVictory
      @honorContainer.classList.add('honor-victory')
    else
      @honorContainer.classList.remove('honor-victory')
    if @honor <= dishonorRequiredForLoss
      @honorContainer.classList.add('dishonored')
