local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Signals")

local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/RobloxAppEnums").DeviceOrientationMode
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Constants")
local Categories = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/Categories")

local createSelectorSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceCommon").Utils.createSelectorSignal

local buildSlots = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Utils/buildSlots")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Types")

local fFlagAXSlotsDesktopRedesign = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceFlags").FFlagAXSlotsDesktopRedesign

local function createSlotBasedEditorStore(p2)
	local selectorSignal = createSelectorSignal(p2, function(p3): boolean
		return p3.DeviceOrientation == deviceOrientationMode.Portrait
	end)
	local v5

	if fFlagAXSlotsDesktopRedesign then
		v5 = if selectorSignal(false) then Categories.Avatars else Categories.All
	else
		v5 = if selectorSignal(false) then Categories.Avatars else Categories.Body
	end

	local signal, v6 = Signals.createSignal(v5)
	local signal2, v7 = Signals.createSignal(1)

	local selectorSignal2 = createSelectorSignal(p2, function(p3)
		return p3.AvatarExperience.AvatarEditor.Character.EquippedAssets or {}
	end)

	return {
		getSlotCategory = signal,
		setSlotCategory = v6,
		getSlotIndex = signal2,
		setSlotIndex = v7,
		getSlots = Signals.createComputed(function(p3)
			return buildSlots(Constants.SlotEditorCategories[signal(p3)].slots, selectorSignal2(p3))
		end)
	}
end

return createSlotBasedEditorStore
