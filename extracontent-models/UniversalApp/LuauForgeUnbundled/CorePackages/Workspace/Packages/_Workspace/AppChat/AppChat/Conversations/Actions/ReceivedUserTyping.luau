local SetUserTyping = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/SetUserTyping")

local count = 0

return function(p2, p3)
	return function(object)
		spawn(function()
			count += 1
			local v5 = count

			object:dispatch(SetUserTyping(p2, p3, true))

			wait(8)

			if count == v5 then
				object:dispatch(SetUserTyping(p2, p3, false))
			end
		end)
	end
end
