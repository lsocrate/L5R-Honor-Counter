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
    @controls.addEventListener('click', (ev) =>
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
