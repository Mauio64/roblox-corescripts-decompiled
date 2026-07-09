local t1 = {}

t1.__index = t1

function t1.new() -- line: 4
	-- upvalues: t1 (copy)
	local BindableEvent = Instance.new("BindableEvent")
	local t2 = {
		broadcasts = {},
		ShowLeaveConfirmation = {
			Connect = function(_, p2) -- line: 10
				-- upvalues: BindableEvent (copy)
				return BindableEvent.Event:Connect(p2)
			end,
			Fire = function(_, ...) -- line: 13
				-- upvalues: BindableEvent (copy)
				BindableEvent:Fire(...)
			end
		}
	}

	setmetatable(t2, {
		__index = t1
	})

	return t2
end
function t1.BroadcastNotification(p4, p5, p6) -- line: 24
	p4.broadcasts[#p4.broadcasts + 1] = {
		data = p5,
		notification = p6
	}
end
function t1.SetGlobalGuiInset(_, _, _, _, _) -- line: 31
end
function t1.SafeZoneOffsetsChanged(_) -- line: 33
end

return t1
