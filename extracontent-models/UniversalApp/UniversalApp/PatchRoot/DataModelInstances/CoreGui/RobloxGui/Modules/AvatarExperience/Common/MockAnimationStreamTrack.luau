local t1 = {}

t1.__index = t1

function t1.new() -- line: 33
	-- upvalues: t1 (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2.StoppedBindableEvent = Instance.new("BindableEvent")
	t2.Stopped = t2.StoppedBindableEvent.Event
	t2.WeightCurrent = 1
	t2.IsPlaying = false

	return t2
end
function t1.Play(t3: {[any]: any}, _: number?) -- line: 46
	t3.IsPlaying = true
end
function t1.Stop(t4: {[any]: any}, _: number?) -- line: 50
	if t4.IsPlaying then
		t4.IsPlaying = false
		t4.StoppedBindableEvent:Fire()
	end
end
function t1.AdjustWeight(t5: {[any]: any}, n3: number) -- line: 57
	t5.WeightCurrent = n3
end
function t1.Destroy(_) -- line: 61
end

return t1
