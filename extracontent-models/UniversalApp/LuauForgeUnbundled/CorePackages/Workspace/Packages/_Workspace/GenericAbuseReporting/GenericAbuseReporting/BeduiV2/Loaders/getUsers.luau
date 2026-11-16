local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Promise")

local fFlagAbuseReportInExpPlayerListV3 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagAbuseReportInExpPlayerListV3
local recentlyLeftSignals = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Signals/recentlyLeftSignals")

local accessoryType = Foundation.Enums.AccessoryType

local function appendRecentlyLeftItems(list, userIdSet, p2)
	local clone = table.clone(p2)
	table.sort(clone, function(a, b): boolean
		return a.username:lower() < b.username:lower()
	end)

	for i, v5 in ipairs(clone) do
		if not userIdSet[tostring(v5.userId)] then
			table.insert(list, {
				leading = { type = accessoryType.Avatar, userId = v5.userId },
				id = tostring(v5.userId),
				label = v5.displayName,
				description = v5.username,
				meta = { username = v5.username, displayName = v5.displayName }
			})
		end
	end

	return list
end

local function getUsers()
	return Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			local players = Players:GetPlayers()
			table.sort(players, function(a, b): boolean
				return a.Name:lower() < b.Name:lower()
			end)

			local userIdSet = {}
			local result2 = {}

			for i, player in ipairs(players) do
				if not (not localPlayer or player.UserId ~= localPlayer.UserId) then
					continue
				end

				if fFlagAbuseReportInExpPlayerListV3 then
					userIdSet[tostring(player.UserId)] = true
				end

				table.insert(result2, {
					leading = { type = accessoryType.Avatar, userId = player.UserId },
					id = tostring(player.UserId),
					label = player.DisplayName,
					description = player.Name,
					meta = { username = player.Name, displayName = player.DisplayName }
				})
			end

			if fFlagAbuseReportInExpPlayerListV3 then
				appendRecentlyLeftItems(result2, userIdSet, recentlyLeftSignals.getRecentlyLeft())
			end

			return result2
		end)

		if success then
			callback(result)
		else
			callback2(result)
		end
	end)
end

return getUsers
