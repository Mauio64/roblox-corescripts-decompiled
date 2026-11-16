local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Responsive")
local useIsWideMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCommon").Hooks.useIsWideMode

local FIntAppChatWideBreakpointMinHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatWideBreakpointMinHeight")
local FIntAppChatWideBreakpointMinWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatWideBreakpointMinWidth")

return function(p2)
	local v5 = useIsWideMode()
	local v6 = Responsive.useOrientation()
	local v7 = Responsive.useResponsive({
		{ Key = "wide", minWidth = FIntAppChatWideBreakpointMinWidth, minHeight = FIntAppChatWideBreakpointMinHeight }
	}) == "wide"

	if p2 then
		return v6 ~= Responsive.Keys.Portrait and v7 and true or false
	end

	return v5
end
