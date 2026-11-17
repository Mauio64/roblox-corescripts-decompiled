local parent = script:FindFirstAncestor("ExpChat").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatStickyTabs = SharedFlags.FFlagExpChatStickyTabs

local function canReplaceUserSelectedTab(flag: boolean?): boolean
	return not (FFlagExpChatStickyTabs and flag)
end

return canReplaceUserSelectedTab
