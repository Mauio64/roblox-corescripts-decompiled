local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local ReceivedAvatarData = require(Modules.AvatarExperience.AvatarEditor.Actions.ReceivedAvatarData)
local SetSelectedEmoteSlot = require(Modules.AvatarExperience.AvatarEditor.Actions.SetSelectedEmoteSlot)
local ToggleEquipAsset = require(Modules.AvatarExperience.AvatarEditor.Actions.ToggleEquipAsset)
local CharacterHistoryStateChangeButtonActivated = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).State.Actions.CharacterHistoryStateChangeButtonActivated
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local t1 = {
	selectedSlot = 1,
	slotInfo = {}
}

local function createSlotInfo(p1) -- line: 48
	local t2 = {}

	for _, v19 in p1 do
		local position = v19.position

		t2[position] = {
			assetId = tostring(v19.assetId),
			position = position
		}
	end

	return t2
end
local function addEmoteToSlot(t3: {[any]: any}, n1: number, t4: {[any]: any}) -- line: 64
	-- upvalues: Cryo (copy)
	return Cryo.Dictionary.join(t3, {
		[n1] = t4
	})
end
local function removeEmoteFromSlot(t5: {[any]: any}, n2: number) -- line: 74
	-- upvalues: Cryo (copy)
	return Cryo.Dictionary.join(t5, {
		[n2] = Cryo.None
	})
end

return Rodux.createReducer(t1, {
	[ReceivedAvatarData.name] = function(t6: {[any]: any}, p2) -- line: 83
		-- upvalues: createSlotInfo (copy), Cryo (copy)
		local v28 = p2.avatarData.emotes or {}
		local v29 = createSlotInfo(v28)

		return Cryo.Dictionary.join(t6, {
			slotInfo = v29
		})
	end,
	[CharacterHistoryStateChangeButtonActivated.name] = function(t7: {[any]: any}, p3) -- line: 94
		-- upvalues: FFlagAXRootSlotBasedEditorFlag (copy), Cryo (copy)
		if FFlagAXRootSlotBasedEditorFlag and (p3.equipped and next(p3.equipped) ~= nil and p3.equipped.EquippedEmotes) then
			return Cryo.Dictionary.join(t7, {
				slotInfo = p3.equipped.EquippedEmotes.slotInfo
			})
		end

		return t7
	end,
	[ToggleEquipAsset.name] = function(t8: {[any]: any}, p4) -- line: 115
		-- upvalues: Constants (copy), Cryo (copy)
		if p4.assetTypeId ~= Constants.AssetTypeIdStrings.EmoteAnimation then
			return t8
		end

		local v34 = t8.slotInfo[t8.selectedSlot]
		local t9 = {
			assetId = p4.assetId,
			position = t8.selectedSlot
		}
		local v38

		if not v34 or v34.assetId ~= t9.assetId then
			local slotInfo = t8.slotInfo
			local selectedSlot = t8.selectedSlot

			v38 = Cryo.Dictionary.join(slotInfo, {
				[selectedSlot] = t9
			})
		else
			local slotInfo = t8.slotInfo
			local selectedSlot = t8.selectedSlot

			v38 = Cryo.Dictionary.join(slotInfo, {
				[selectedSlot] = Cryo.None
			})
		end

		return Cryo.Dictionary.join(t8, {
			slotInfo = v38
		})
	end,
	[SetSelectedEmoteSlot.name] = function(p5, p6) -- line: 139
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p5, {
			selectedSlot = p6.selectedSlot
		})
	end
})
