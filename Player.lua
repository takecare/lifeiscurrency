Player = Class{}

function Player:init()
    self.life = 10
    self.x = 15
    self.y = 15
    self.dy = 0
    self.dx = 0
    self.size = 8
    self.speed = 30
end

function Player:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Player:render()
    setPlayerColor()
    love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
    setBackgroundColor()
end

function setPlayerColor()
    love.graphics.setColor(1, 1, 1)
end

function setBackgroundColor()
    love.graphics.setColor(0, 0, 0)
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