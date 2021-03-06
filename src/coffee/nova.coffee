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

  area: (x1,y1,x2,y2,x3,y3) ->
    return (x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)

  intersect_1: (a,b,c,d) ->
    if (a > b)
      tmp = a
      a = b
      b = tmp
    if (c > d)
      tmp = c
      c = b
      b = tmp
    return Math.max(a,c) <= Math.min(b,d)

  intersect: (x1,y1,x2,y2,x3,y3,x4,y4) ->
    return @intersect_1(x1,x2,x3,x4) and @intersect_1(y1,y2,y3,y4) and @area(x1,y1,x2,y2,x3,y3) * @area(x1,y1,x2,y2,x4,y4) <= 0 and @area(x3,y3,x4,y4,x1,y1) * @area(x3,y3,x4,y4,x2,y2) <=0

  intercect_2: (x1,y1,x2,y2,x3,y3,x4,y4) ->
    x = ((x1*y2-x2*y1)*(x4-x3)-(x3*y4-x4*y3)*(x2-x1))/((y1-y2)*(x4-x3)-(y3-y4)*(x2-x1))
    y = ((y3-y4)*x-(x3*y4-x4*y3))/(x4-x3)
    if (((x1<=x)and(x2>=x)and(x3<=x)and(x4>=x))or((y1<=y)and(y2>=y) and(y3<=y)and(y4>=y)))
      return true

  angleWeightPseudoNormales: (dot) ->
    ## Дополним до 24 наш путь

    if @range(
      {x: @posX, y: @posY},
      {x: dot.x, y: dot.y }
    ) > @outerRadius
      return false
    else return this
## то что ниже можно не смотреть... смысла нет
    relativeX = dot.x - @posX
    relativeY = dot.y - @posY

    ctx.fillStyle= 'yellow'
    ctx.fillRect(relativeX-4, relativeY-4, 8,8)
    ctx.fillRect(@posX-4, @posY-4,8,8)
    ctx.fillRect(dot.x-4, dot.y-4,8,8)

    deltaExists = @path.length % 4
    pathCopy = []
    pathCopy.push(@path...)
    for i in [0...deltaExists]
      pathCopy.push(@path[i])

    # теперь безопасно можно пройтись по массиву

    # куда пуляем, мсье?
    # т.к. я решил отказаться от angleWeightPseudoNormales алгоритма
    # в силу своей тупости будем работать с двумя лучами выпущенными в рандомном направлении
    rayX1 = 600
    rayY1 = 300
    rayX2 = 600
    rayY2 = 1200

    countFirstRay = 0
    countSecondRay = 0
    # то что я сейчас делаю очень не оптимально, но мой рантайм уже далеко за 40 часов
    for edge, index in pathCopy by 4
      x = edge
      y = pathCopy[index+1]
      x1 = pathCopy[index+2]
      y1 = pathCopy[index+3]

      # для повышения надежности т.е. если хотя бы один луч пересекает вершины нечетное
      # количество раз - то точка находится внутри фигуры
      console.log if @intercect_2(dot.x,dot.y,rayX1,rayY1,x+@posX, y+@posY, x1+@posX, y1+@posY)
#      if @intercect_2(dot.x,dot.y,rayX1,rayY1,x, y, x1, y1)


      ctx.beginPath()
      ctx.lineTo(dot.x, dot.y)
      ctx.lineTo(rayX1, rayY1)
      ctx.stroke()
      ctx.closePath()

#      if @intercect_2(dot.x - @posX,dot.y - @posY,rayX2,rayY2,x, y, x1, y1)
      console.log if @intercect_2(dot.x,dot.y,rayX2,rayY2,x+@posX, y+@posY, x1+@posX, y1+@posY)
      ctx.lineTo(dot.x, dot.y)
      ctx.lineTo(rayX2, rayY2)
      ctx.stroke()
      ctx.closePath()

    ctx.beginPath()
    for edge,index in pathCopy by 4
      x = pathCopy[index]
      y = pathCopy[index+1]
      x1 = pathCopy[index+2]
      y1 = pathCopy[index+3]

      ctx.lineTo(x+@posX, y+@posY)
      ctx.lineTo(x1+@posX, y1+@posY)
    ctx.stroke()
    ctx.closePath()


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
    # отрисовка смещения
    Drawer.draw(@color, {x: @posX, y: @posY}, @path)
    # действительная позиция
#    Drawer.draw(@color, {x: 0, y: 0}, @path)

  drawNormales: () ->
    Drawer.normales(@normales, { x: @posX, y: @posY })

  ###
    Здесь можно по мимо move реализовать rotate, e.g.
    Или вынести это в отдельную сущность "Transition"
  ###
  move: (dx,dy) ->
    @posX = dx
    @posY = dy
