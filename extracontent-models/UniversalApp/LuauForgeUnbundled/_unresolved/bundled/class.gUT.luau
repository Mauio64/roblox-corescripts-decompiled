local class = {}
class.__index = class

function class.new()
	local v5 = {}
	setmetatable(v5, class)

	v5.StoppedBindableEvent = Instance.new("BindableEvent")
	v5.Stopped = v5.StoppedBindableEvent.Event
	v5.WeightCurrent = 1

	v5.IsPlaying = false

	return v5
end

function class:Play(p3)
	self.IsPlaying = true
end

function class:Stop(p2)
	if self.IsPlaying then
		self.IsPlaying = false
		self.StoppedBindableEvent:Fire()
	end
end

function class:AdjustWeight(weightCurrent)
	self.WeightCurrent = weightCurrent
end

function class:Destroy() end

return class
