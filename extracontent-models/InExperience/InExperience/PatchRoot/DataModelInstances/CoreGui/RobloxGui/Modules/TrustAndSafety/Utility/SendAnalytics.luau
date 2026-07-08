local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local EventIngestService = game:GetService("EventIngestService")
local getPlatformTarget

if require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagShareGetPlatformTargetImpl() then
	getPlatformTarget = require(CorePackages.Workspace.Packages.Analytics).getPlatformTarget
else
	function getPlatformTarget() -- line: 12
		-- upvalues: UserInputService (copy)
		local None = Enum.Platform.None

		pcall(function() -- line: 18
			-- upvalues: None (ref), UserInputService (copy)
			None = UserInputService:GetPlatform()
		end)

		local v6 = None == Enum.Platform.Windows or None == Enum.Platform.OSX
		local v7 = None == Enum.Platform.IOS or None == Enum.Platform.Android or None == Enum.Platform.UWP
		local v8 = None == Enum.Platform.XBox360 or None == Enum.Platform.XBoxOne or (None == Enum.Platform.PS3 or None == Enum.Platform.PS4) or None == Enum.Platform.WiiU

		return if not v6 then if not v7 then if not v8 then "unknownLua" .. tostring(None) else "console" else "mobile" else "client"
	end
end

return function(p1, p2, p3) -- line: 49
	-- upvalues: getPlatformTarget (ref), EventIngestService (copy)
	assert(type(p1) == "string", "Expected eventContext to be a string")
	assert(type(p2) == "string", "Expected eventName to be a string")
	assert(type(p3) == "table", "Expected eventTable to be a table")

	local v12 = getPlatformTarget()

	if not p3 then
		p3 = {}
	end

	p3.universeId = tostring(game.GameId)
	EventIngestService:sendEventDeferred(v12, p1, p2, p3)
end
