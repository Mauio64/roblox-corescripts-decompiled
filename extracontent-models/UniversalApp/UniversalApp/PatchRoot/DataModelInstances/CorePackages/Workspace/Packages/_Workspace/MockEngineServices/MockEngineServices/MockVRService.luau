local t1 = {}

t1.__index = t1

function t1.new(_) -- line: 4
	-- upvalues: t1 (copy)
	local t2 = {
		VREnabled = false,
		QuestDisplayRefreshRate = 90,
		events = {},
		GetPropertyChangedSignal = function(p2, p3) -- line: 9
			local BindableEvent = Instance.new("BindableEvent")

			p2.events[p3] = p2.events[p3] or {}
			table.insert(p2.events[p3], BindableEvent)

			return BindableEvent.Event
		end,
		callPropertyChanged = function(p4, p5) -- line: 15
			local v9 = p4.events[p5]

			if v9 then
				for _, v11 in v9 do
					v11:Fire()
				end
			end
		end
	}

	setmetatable(t2, {
		__index = t1
	})

	return t2
end

return t1
