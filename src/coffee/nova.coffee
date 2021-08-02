import { Drawer } from "./drawer"

import {ctx} from "./sceene"

###
  для начала определиться что именно я собираюсь делать нарисовать звёзды

  придумать способ получения цвета звезды

  В итоге просто запилил рендеринг

  Необходимо вынести логику отрисовки, перемещений в отдельную сущность чтобы не
  дублировать кучу кода из раза в раз и создать очередь отрисовки, но делать этого
  я конечно же пока не буду (пока что)
###

export class Nova
  constructor: (
    @color = 'rgb(204 0 0)'
    @spikes = 5,
    posX = 0,
    posY = 0,
    @innerRadius = 10,
    @outerRadius = 20
  ) ->
    @posX = posX
    @posY = posY
    @path = []
    @normales = []
    @createPath()

  range: (edge1, edge2) ->
    return Math.sqrt(
      Math.pow(edge2.x - edge1.x, 2) +
        Math.pow( edge2.y - edge1.y, 2))

  existsEdge: (index) ->
    return @path[index] in @path

  angleWeightPseudoNormales: (dot) ->
    # Эта функция имеет смысл только для Nova
    # соответственно если всё выносить в отдельные модули, то необходимо
    # "ускоряющие функции" передать сюда и выполнить, либо заранее при создании path
    # указывать размер rect или radius в который вписана фигура
    if @range(
      {x: @posX, y: @posY},
      {x: dot.x, y: dot.y }
    ) > @outerRadius
        return false
      else return this
    # Я хотел написать алгоритм проверки через нормали, и вынести всё в AngleWeightPsewdoAlgoritm
    # но не смог
    # так же хотел добавить функцию которая оборачивает весь контент в rect (задаёт габариты в зависимости от шейпов)
    # не успел
    # часть кода хотел вынести в базовый класс SImple Shape чтобы наследовать от него все простые формы

#    minVertexRange = Infinity
#    nearestEdges = []
#    neighbor = 0
#
#    ctx.fillStyle = 'green'
#    ctx.fillRect(
#      @posX-2,
#      @posY-2, 4, 4)
#    ctx.fillRect(dot.x-2, dot.y-2, 4, 4)
#
#    for edges, index in @path by 2
#      if @existsEdge index + 3
#        current = @range(
#          {x: @posX + @path[index], y: @posY +  @path[index+1] },
#          {x: dot.x, y: dot.y }
#        )
#      else
#        current = @range(
#          {x: @posX + @path[0], y: @posY +  @path[1]},
#          {x: dot.x, y: dot.y }
#        )
#
#      if current < minVertexRange
#        minVertexRange = current
#        nearestEdges.splice(0,nearestEdges.length)
#        nearestEdges.push(@path[index], @path[index+1])
#        neighbor = index
#
#    firstNeighborEdge = []
#    secondNeighborEdge = []
#    firstNeighborEdgeRange = Infinity
#    secondNeighborEdgeRange = Infinity
#
#    if @existsEdge(neighbor-2)
#      firstNeighborEdge = [@path[neighbor-1], @path[neighbor-2]]
#    else
#      firstNeighborEdge = [@path[@path.length], @path[@path.length-1]]
#
#    if @existsEdge(neighbor+3)
#      secondNeighborEdge = [@path[neighbor+2], @path[neighbor+3]]
#    else
#      secondNeighborEdge = [@path[0], @path[1]]
#
#    firstNeighborEdgeRange = @range(
#      { x: firstNeighborEdge[0], y: firstNeighborEdge[1] },
#      {x: dot.x, y: dot.y }
#    )
#
#    secondNeighborEdgeRange = @range(
#      { x: secondNeighborEdge[0], y: secondNeighborEdge[1] },
#      {x: dot.x, y: dot.y }
#    )
#
#    if firstNeighborEdgeRange < secondNeighborEdgeRange
#      nearestEdges.push firstNeighborEdge...
#    else
#      nearestEdges.push secondNeighborEdge...
#
#    console.log(nearestEdges)
#
#    ctx.fillStyle = 'black'
#    ctx.fillRect(@posX + nearestEdges[0] - 2, @posY + nearestEdges[1] - 2, 4,4)
#    ctx.fillRect(@posX + nearestEdges[2] - 2, @posY + firstNeighborEdge[3] - 2, 4,4)
#
#    Drawer.line([
#      @posX + nearestEdges[0],
#      @posY + nearestEdges[1],
#      @posX + nearestEdges[2],
#      @posY + nearestEdges[0]
#    ])

