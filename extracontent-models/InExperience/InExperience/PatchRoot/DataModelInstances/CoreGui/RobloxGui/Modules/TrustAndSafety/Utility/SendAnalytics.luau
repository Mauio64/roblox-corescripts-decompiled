local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local EventIngestService = game:GetService("EventIngestService")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local getPlatformTarget

if SharedFlags.GetFFlagShareGetPlatformTargetImpl() then
	local Analytics = require(CorePackages.Workspace.Packages.Analytics)
	getPlatformTarget = Analytics.getPlatformTarget
else
	getPlatformTarget = function()
		local v = Enum.Platform.None

		pcall(function()
			v = UserInputService:GetPlatform()
		end)

		local v2 = v == Enum.Platform.Windows or v == Enum.Platform.OSX

		local v3 = v == Enum.Platform.IOS or v == Enum.Platform.Android or v == Enum.Platform.UWP

		local v4 = v == Enum.Platform.XBox360
			or v == Enum.Platform.XBoxOne
			or v == Enum.Platform.PS3
			or v == Enum.Platform.PS4
			or v == Enum.Platform.WiiU

		return v2 and "client" or v3 and "mobile" or v4 and "console" or "unknownLua" .. tostring(v)
	end
end

return function(value, value2, options)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected eventName to be a string")
	assert(type(options) == "table", "Expected eventTable to be a table")

	local platformTarget = getPlatformTarget()

	options = options or {}

	options.universeId = tostring(game.GameId)

	EventIngestService:sendEventDeferred(platformTarget, value, value2, options)
end
