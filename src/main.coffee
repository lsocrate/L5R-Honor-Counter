class Player
  playHonorSound = ->
    honorSound = new Audio()
    honorSound.src = "../sounds/tap.mp3"
    honorSound.play()
    $(honorSound).on('ended', -> delete @)

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
        playHonorSound()

  changeHonor: (change) ->
    @honor += change
    @updateHonorDisplay()

  setHonor: (value) ->
    @honor = parseInt(value, 10)
    @updateHonorDisplay()
    @honorContainer.removeClass('honor-victory dishonored')

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
    switch action
      when 'reset'
        @resetMatch()
      when 'clans'
        alert('clans!')

  resetMatch: ->
    for player in @players
      player.setHonor(0)


(($) ->
  new HonorCounter($, $('body'))
)(Zepto)
