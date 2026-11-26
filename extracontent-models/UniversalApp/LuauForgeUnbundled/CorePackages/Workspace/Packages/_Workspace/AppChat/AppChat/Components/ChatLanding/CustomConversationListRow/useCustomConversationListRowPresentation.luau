local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local ChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext")
local useThemeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ThemeBackground").useThemeBackground
local FFlagAppThemeHalloween2026ChatBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppThemeHalloween2026ChatBackground")
local useChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/useChatPagePadding")

local function useCustomConversationListRowPresentation(p2)
	local v5 = useChatPagePadding()
	local v6 = ChatPlacementContext.useChatPlacementContext()

	local v7 = if FFlagAppThemeHalloween2026ChatBackground then useThemeBackground() ~= nil else false

	local onActivated = p2.onActivated
	local v8 = React.useCallback(function()
		if onActivated ~= nil then
			onActivated()
		end
	end, { onActivated })

	return {
		entryHeight = p2.entryHeight or 64,
		pagePaddingLeft = v5.left,
		pagePaddingRight = v5.right,
		showBackground = not (ChatPlacementContext.isPlacementInExperience(v6.chatPlacement) or v7),
		onActivated = v8
	}
end

return useCustomConversationListRowPresentation
