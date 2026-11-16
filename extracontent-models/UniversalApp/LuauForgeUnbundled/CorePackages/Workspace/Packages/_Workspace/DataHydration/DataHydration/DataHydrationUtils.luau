local Players = game:GetService("Players")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Cryo")

return {
	areAllKeysPresent = function(p2, list): boolean
		if p2 == nil or type(p2) ~= "table" then
			return #list == 0
		end

		for k, item in list do
			if p2[item] == nil then
				return false
			end
		end

		return true
	end,
	getLocalPlayerUserId = function()
		local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or nil

		if userId == nil or userId <= 0 then
			return nil
		end

		return userId
	end,
	observeLocalPlayerUserId = function(callback)
		local v5 = Players.LocalPlayer and Players.LocalPlayer.UserId or nil

		if v5 == nil or v5 <= 0 then
			v5 = nil
		end

		local userIdChangedConnection = nil

		local flag = false

		local function notifyIfChanged()
			local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or nil

			if userId == nil or userId <= 0 then
				userId = nil
			end

			if userId == v5 then
				return
			end

			v5 = userId
			callback(userId)
		end

		local function bindLocalPlayer()
			if userIdChangedConnection ~= nil then
				userIdChangedConnection:Disconnect()
				userIdChangedConnection = nil
			end

			local localPlayer = Players.LocalPlayer

			if localPlayer ~= nil then
				userIdChangedConnection = localPlayer:GetPropertyChangedSignal("UserId"):Connect(notifyIfChanged)
			end
		end

		if userIdChangedConnection ~= nil then
			userIdChangedConnection:Disconnect()
			userIdChangedConnection = nil
		end

		local localPlayer = Players.LocalPlayer

		if localPlayer ~= nil then
			userIdChangedConnection = localPlayer:GetPropertyChangedSignal("UserId"):Connect(notifyIfChanged)
		end

		local localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
			if userIdChangedConnection ~= nil then
				userIdChangedConnection:Disconnect()
				userIdChangedConnection = nil
			end

			local localPlayer2 = Players.LocalPlayer

			if localPlayer2 ~= nil then
				userIdChangedConnection = localPlayer2:GetPropertyChangedSignal("UserId"):Connect(notifyIfChanged)
			end

			local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or nil

			if userId == nil or userId <= 0 then
				userId = nil
			end

			if userId == v5 then
				return
			end

			v5 = userId
			callback(userId)
		end)

		return function()
			if flag then
				return
			end

			flag = true

			if userIdChangedConnection ~= nil then
				userIdChangedConnection:Disconnect()
				userIdChangedConnection = nil
			end

			if localPlayerChangedConnection ~= nil then
				localPlayerChangedConnection:Disconnect()
				localPlayerChangedConnection = nil
			end
		end
	end,
	mergeListsWithoutDuplicates = function(list, list2, p2)
		if list2 and #list2 ~= 0 then
			if not list or #list == 0 then
				return list2
			end

			local set = Cryo.List.toSet(Cryo.List.map(list, function(p3)
				if p2 then
					return p3[p2]
				end

				return p3
			end))

			local filtered = Cryo.List.filter(list2, function(p3): boolean
				if p2 then
					p3 = p3[p2]
				end

				return not set[p3]
			end)

			return Cryo.List.join(table.clone(list), filtered)
		elseif list then
			return list
		else
			return {}
		end
	end
}
