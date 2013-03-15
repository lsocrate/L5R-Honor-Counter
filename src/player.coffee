class Player
  honorRequiredForVictory = 40
  dishonorRequiredForLoss = -20

  constructor: (@player) ->
    @honorStorage = ['player', @player.dataset.playerId, 'honor'].join('-')
    @clanStorage = ['player', @player.dataset.playerId, 'clan'].join('-')

    @honorContainer = @player.querySelector('.honor')
    honor = localStorage.getItem(@honorStorage)
    if honor
      @honor = parseInt(honor, 10)
    else
      @honor = 0

    clan = localStorage.getItem(@clanStorage)
    @player.classList.add(clan) if clan

    @controls = @player.querySelector('.controls')

    @setEvents()
    @updateHonorDisplay()

  setEvents: ->
    _this = @
    handleControlEvent = (ev) ->
      ev.preventDefault()
      data = ev.target.dataset
      switch data.action
        when 'honor'
          honorChange = parseInt(data.honorChange, 10)
          _this.changeHonor(honorChange)

    unless typeof Touch is 'object'
      @controls.addEventListener('mouseup', handleControlEvent)
    else
      tap = true
      @controls.addEventListener('touchmove', -> tap = false)
      @controls.addEventListener('touchcancel', -> tap = false)
      @controls.addEventListener('touchend', (ev) ->
        if tap
          handleControlEvent(ev)
        else tap = true
      )

  changeHonor: (change) ->
    @honor += change
    localStorage.setItem(@honorStorage, @honor)
    @updateHonorDisplay()

  setHonor: (value) ->
    @honor = parseInt(value, 10)
    localStorage.setItem(@honorStorage, @honor)
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

  setClan: (clan) ->
    localStorage.setItem(@clanStorage, clan)
