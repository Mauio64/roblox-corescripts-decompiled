local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local React = require(CorePackages.Packages.React)

local function getLocalPlayerUserId()
	local localPlayer = Players.LocalPlayer

	if localPlayer then
		return localPlayer.UserId
	end

	return 0
end

local function useLocalPlayerUserId()
	local state, setState = React.useState(getLocalPlayerUserId)

	React.useEffect(function()
		local userIdChangedConnection = nil

		local function syncUserId()
			local localPlayer = Players.LocalPlayer
			setState(not localPlayer and 0 or localPlayer.UserId)
		end

		local function watchCurrentPlayer()
			if userIdChangedConnection then
				userIdChangedConnection:Disconnect()
				userIdChangedConnection = nil
			end

			local localPlayer = Players.LocalPlayer

			if localPlayer then
				userIdChangedConnection = localPlayer:GetPropertyChangedSignal("UserId"):Connect(syncUserId)
			end
		end

		local localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
			if userIdChangedConnection then
				userIdChangedConnection:Disconnect()
				userIdChangedConnection = nil
			end

			local localPlayer = Players.LocalPlayer

			if localPlayer then
				userIdChangedConnection = localPlayer:GetPropertyChangedSignal("UserId"):Connect(syncUserId)
			end

			local localPlayer2 = Players.LocalPlayer
			setState(not localPlayer2 and 0 or localPlayer2.UserId)
		end)

		if userIdChangedConnection then
			userIdChangedConnection:Disconnect()
			userIdChangedConnection = nil
		end

		local localPlayer = Players.LocalPlayer

		if localPlayer then
			userIdChangedConnection = localPlayer:GetPropertyChangedSignal("UserId"):Connect(syncUserId)
		end

		local localPlayer2 = Players.LocalPlayer
		setState(not localPlayer2 and 0 or localPlayer2.UserId)

		return function()
			localPlayerChangedConnection:Disconnect()

			if userIdChangedConnection then
				userIdChangedConnection:Disconnect()
			end
		end
	end, {})

	return state
end

return useLocalPlayerUserId
