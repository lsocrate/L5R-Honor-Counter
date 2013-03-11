class Player
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
    action = ev.target.className
    if action is "more"
      @changeHonor(1)
    else
      @changeHonor(-1)

  changeHonor: (change) ->
    @honor += change
    @updateHonorDisplay()

  setHonor: (value) ->
    @honor = parseInt(value, 10)
    @updateHonorDisplay()

  updateHonorDisplay: ->
    @honorContainer.html( => @honor)
    if @honor >= 40
      @honorContainer.addClass('honor-victory')
    else
      @honorContainer.removeClass('honor-victory')
    if @honor <= -20
      @honorContainer.addClass('dishonored')

class HonorCounter
  constructor: ($, @counter) ->
    @players = []
    for player in @counter.find('.player')
      @players.push(new Player($, $(player)))

    @controls = @counter.find('.global-controls')
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
    action = ev.target.className
    if action is "reset"
      @resetMatch()

  resetMatch: ->
    for player in @players
      player.setHonor(0)


(($) ->
  new HonorCounter($, $('body'))
)(Zepto)
