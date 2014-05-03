class App.Views.Request extends Backbone.View
  events:
    "click .request button": "request"

  initialize: () ->
    @listenTo(@model, "request", @render)
    @listenTo(@model, "sync", _.debounce(@render, 500))

    $("body").on("keyup keydown", @force_reload_on_alt_key)

  request: () ->
    params = {}
    params.force_reload = true if @$(".request").hasClass("will-force-reload")

    @model.fetch(data: $.param(params))

  render: () =>
    @$el.toggleClass("is-loading", !@model.get("status"))
    @$el.toggleClass("has-response", !!@model.get("status"))
    @$el.attr("data-responded",
      if !@model.get("status") then ""
      else if @model.get("server_response") then "server"
      else if @model.get("cache_response") then "cache"
      else "client"
    )

  force_reload_on_alt_key: (evt) =>
    @$(".request").toggleClass("will-force-reload", evt.altKey)
