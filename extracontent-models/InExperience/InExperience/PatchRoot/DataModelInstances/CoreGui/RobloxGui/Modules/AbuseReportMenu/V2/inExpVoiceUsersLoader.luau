local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Foundation = require(CorePackages.Packages.Foundation)
local RobloxGui = CoreGui.RobloxGui
local AccessoryType = Foundation.Enums.AccessoryType
local Promise = require(CorePackages.Packages.Promise)
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default

return {
	type = "listItem",
	fetch = function(_) -- line: 15
		-- upvalues: default (copy), Promise (copy), Players (copy), AccessoryType (copy)
		local ok, result = pcall(function() -- line: 16
			-- upvalues: default (copy)
			return default:getRecentUsersInteractionData()
		end)

		if ok then
			if not result then
				return Promise.resolve({})
			end

			local LocalPlayer = Players.LocalPlayer
			local t1 = {}

			for _, v in pairs(result) do
				local player = v.player
				local v17 = not not LocalPlayer and player.UserId == LocalPlayer.UserId

				if player and not v17 then
					table.insert(t1, {
						leading = {
							type = AccessoryType.Avatar,
							userId = player.UserId
						},
						id = tostring(player.UserId),
						label = player.DisplayName,
						description = "@" .. player.Name,
						meta = {
							username = player.Name,
							displayName = player.DisplayName
						}
					})
				end
			end

			table.sort(t1, function(p2, p3) -- line: 43
				return p2.label < p3.label
			end)

			return Promise.resolve(t1)
		end

		return Promise.reject("Failed to fetch voice users")
	end
}
