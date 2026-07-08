local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local throttleUserId = require(script.Parent.throttleUserId)

return function(p1: ((...any) -> ...any)) -- line: 5
	-- upvalues: dependencies (copy), throttleUserId (copy)
	return function() -- line: 6
		-- upvalues: dependencies (copy), throttleUserId (copy), p1 (copy)
		local LocalPlayer = dependencies.Players.LocalPlayer

		if not LocalPlayer or not LocalPlayer.UserId then
			return false
		end

		return throttleUserId({
			throttle = p1(),
			userId = LocalPlayer.UserId
		})
	end
end
