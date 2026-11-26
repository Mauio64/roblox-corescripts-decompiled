local class = {}
class.__index = class

function class.new()
	local v5 = {}
	setmetatable(v5, class)

	v5.StoppedBindableEvent = Instance.new("BindableEvent")
	v5.EndedBindableEvent = Instance.new("BindableEvent")
	v5.DidLoopBindableEvent = Instance.new("BindableEvent")
	v5.Stopped = v5.StoppedBindableEvent.Event
	v5.Ended = v5.EndedBindableEvent.Event
	v5.DidLoop = v5.DidLoopBindableEvent.Event

	v5.IsPlaying = false

	return v5
end

function class:Play(p2)
	self.IsPlaying = true
	task.spawn(function()
		task.wait(1)

		if self.IsPlaying then
			self.IsPlaying = false
			self.StoppedBindableEvent:Fire()
			task.wait(0.2)
			self.EndedBindableEvent:Fire()
		end
	end)
end

function class:Stop(p2)
	if self.IsPlaying then
		task.spawn(function()
			self.IsPlaying = false
			self.StoppedBindableEvent:Fire()
			task.wait(0.2)
			self.EndedBindableEvent:Fire()
		end)
	end
end

function class:Destroy() end

return class
