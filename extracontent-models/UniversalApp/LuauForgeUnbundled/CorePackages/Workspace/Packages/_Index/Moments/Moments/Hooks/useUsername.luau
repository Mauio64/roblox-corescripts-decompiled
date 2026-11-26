local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local GetUsersStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetUsersStore")

local Players = game:GetService("Players")

local useSignalState = SignalsReact.useSignalState

return function(p2)
	local v5 = GetUsersStore(false)
	local username = useSignalState(v5.getUserProfile((tostring(p2)))).username

	React.useEffect(function()
		if username ~= nil then
			return
		end

		local v6 = false

		task.spawn(function()
			local success, result = pcall(function()
				return Players:GetNameFromUserIdAsync(p2)
			end)

			if success and not v6 then
				v5.updateUsername(p2, result)
			end
		end)

		return function()
			v6 = true
		end
	end, { p2, username, v5.updateUsername })

	return username
end