#    for edges, index in @path by 2
#      if @path[index + 3]
#        current = @range(
#          {x: @posX + @path[index], y: @posY +  @path[index+1] },
#          {x: dot.x, y: dot.y }
#        )
#      else
#        current = @range(
#          {x: @posX + @path[0], y: @posY +  @path[1]},
#          {x: dot.x, y: dot.y }
#        )
#      if current < minVertexRange
#        minVertexRange = current
#        nearestEdges.splice(0, nearestEdges.length)
#        if @path[index-2]
#          prev = -2
#          for item in @path when prev < 4
#            nearestEdges.push item
#            prev++
#        else
#          prev = 0
#          nearestEdges.push @path[@path.length-1]
#          nearestEdges.push @path[@path.length]
#          for item in @path when prev < 4
#            nearestEdges.push item
#
#    console.log(nearestEdges)
#    for edge in nearestEdges by 2
#      if (nearestEdges[index+3])
#        Drawer.line([
#          @posX + nearestEdges[index] - 2,
#          @posY + nearestEdges[index+1] - 2,
#          @posX + nearestEdges[index+2] - 2,
#          @posY + nearestEdges[index+3] - 2
#        ])

#    x = nearestEdges[0]
#    y = nearestEdges[1]
#    x1 = nearestEdges[2]
#    y1 = nearestEdges[3]
#
#    ctx.fillStyle = 'blue'
#    ctx.fillRect(@posX + x-2, @posY + y-2, 4, 4)
#    ctx.fillRect(@posX + x1-2, @posY + y1-2, 4, 4)
#    Drawer.line([@posX + x, @posY + y, @posX + x1, @posY + y1])
#
#    dx = x1-x
#    dy = y1-y
#    # расстояние между точками отрезка
#    range = @range(
#      { x: x, y: y}
#      { x: x1, y: y1}
#    )

    # левая нормаль
    # это важно для определения скалярного произведения
#    normale = { x: dy, y: -dx }
#    ctx.fillStyle = 'blue'
#    ctx.fillRect(@posX + normale.x-2, @posY + normale.y-2, 4, 4)

    # нахожу длинну от dot (искомая точка) до отрезка который получили
#    h = Math.abs((dx*(dot.y-@posY - y)-dy*(dot.x-@posX-x))/range)
    # рисуем из нашей точки вектор... а хотя... просто косинус ща найду
#    vec = {x: dot.x-@posX+h, y: dot.y-@posY+h}
#    scalar = vec.x * normale.x + vec.y * normale.y
#    cos = scalar / (
#      Math.pow(vec.x - normale.x, 2) *
#      Math.pow(vec.y - normale.y, 2)
#    )
#    console.log(cos)

  createNormales: () ->
    for pair, index in @path by 2
      if @path[index + 3]
        x = @path[index]
        y = @path[index+1]
        x1 = @path[index+2]
        y1 = @path[index+3]

        dx = x1-x
        dy = y1-y

        cx = x+ dx/2
        cy = y+ dy/2

        @normales.push(cx, cy, cx+dy, cy-dx )

  createPath: () ->
    @path.splice(0, @path.length)
    rot = Math.PI/2*3
    step = Math.PI/ @spikes

    for spike in [0...@spikes]
      x = @posX + Math.cos(rot) * @outerRadius
      y = @posY + Math.sin(rot) * @outerRadius
      @path.push(x, y)
      rot += step
      x = @posX + Math.cos(rot) * @innerRadius
      y = @posY + Math.sin(rot) * @innerRadius
      @path.push(x, y)
      rot += step
    x = @posX
    y = @posY - @outerRadius
    @path.push(x, y)

  draw: () ->
    Drawer.draw(@color, {x: @posX, y: @posY}, @path)

  drawNormales: () ->
    Drawer.normales(@normales, { x: @posX, y: @posY })

  ###
    Здесь можно по мимо move реализовать rotate, e.g.
    Или вынести это в отдельную сущность "Transition"
  ###
  move: (dx,dy) ->
    @posX = dx
    @posY = dy
