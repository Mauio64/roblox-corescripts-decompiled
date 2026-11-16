local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)

require(ExpChat.Stores.GetPresetChatStore.createPresetChatStore)
local isChatRegionLocked = require(ExpChat.isChatRegionLocked)
local showChatEnabledUI = require(ExpChat.showChatEnabledUI)

local FFlagExpChatTopBannerForPresetChatAccess = ExpChat.Flags.FFlagExpChatTopBannerForPresetChatAccess
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled

local function getIsARButtonVisible(p: string, flag: boolean, p2)
	if isChatRegionLocked() then
		return false
	end

	if showChatEnabledUI(p) then
		return true
	end

	if FFlagExpChatPresetChatEnabled and FFlagExpChatTopBannerForPresetChatAccess then
		return flag and p2 ~= "Disabled"
	end

	return false
end

return getIsARButtonVisible
