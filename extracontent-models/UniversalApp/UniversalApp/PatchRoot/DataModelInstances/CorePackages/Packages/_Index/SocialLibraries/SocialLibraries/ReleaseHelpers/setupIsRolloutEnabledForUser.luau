local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local throttleUserId = require(script.Parent.throttleUserId)

return function(callback)
	return function()
		local localPlayer = dependencies.Players.LocalPlayer

		if localPlayer and localPlayer.UserId then
			return throttleUserId({ throttle = callback(), userId = localPlayer.UserId })
		end

		return false
	end
end
