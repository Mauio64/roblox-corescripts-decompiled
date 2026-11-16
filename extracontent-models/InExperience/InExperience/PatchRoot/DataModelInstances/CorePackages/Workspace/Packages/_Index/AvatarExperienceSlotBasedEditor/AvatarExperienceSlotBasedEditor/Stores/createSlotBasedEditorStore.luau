local AvatarExperienceSlotBasedEditor = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor")
local parent = AvatarExperienceSlotBasedEditor.Parent

local Signals = require(parent.Signals)

local RobloxAppEnums = require(parent.RobloxAppEnums)
local DeviceOrientationMode = RobloxAppEnums.DeviceOrientationMode
local Constants = require(AvatarExperienceSlotBasedEditor.Constants)
local Categories = require(AvatarExperienceSlotBasedEditor.Enums.Categories)

local AXCommon = require(parent.AXCommon)
local createSelectorSignal = AXCommon.Utils.createSelectorSignal

local buildSlots = require(AvatarExperienceSlotBasedEditor.Utils.buildSlots)

require(AvatarExperienceSlotBasedEditor.Types)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXSlotsDesktopRedesign = AvatarExperienceFlags.FFlagAXSlotsDesktopRedesign

local function createSlotBasedEditorStore(p)
	local selectorSignal = createSelectorSignal(p, function(p2): boolean
		return p2.DeviceOrientation == DeviceOrientationMode.Portrait
	end)
	local v

	if FFlagAXSlotsDesktopRedesign then
		if selectorSignal(false) then
			v = Categories.Avatars
		else
			v = Categories.All
		end
	elseif selectorSignal(false) then
		v = Categories.Avatars
	else
		v = Categories.Body
	end

	local signal, setSlotCategory = Signals.createSignal(v)
	local signal2, setSlotIndex = Signals.createSignal(1)

	local selectorSignal2 = createSelectorSignal(p, function(p2)
		return p2.AvatarExperience.AvatarEditor.Character.EquippedAssets or {}
	end)

	return {
		getSlotCategory = signal,
		setSlotCategory = setSlotCategory,
		getSlotIndex = signal2,
		setSlotIndex = setSlotIndex,
		getSlots = Signals.createComputed(function(p2)
			return buildSlots(Constants.SlotEditorCategories[signal(p2)].slots, selectorSignal2(p2))
		end)
	}
end

return createSlotBasedEditorStore
