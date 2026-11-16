local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Foundation = require(parent.Foundation)
local Promise = require(parent.Promise)

local SharedFlags = require(parent.SharedFlags)
local FFlagAbuseReportInExpPlayerListV3 = SharedFlags.FFlagAbuseReportInExpPlayerListV3
local recentlyLeftSignals = require(GenericAbuseReporting.BeduiV2.Utils.Signals.recentlyLeftSignals)

local AccessoryType = Foundation.Enums.AccessoryType

local function appendRecentlyLeftItems(list, userIdSet, p)
	local clone = table.clone(p)
	table.sort(clone, function(a, b): boolean
		return a.username:lower() < b.username:lower()
	end)

	for _, v in ipairs(clone) do
		if not userIdSet[tostring(v.userId)] then
			table.insert(list, {
				leading = { type = AccessoryType.Avatar, userId = v.userId },
				id = tostring(v.userId),
				label = v.displayName,
				description = v.username,
				meta = { username = v.username, displayName = v.displayName }
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
			local result = {}

			for _, player in ipairs(players) do
				if not (not LocalPlayer or player.UserId ~= LocalPlayer.UserId) then
					continue
				end

				if FFlagAbuseReportInExpPlayerListV3 then
					userIdSet[tostring(player.UserId)] = true
				end

				table.insert(result, {
					leading = { type = AccessoryType.Avatar, userId = player.UserId },
					id = tostring(player.UserId),
					label = player.DisplayName,
					description = player.Name,
					meta = { username = player.Name, displayName = player.DisplayName }
				})
			end

			if FFlagAbuseReportInExpPlayerListV3 then
				appendRecentlyLeftItems(result, userIdSet, recentlyLeftSignals.getRecentlyLeft())
			end

			return result
		end)

		if success then
			callback(result)
		else
			callback2(result)
		end
	end)
end

return getUsers
