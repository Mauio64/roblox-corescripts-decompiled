local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Responsive = require(AppChatParent.Responsive)
local useIsWideMode = require(AppChatParent.SocialCommon).Hooks.useIsWideMode
local FIntAppChatWideBreakpointMinHeight = require(AppChat.Flags.FIntAppChatWideBreakpointMinHeight)
local FIntAppChatWideBreakpointMinWidth = require(AppChat.Flags.FIntAppChatWideBreakpointMinWidth)

return function(b1: boolean) -- line: 10
	-- upvalues: useIsWideMode (copy), Responsive (copy), FIntAppChatWideBreakpointMinWidth (copy), FIntAppChatWideBreakpointMinHeight (copy)
	local v8 = useIsWideMode()
	local v9 = Responsive.useOrientation()
	local v10 = Responsive.useResponsive({{
		Key = "wide",
		minWidth = FIntAppChatWideBreakpointMinWidth,
		minHeight = FIntAppChatWideBreakpointMinHeight
	}}) == "wide"

	if not b1 then
		return v8
	end

	local v11 = true

	if v9 == Responsive.Keys.Portrait or not v10 then
		v11 = false
	end

	return v11
end
