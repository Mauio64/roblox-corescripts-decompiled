local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Responsive = require(parent.Responsive)
local SocialCommon = require(parent.SocialCommon)
local useIsWideMode = SocialCommon.Hooks.useIsWideMode

local FIntAppChatWideBreakpointMinHeight = require(AppChat.Flags.FIntAppChatWideBreakpointMinHeight)
local FIntAppChatWideBreakpointMinWidth = require(AppChat.Flags.FIntAppChatWideBreakpointMinWidth)

return function(flag: boolean)
	local v = useIsWideMode()
	local v2 = Responsive.useOrientation()
	local v3 = Responsive.useResponsive({
		{
			Key = "wide",
			minWidth = FIntAppChatWideBreakpointMinWidth,
			minHeight = FIntAppChatWideBreakpointMinHeight
		}
	}) == "wide"

	if flag then
		return v2 ~= Responsive.Keys.Portrait and v3 and true or false
	end

	return v
end
