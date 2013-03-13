class Player
  honorRequiredForVictory = 40
  dishonorRequiredForLoss = -20

  constructor: ($, @player) ->
    @honorContainer = @player.find(".honor")
    honor = parseInt(@honorContainer.html(), 10)
    if isNaN(honor)
      @honor = 0
    else
      @honor = honor
    @clan = @player.find(".clan").html()
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
    @honorContainer.removeClass('honor-victory dishonored')

  updateHonorDisplay: ->
    @honorContainer.html( => @honor)
    if @honor >= honorRequiredForVictory
      @honorContainer.addClass('honor-victory')
    else
      @honorContainer.removeClass('honor-victory')
    if @honor <= dishonorRequiredForLoss
      @honorContainer.addClass('dishonored')

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
    for player in @counter.find('.player')
      @players.push(new Player($, $(player)))

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
