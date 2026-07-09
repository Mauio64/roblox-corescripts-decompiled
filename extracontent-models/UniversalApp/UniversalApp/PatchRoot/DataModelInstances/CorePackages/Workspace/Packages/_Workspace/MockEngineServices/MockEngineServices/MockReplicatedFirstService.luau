local t1 = {}

t1.__index = t1

function t1.new(_) -- line: 4
	-- upvalues: t1 (copy)
	local BindableEvent = Instance.new("BindableEvent")
	local BindableEvent2 = Instance.new("BindableEvent")
	local t2 = {
		mockIsFinishedReplicating = false,
		mockIsDefaultLoadingGuiRemoved = false,
		finishedReplicatingEvent = BindableEvent,
		FinishedReplicating = BindableEvent.Event,
		IsFinishedReplicating = function(p2) -- line: 13
			return p2.mockIsFinishedReplicating
		end,
		removeDefaultLoadingGuiSignalEvent = BindableEvent2,
		RemoveDefaultLoadingGuiSignal = BindableEvent2.Event,
		IsDefaultLoadingGuiRemoved = function(p3) -- line: 20
			return p3.mockIsDefaultLoadingGuiRemoved
		end,
		SetDefaultLoadingGuiRemoved = function() -- line: 24
		end
	}

	setmetatable(t2, {
		__index = t1
	})

	return t2
end

return t1
