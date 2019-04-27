Player = Class{}

function Player:init(x, y)
    self.life = 10
    self.x = x ~= nil and x or 25
    self.y = y ~= nil and y or 25
    self.dy = 0
    self.dx = 0
    self.size = 8
    self.speed = 45
    self.backwardsSpeed = 30
    self.rotation = 0
    self.sprite = love.graphics.newImage("player.png")
end

function Player:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
    self:updateRotation()
end

function Player:updateRotation()
    local mouseX, mouseY = mousePos()
    local x, y = self.x, self.y
    local hypotenuse = distance(mouseX, mouseY, x, y)
    local opposite = distance(x, y, x, mouseY)
    local angle = math.asin(opposite / hypotenuse)
    
    if (mouseX > x and mouseY > y) then 
        self.rotation = angle
    elseif (mouseX < x and mouseY > y) then
        self.rotation = math.rad(180) - angle
    elseif (mouseX < x and mouseY < y) then
        self.rotation = math.rad(180) + angle
    elseif (mouseX > x and mouseY < y) then
        self.rotation = - angle
    end
end

function mousePos()
    local mouseX, mouseY = push:toGame(love.mouse.getPosition())
    return mouseX ~= nil and mouseX or 0, mouseY ~= nil and mouseY or 0
end

function distance(x0, y0, x1, y1)
    return math.sqrt(math.pow(x1 - x0, 2) + math.pow(y1 - y0, 2))
end

function Player:render()
    setPlayerColor()
    -- love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
    love.graphics.draw(self.sprite, self.x, self.y, self.rotation, 1, 1, self.size, self.size)
    setBackgroundColor()

    debugPoint(self.x, self.y)
    debugPoint(mousePos())
end

function setPlayerColor()
    love.graphics.setColor(1, 1, 1)
end

function setBackgroundColor()
    love.graphics.setColor(0, 0, 0)
end

function debugPoint(x, y, size)
    local size = size == nil and 3 or size
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', x, y, size, size)
    setBackgroundColor()
end

function Player:handleInput()
    if love.keyboard.isDown("w") then
        self.dy = - self.speed
    elseif love.keyboard.isDown("s") then
        self.dy = self.speed
    else
        self.dy = 0
    end

    if love.keyboard.isDown("a") then
        self.dx = - self.speed
    elseif love.keyboard.isDown("d") then
        self.dx = self.speed
    else
        self.dx = 0
    end
end

function Player:debugInfo()
    return math.ceil(self.x) .. ',' .. math.ceil(self.y)
end
