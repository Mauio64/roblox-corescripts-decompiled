local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local GetUsersStore = require(Moments.Stores.GetUsersStore)

local Players = game:GetService("Players")

local useSignalState = SignalsReact.useSignalState

return function(p: number)
	local usersStore = GetUsersStore(false)
	local username = useSignalState(usersStore.getUserProfile((tostring(p)))).username

	React.useEffect(function()
		if username ~= nil then
			return
		end

		local v = false

		task.spawn(function()
			local success, result = pcall(function()
				return Players:GetNameFromUserIdAsync(p)
			end)

			if success and not v then
				usersStore.updateUsername(p, result)
			end
		end)

		return function()
			v = true
		end
	end, { p, username, usersStore.updateUsername })

	return username
end
