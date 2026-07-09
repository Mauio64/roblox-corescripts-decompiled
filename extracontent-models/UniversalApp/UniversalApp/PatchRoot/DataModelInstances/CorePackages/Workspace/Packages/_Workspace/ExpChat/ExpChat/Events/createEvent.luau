local bindableEventQueue = require(script.Parent.bindableEventQueue)

return function(p1) -- line: 3
	-- upvalues: bindableEventQueue (copy)
	local function createEvent(p2) -- line: 4
		-- upvalues: p1 (copy), bindableEventQueue (copy)
		return function(...) -- line: 5
			-- upvalues: p2 (copy), p1 (copy), bindableEventQueue (copy)
			local v5 = p2(...)

			if p1:GetAttribute("isConnected") ~= true then
				bindableEventQueue:add(v5)

				return
			end

			p1:Fire(v5)
		end
	end

	return createEvent
end
