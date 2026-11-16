local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local parent = AvatarSwitcher.Parent

local JestGlobals = require(parent.Dev.JestGlobals)
local jest = JestGlobals.jest
local Signals = require(parent.Signals)

require(AvatarSwitcher.Enums.ExperienceAvatarSupportType)

require(AvatarSwitcher.types)

local function createMockAvatarSwitcherStore()
	local signal, setOutfits = Signals.createSignal({})
	local signal2, setLastPageReached = Signals.createSignal(false)
	local signal3, setSelectedOutfitId = Signals.createSignal(nil)
	local signal4, setSelectedOutfitDetails = Signals.createSignal(nil)
	local signal5, setRespawnPromptShown = Signals.createSignal(false)
	local signal6, setIsSwitching = Signals.createSignal(false)
	local signal7, setIsEmpty = Signals.createSignal(false)

	local signal8, setExperienceAvatarSupportType = Signals.createSignal(nil)
	local signal9, setExperienceAvatarType = Signals.createSignal(nil)
	local signal10, setPendingAvatarName = Signals.createSignal(nil)

	return {
		store = {
			getOutfits = signal,
			getLastPageReached = signal2,
			getSelectedOutfitId = signal3,
			getSelectedOutfitDetails = signal4,
			getRespawnPromptShown = signal5,
			getIsSwitching = signal6,
			getIsEmpty = signal7,
			getExperienceAvatarSupportType = signal8,
			getExperienceAvatarType = signal9,
			getPendingAvatarName = signal10,
			toggleRespawnPrompt = jest.fn(),
			selectOutfit = jest.fn(),
			fetchNextOutfitsPage = jest.fn(),
			switchAvatar = jest.fn(),
			fetchExperienceAvatarSupportType = jest.fn(),
			clearPendingAvatarName = jest.fn()
		},
		setOutfits = setOutfits,
		setLastPageReached = setLastPageReached,
		setSelectedOutfitId = setSelectedOutfitId,
		setSelectedOutfitDetails = setSelectedOutfitDetails,
		setRespawnPromptShown = setRespawnPromptShown,
		setIsSwitching = setIsSwitching,
		setIsEmpty = setIsEmpty,
		setExperienceAvatarSupportType = setExperienceAvatarSupportType,
		setExperienceAvatarType = setExperienceAvatarType,
		setPendingAvatarName = setPendingAvatarName
	}
end

return createMockAvatarSwitcherStore
