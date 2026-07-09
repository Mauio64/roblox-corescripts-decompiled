local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local jest = require(AvatarSwitcherParent.Dev.JestGlobals).jest
local Signals = require(AvatarSwitcherParent.Signals)

require(AvatarSwitcher.Enums.ExperienceAvatarSupportType)
require(AvatarSwitcher.types)

local function createMockAvatarSwitcherStore() -- line: 54
	-- upvalues: Signals (copy), jest (copy)
	local v6, v7 = Signals.createSignal({})
	local v8, v9 = Signals.createSignal(false)
	local v10, v11 = Signals.createSignal(nil)
	local v12, v13 = Signals.createSignal(nil)
	local v14, v15 = Signals.createSignal(false)
	local v16, v17 = Signals.createSignal(false)
	local v18, v19 = Signals.createSignal(false)
	local v20, v21 = Signals.createSignal(nil)
	local v22, v23 = Signals.createSignal(nil)
	local v24, v25 = Signals.createSignal(nil)

	return {
		store = {
			getOutfits = v6,
			getLastPageReached = v8,
			getSelectedOutfitId = v10,
			getSelectedOutfitDetails = v12,
			getRespawnPromptShown = v14,
			getIsSwitching = v16,
			getIsEmpty = v18,
			getExperienceAvatarSupportType = v20,
			getExperienceAvatarType = v22,
			getPendingAvatarName = v24,
			toggleRespawnPrompt = jest.fn(),
			selectOutfit = jest.fn(),
			fetchNextOutfitsPage = jest.fn(),
			switchAvatar = jest.fn(),
			fetchExperienceAvatarSupportType = jest.fn(),
			clearPendingAvatarName = jest.fn()
		},
		setOutfits = v7,
		setLastPageReached = v9,
		setSelectedOutfitId = v11,
		setSelectedOutfitDetails = v13,
		setRespawnPromptShown = v15,
		setIsSwitching = v17,
		setIsEmpty = v19,
		setExperienceAvatarSupportType = v21,
		setExperienceAvatarType = v23,
		setPendingAvatarName = v25
	}
end

return createMockAvatarSwitcherStore
