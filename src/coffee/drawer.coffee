import { ctx } from './sceene'

class Drawer
  ###
    origin: ориджин текущей фигуры: откуда будем рисовать
    как правило - center либо верхний левый угол
  ###
  draw: (color, origin, path) ->
    ctx.beginPath()
    ctx.lineTo(origin.x + path[index], origin.y + path[index+1]) for pair, index in path by 2
    ctx.closePath()
    ctx.fillStyle = color or 'black'
    ctx.fill()

  clear: (color, origin, width, height) ->
    ctx.fillStyle = color or 'white'
    ctx.clearRect(0, 0, 600, 600)

  line: (path) ->
    ctx.beginPath()
    ctx.lineTo(path[0], path[1])
    ctx.lineTo(path[2], path[3])
    ctx.stroke()
    ctx.closePath()

  # показать нормали - чисто для себя (ну и для визуального дебага, разумеется)
  normales: (path, origin) ->
    ctx.fillStyle = 'black'
    for normale,index in path by 4
      ctx.fillStyle = 'red'
      ctx.fillRect(origin.x + path[index]-2, origin.y + path[index+1]-2, 4, 4)
      ctx.fillStyle = 'green'
      ctx.fillRect(origin.x + path[index+2]-2, origin.y + path[index+3]-2, 4, 4)
      @line([
        origin.x + path[index],
        origin.y + path[index+1],
        origin.x + path[index+2],
        origin.y + path[index+3]
      ])


Drawer = new Drawer()
export { Drawer }
#
#x = 450
#y = 200
#
#x1 = 420
#y1 = 600
#
#dx = x1-x
#dy = y1-y
#
#ctx.beginPath()
#ctx.lineTo(x,y)
#ctx.lineTo(x1,y1)
#ctx.closePath()
#ctx.stroke()
#
#ctx.fillStyle = 'red'
#ctx.fillRect(x-2, y-2, 4, 4)
#ctx.fillRect(x1-2, y1-2, 4, 4)
#ctx.fillRect(x+ dx/2-2, y+ dy/2-2, 4, 4)
#
#ctx.beginPath()
#ctx.lineTo(x, y)
#ctx.lineTo(x-dy, y+dx)
#ctx.closePath()
#ctx.stroke()
