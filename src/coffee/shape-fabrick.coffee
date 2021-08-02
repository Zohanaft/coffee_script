export class Shapes
  constructor: () ->
    @list = {}
  append: (name, type) ->
    @list[name] = type

  create: (options, type) ->
    Shape = @list[type] ?= throw Error('Нет такого класса в списке')
    instance = new Shape(options...)
