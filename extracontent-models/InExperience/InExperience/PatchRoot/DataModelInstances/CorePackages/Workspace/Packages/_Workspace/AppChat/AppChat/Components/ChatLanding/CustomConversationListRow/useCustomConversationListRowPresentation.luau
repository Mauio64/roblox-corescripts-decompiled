local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)

local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local ThemeBackground = require(parent.ThemeBackground)
local useThemeBackground = ThemeBackground.useThemeBackground
local FFlagAppThemeHalloween2026ChatBackground = require(AppChat.Flags.FFlagAppThemeHalloween2026ChatBackground)
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)

local function useCustomConversationListRowPresentation(p)
	local v = useChatPagePadding()
	local v2 = ChatPlacementContext.useChatPlacementContext()
	local v3

	if FFlagAppThemeHalloween2026ChatBackground then
		v3 = useThemeBackground() ~= nil
	else
		v3 = false
	end

	local onActivated = p.onActivated
	local onActivated2 = React.useCallback(function()
		if onActivated ~= nil then
			onActivated()
		end
	end, { onActivated })

	return {
		entryHeight = p.entryHeight or 64,
		pagePaddingLeft = v.left,
		pagePaddingRight = v.right,
		showBackground = not (ChatPlacementContext.isPlacementInExperience(v2.chatPlacement) or v3),
		onActivated = onActivated2
	}
end

return useCustomConversationListRowPresentation
