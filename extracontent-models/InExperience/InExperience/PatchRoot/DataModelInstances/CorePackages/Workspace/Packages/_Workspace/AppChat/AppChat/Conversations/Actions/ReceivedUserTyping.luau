local SetUserTyping = require(script.Parent.SetUserTyping)

local count = 0

return function(p, p2)
	return function(object)
		spawn(function()
			count += 1
			local v = count

			object:dispatch(SetUserTyping(p, p2, true))

			wait(8)

			if count == v then
				object:dispatch(SetUserTyping(p, p2, false))
			end
		end)
	end
end
