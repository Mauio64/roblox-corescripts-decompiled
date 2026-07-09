local t1 = {}

t1.__index = t1

function t1.new() -- line: 39
	-- upvalues: t1 (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2.StoppedBindableEvent = Instance.new("BindableEvent")
	t2.EndedBindableEvent = Instance.new("BindableEvent")
	t2.DidLoopBindableEvent = Instance.new("BindableEvent")
	t2.Stopped = t2.StoppedBindableEvent.Event
	t2.Ended = t2.EndedBindableEvent.Event
	t2.DidLoop = t2.DidLoopBindableEvent.Event
	t2.IsPlaying = false

	return t2
end
function t1.Play(t3: {[any]: any}, _: number?) -- line: 55
	t3.IsPlaying = true
	task.spawn(function() -- line: 57
		-- upvalues: t3 (copy)
		task.wait(1)

		if t3.IsPlaying then
			t3.IsPlaying = false
			t3.StoppedBindableEvent:Fire()
			task.wait(0.2)
			t3.EndedBindableEvent:Fire()
		end
	end)
end
function t1.Stop(t4: {[any]: any}, _: number?) -- line: 68
	if t4.IsPlaying then
		task.spawn(function() -- line: 70
			-- upvalues: t4 (copy)
			t4.IsPlaying = false
			t4.StoppedBindableEvent:Fire()
			task.wait(0.2)
			t4.EndedBindableEvent:Fire()
		end)
	end
end
function t1.Destroy(_) -- line: 79
end

return t1
