local bindableEventQueue = require(script.Parent.bindableEventQueue)

return function(instance)
	local function createEvent(callback)
		return function(...)
			local v = callback(...)

			if instance:GetAttribute("isConnected") == true then
				instance:Fire(v)
			else
				bindableEventQueue:add(v)
			end
		end
	end

	return createEvent
end
