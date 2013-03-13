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

class HonorCounter
  clans = [
    'crab'
    'crane'
    'dragon'
    'lion'
    'mantis'
    'phoenix'
    'scorpion'
    'spider'
    'unicorn'
    'shadowlands'
    'ronin'
    'imperial'
  ]

  askPlayerClan: (player, name, callback) ->
    @clanSelector.classList.add('active')
    @clanSelector.querySelector('span').innerHTML = 'Choose ' + name + ' clan:'

    _this = @
    setupClan = (ev) ->
      clan = ev.target.value
      return unless clan

      playerClasses = player.player.classList
      for playerClass in playerClasses
        playerClasses.remove(playerClass) if clans.indexOf(playerClass) isnt -1

      playerClasses.add(clan)

      _this.clanSelector.querySelector('select').removeEventListener('change', setupClan)

      _this.clanSelector.classList.remove('active')

      callback() if typeof callback is 'function'

    @clanSelector.querySelector('select').addEventListener('change', setupClan)

  constructor: ->
    @players = []
    players = document.querySelectorAll('.player')
    for player in players
      @players.push(new Player(player))

    @controls = document.querySelector('.global-controls')
    @clanSelector = document.querySelector('.clan-selector')
    @setEvents()

  setEvents: ->
    @controls.addEventListener('click', (ev) =>
      ev.preventDefault()
      switch ev.target.dataset.action
        when 'reset'
          @resetMatch()
        when 'setClans'
          @setClans()
    )

  resetMatch: ->
    for player in @players
      player.setHonor(0)

  setClans: ->
    [opponent, owner] = @players
    @askPlayerClan(owner, 'your', => @askPlayerClan(opponent, 'opponent'))


ready = ->
  document.removeEventListener('DOMContentLoaded', ready, false)
  new HonorCounter()

document.addEventListener('DOMContentLoaded', ready)
