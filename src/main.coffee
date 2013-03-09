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
    @controls.on("touchmove", -> taped = false)
    @controls.on("touchcancel", -> taped = false)
    @controls.on("touchleave", -> taped = false)
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

  updateHonorDisplay: ->
    @honorContainer.html( => @honor)

(($) ->
  $(".player").each( -> new Player($, $(@)))
)(Zepto)
