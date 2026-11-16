local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Foundation = require(CorePackages.Packages.Foundation)
local RobloxGui = CoreGui.RobloxGui

local AccessoryType = Foundation.Enums.AccessoryType

local Promise = require(CorePackages.Packages.Promise)
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default

return {
	type = "listItem",
	fetch = function(_)
		local success, result = pcall(function()
			return default:getRecentUsersInteractionData()
		end)

		if not success then
			return Promise.reject("Failed to fetch voice users")
		end

		if not result then
			return Promise.resolve({})
		end

		local localPlayer = Players.LocalPlayer
		local v = {}

		for _, v2 in pairs(result) do
			local player = v2.player
			local v3

			if localPlayer then
				v3 = player.UserId == localPlayer.UserId
			else
				v3 = false
			end

			if not player or v3 then
				continue
			end

			table.insert(v, {
				leading = { type = AccessoryType.Avatar, userId = player.UserId },
				id = tostring(player.UserId),
				label = player.DisplayName,
				description = "@" .. player.Name,
				meta = { username = player.Name, displayName = player.DisplayName }
			})
		end

		table.sort(v, function(a, b): boolean
			return a.label < b.label
		end)

		return Promise.resolve(v)
	end
}
