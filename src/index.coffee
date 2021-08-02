import { Nova } from './coffee/nova.coffee'
import { novaCanvas } from './coffee/sceene'
import { Shapes } from './coffee/shape-fabrick'
import { Drawer } from "./coffee/drawer"
# Цвет переключается
# Но сделано неправильно
# Я уже не понимаю...
# сначала пытался вычислить по ближайшим нормалям находится ли точка внутри
# где-то ошибся
# потом пытался через пересечения...
# ни одна из реализаций не работала

SelectedShapeColorCanvas= document.getElementById('selected')
SelectedShapeColorCanvasCTX = SelectedShapeColorCanvas.getContext('2d')

MATH_PI = Math.PI * 2

# фабрика шейпов (т.к. не хочу редактировать её по кд при добавлении новых шейпов)
# то лучше заполню извне p.s. можно было обойтись без name в append
# в таком случае создание нового объекта выглядело бы примерно так:
# shapeFactory.append(Nova)
# shapeFactory.create(options, Nova)

shapeFactory = new Shapes()
shapeFactory.append('nova', Nova)


# список параметров Nova: цвет, количество вершин, стартовая позиция ориджина (центра фигуры)
optionList = [
  ['rgb(204 0 0)', 3, undefined, undefined, 26, 60],
  ['rgb(51 0 153)', 4, undefined, undefined, 26, 60],
  ['rgb(0 204 102)', 5, undefined, undefined, 26, 60],
  ['rgb(255 255 51)', 6, undefined, undefined, 26, 60],
  ['rgb(0,0,0)', 7, undefined, undefined, 26, 60]
]

# создаю shapes и заполняю в соответствии с параметрами
# получаю массив форм, таким образом могу управлять сразу всеми формами
shapes = []
shapes.push shapeFactory.create(options, 'nova') for options in optionList
shape.createNormales() for shape in shapes

# кидаю обработчик на событие клика по канвасу
novaCanvas.onclick = (event) ->
  count = 0
  for shape in shapes
    currentShape = shape.angleWeightPseudoNormales({
      x: event.clientX-event.target.offsetLeft,
      y: event.clientY-event.target.offsetTop
    })
    if currentShape
      SelectedShapeColorCanvasCTX.fillStyle = currentShape.color
      SelectedShapeColorCanvasCTX.fillRect(0,0,50,50)
      count += 1

  if count is 0
    SelectedShapeColorCanvasCTX.fillStyle = 'white'
    SelectedShapeColorCanvasCTX.fillRect(0,0,50,50)

# вычисляю центр канваса, буду использовать его как центр для отрисовки фигур
center = {
  x: novaCanvas.width / 2,
  y: novaCanvas.height / 2
}

# эта штука по факту не нужна,
# но мне захотелось чтобы звёздочки были выстроены по кругу
# вообще не важно как они расположены
# можно по дуге, в линию, да хоть по кривой безъе
# (метод отрисовки оных, кстати, я пару раз реализовывал Де Кастельжо)
# делал request animation frame для того чтобы проверить
# как работает Drawer
# было бы намного проще если бы я сначала написал библиотеку
# для работы с векторами (такую я писал давно, но думаю что лишнее, пока что,

render = () ->
  Drawer.clear()

  MATH_PI += .01
  step = (Math.PI * 2) / shapes.length
  radius = 200
  center = {
    x: novaCanvas.width / 2,
    y: novaCanvas.height / 2
  }
  posX = center.x
  posY = center.y

  for shape in shapes
    x= posX + Math.cos(MATH_PI) * radius
    y= posY + Math.sin(MATH_PI) * radius
    shape.move(x,y)
#    shape.move(center.x, center.y)
    MATH_PI += step

  ## рисуем
  shape.draw() for shape in shapes
  # если что-то непонятно - лучше заранее вывести все нормали шейпов и понять - куда накосячил
  # с помощью dot.env при генерации можно отключить вспомогательные конструкции
  # таким образом тестовый код не попадет в продакшн
  shape.drawNormales() for shape in shapes

  requestAnimationFrame(render)

render()
