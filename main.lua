io.stdout:setvbuf('no')

local vaisseau = {}
vaisseau.x = 0
vaisseau.y = 0
vaisseau.angle = 270
vaisseau.vx = 0
vaisseau.vy = 0
vaisseau.img = love.graphics.newImage("images/ship.png")
vaisseau.imgMoteur = love.graphics.newImage("images/engine.png")
vaisseau.sonMoteur = love.audio.newSource("sounds/engine.wav", "static")
vaisseau.moteur = false
vaisseau.speed = 3

map = {}
difficulty = 0

local pad = {}
pad.x = 0
pad.y = 0
pad.largeur = vaisseau.img:getWidth() + 20 - difficulty
pad.largeurmin = vaisseau.img:getWidth()
pad.hauteur = 5


function newMap()
  local x = 0
  local y = love.math.random(hauteurEcran-150, hauteurEcran-50)
  map[0] = {x, y}
  
  pad.x = love.math.random(10, largeurEcran-pad.largeur-10)
  pad.largeur = vaisseau.img:getWidth() + 10 - difficulty
  if pad.largeur < pad.largeurmin then pad.largeur = pad.largeurmin end
    
  
  for i=1,pad.x do
    x = i
    local incY = love.math.random(-1, 1)
    y = y + incY
    map[i] = {x, y}
    pad.y = y
  end
  
  for i=pad.x,pad.x+pad.largeur do
    map[i] = {pad.x, pad.y}
  end
  
  for i=pad.x+pad.largeur, largeurEcran do
    x = i
    local incY = love.math.random(-1, 1)
    y = y + incY
    map[i] = {x, y}
  end
  
end


function love.load()
  largeurEcran = love.graphics.getWidth()
  hauteurEcran = love.graphics.getHeight()
  
  vaisseau.x = largeurEcran / 2
  vaisseau.y = hauteurEcran / 2
  
  newMap()
  
end




function love.update(dt)
  vaisseau.vy = vaisseau.vy + (0.6 * dt)
  
  vaisseau.x = vaisseau.x + vaisseau.vx
  vaisseau.y = vaisseau.y + vaisseau.vy
  
  if love.keyboard.isDown("right") then
    vaisseau.angle = vaisseau.angle + 90*dt
    if vaisseau.angle > 360 then vaisseau.angle = 0 end
  end

  if love.keyboard.isDown("left") then
    vaisseau.angle = vaisseau.angle - 90*dt
    if vaisseau.angle < 0 then vaisseau.angle = 360 end
  end

  if love.keyboard.isDown("up") then
    vaisseau.moteur = true
    
    local angle_rad = math.rad(vaisseau.angle)
    local force_x = math.cos(angle_rad) * (vaisseau.speed*dt)
    local force_y = math.sin(angle_rad) * (vaisseau.speed*dt)
      
    vaisseau.vx = vaisseau.vx + force_x
    vaisseau.vy = vaisseau.vy + force_y
    
    love.audio.play(vaisseau.sonMoteur)
    
  else
    vaisseau.moteur = false
  end

  if vaisseau.vx < -1 then vaisseau.vx = -1
    elseif vaisseau.vx > 1 then vaisseau.vx = 1 end
  if vaisseau.vy < -1 then vaisseau.vy = -1
    elseif vaisseau.vy > 1 then vaisseau.vy = 1 end

end





function love.draw()
  love.graphics.draw(vaisseau.img, vaisseau.x, vaisseau.y,
    math.rad(vaisseau.angle), 1, 1, vaisseau.img:getWidth()/2, vaisseau.img:getHeight()/2)
  
  if vaisseau.moteur then
    love.graphics.draw(vaisseau.imgMoteur, vaisseau.x, vaisseau.y,
      math.rad(vaisseau.angle), 1, 1, vaisseau.imgMoteur:getWidth()/2, vaisseau.imgMoteur:getHeight()/2)
  end
  
  for n=0,#map do
    love.graphics.points(map)
  end
  
  love.graphics.setColor(1,0,0,1)
  love.graphics.rectangle("fill", pad.x, pad.y, pad.largeur, pad.hauteur)
  love.graphics.setColor(1,1,1,1)
  
  
  local sDebug = "Debug: "
  sDebug = sDebug.." angle = "..tostring(vaisseau.angle)
  sDebug = sDebug.."  vx = "..tostring(vaisseau.vx)
  sDebug = sDebug.."  vy = "..tostring(vaisseau.vy)
  
  sDebug = "largeur ecran = "..tostring(largeurEcran)
  love.graphics.print(sDebug,0,0)
  
  sDebug = "pad x = "..tostring(pad.x)
  sDebug = sDebug.."   pad y = "..tostring(pad.y)
  
  love.graphics.print(sDebug,0,10)
  
end
