local AvatarExperienceSlotBasedEditor = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor")
local AvatarExperienceSlotBasedEditorParent = AvatarExperienceSlotBasedEditor.Parent
local Signals = require(AvatarExperienceSlotBasedEditorParent.Signals)
local DeviceOrientationMode = require(AvatarExperienceSlotBasedEditorParent.RobloxAppEnums).DeviceOrientationMode
local Constants = require(AvatarExperienceSlotBasedEditor.Constants)
local Categories = require(AvatarExperienceSlotBasedEditor.Enums.Categories)
local createSelectorSignal = require(AvatarExperienceSlotBasedEditorParent.AXCommon).Utils.createSelectorSignal
local buildSlots = require(AvatarExperienceSlotBasedEditor.Utils.buildSlots)

require(AvatarExperienceSlotBasedEditor.Types)

local FFlagAXSlotsDesktopRedesign = require(AvatarExperienceSlotBasedEditorParent.AvatarExperienceFlags).FFlagAXSlotsDesktopRedesign

local function createSlotBasedEditorStore(p1) -- line: 30
	-- upvalues: createSelectorSignal (copy), DeviceOrientationMode (copy), FFlagAXSlotsDesktopRedesign (copy), Categories (copy), Signals (copy), buildSlots (copy), Constants (copy)
	local v12 = createSelectorSignal(p1, function(p2) -- line: 32
		-- upvalues: DeviceOrientationMode (copy)
		return p2.DeviceOrientation == DeviceOrientationMode.Portrait
	end)
	local v13 = if not FFlagAXSlotsDesktopRedesign then if not v12(false) then Categories.Body else Categories.Avatars else if not v12(false) then Categories.All else Categories.Avatars
	local v14, v15 = Signals.createSignal(v13)
	local v16, v17 = Signals.createSignal(1)
	local v18 = createSelectorSignal(p1, function(p3) -- line: 45
		return p3.AvatarExperience.AvatarEditor.Character.EquippedAssets or {}
	end)
	local v19 = Signals.createComputed(function(p4) -- line: 52
		-- upvalues: buildSlots (copy), Constants (copy), v14 (copy), v18 (copy)
		return buildSlots(Constants.SlotEditorCategories[v14(p4)].slots, v18(p4))
	end)

	return {
		getSlotCategory = v14,
		setSlotCategory = v15,
		getSlotIndex = v16,
		setSlotIndex = v17,
		getSlots = v19
	}
end

return createSlotBasedEditorStore
