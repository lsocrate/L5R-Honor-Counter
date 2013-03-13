class Player
  honorRequiredForVictory = 40
  dishonorRequiredForLoss = -20

  constructor: ($, @player, @cleanPlayer) ->
    @honorContainer = @cleanPlayer.querySelector('.honor')
    honor = parseInt(@honorContainer.innerHTML, 10)
    if isNaN(honor)
      @honor = 0
    else
      @honor = honor

    @controls = @player.find(".controls")
    @more = @player.find(".more")
    @less = @player.find(".less")

    @setEvents()
    @updateHonorDisplay()

  setEvents: ->
    taped = true
    @controls.on("touchmove touchcancel touchleave", -> taped = false)
    @controls.on("touchend click", (ev) =>
      if taped
        @dispatchTap(ev)
      else
        taped = true
    )

  dispatchTap: (ev) ->
    ev.preventDefault()

    switch ev.target.dataset.action
      when 'honor'
        honorChange = parseInt(ev.target.dataset.honorChange, 10)
        @changeHonor(honorChange)

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
    @clanSelector.addClass('active')
    @clanSelector.find('span').text('Choose ' + name + ' clan:')
    @clanSelector.find('select').on("change", (ev) =>
      clan = ev.target.value
      return unless clan

      player.player.removeClass(clans.join(' ')).addClass(ev.target.value)
      @clanSelector.removeClass('active')
      @clanSelector.find('select').off("change")

      callback() if typeof callback is 'function'
    )

  constructor: ($, @counter) ->
    @players = []
    players = document.querySelectorAll('.player')
    for player in players
      @players.push(new Player($, $(player), player))

    @controls = @counter.find('.global-controls')
    @clanSelector = $('.clan-selector')
    @setEvents()

  setEvents: ->
    taped = true
    @controls.on("touchmove touchcancel touchleave", -> taped = false)
    @controls.on("touchend click", (ev) =>
      if taped
        @dispatchTap(ev)
      else
        taped = true
    )

  dispatchTap: (ev) ->
    ev.preventDefault()
    switch ev.target.dataset.action
      when 'reset'
        @resetMatch()
      when 'setClans'
        @setClans()

  resetMatch: ->
    for player in @players
      player.setHonor(0)

  setClans: ->
    [opponent, owner] = @players
    @askPlayerClan(owner, 'your', => @askPlayerClan(opponent, 'opponent'))

(($) ->
  new HonorCounter($, $('body'))
)(Zepto)
