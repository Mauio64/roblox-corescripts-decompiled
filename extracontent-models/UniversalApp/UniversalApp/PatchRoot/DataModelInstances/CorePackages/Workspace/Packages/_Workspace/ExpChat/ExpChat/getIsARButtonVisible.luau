local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)

require(ExpChat.Stores.GetPresetChatStore.createPresetChatStore)

local isChatRegionLocked = require(ExpChat.isChatRegionLocked)
local showChatEnabledUI = require(ExpChat.showChatEnabledUI)
local FFlagExpChatTopBannerForPresetChatAccess = ExpChat.Flags.FFlagExpChatTopBannerForPresetChatAccess
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled

local function getIsARButtonVisible(s1: string, b1: boolean, p1) -- line: 30
	-- upvalues: isChatRegionLocked (copy), showChatEnabledUI (copy), FFlagExpChatPresetChatEnabled (copy), FFlagExpChatTopBannerForPresetChatAccess (copy)
	if isChatRegionLocked() then
		return false
	end

	if showChatEnabledUI(s1) then
		return true
	end

	if FFlagExpChatPresetChatEnabled and FFlagExpChatTopBannerForPresetChatAccess then
		return b1 and p1 ~= "Disabled"
	end

	return false
end

return getIsARButtonVisible
