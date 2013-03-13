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
    tap = true
    @controls.addEventListener('touchmove', -> tap = false)
    @controls.addEventListener('touchcancel', -> tap = false)
    @controls.addEventListener('touchend', (ev) =>
      unless tap
        return tap = true

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
