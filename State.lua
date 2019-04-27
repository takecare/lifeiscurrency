State = Class{}

function State:init()
    self.state = 'paused'
end

function State:reset()
    self.state = 'paused'
end

function State:pause()
    self.state = 'paused'
end

function State:resume()
    self.state = 'playing'
end

function State:togglePause()
    if (self:isPaused()) then
        self:resume()
    else
        self:pause()
    end
end

function State:isPaused()
    return self.state == 'paused'
end

function State:isPlaying()
    return self.state == 'playing'
end

function State:debugInfo()
    return self.state
end