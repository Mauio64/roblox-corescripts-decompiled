local t1 = {}

t1.__index = t1

function t1.new() -- line: 8
	-- upvalues: t1 (copy)
	local BindableEvent = Instance.new("BindableEvent")
	local t2 = {
		FullscreenChanged = {
			Connect = function(_, p2) -- line: 13
				-- upvalues: BindableEvent (copy)
				return BindableEvent.Event:Connect(p2)
			end,
			GoFullscreen = function() -- line: 16
				-- upvalues: BindableEvent (copy)
				BindableEvent:Fire(true)
			end
		}
	}

	setmetatable(t2, {
		__index = t1
	})

	return t2
end
function t1.InFullScreen(_) -- line: 28
	return false
end

return t1
