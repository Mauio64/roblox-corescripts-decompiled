local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local tutils = require(CorePackages.Packages.tutils)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)

require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)

local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local ToggleEquipAsset = require(Modules.AvatarExperience.AvatarEditor.Actions.ToggleEquipAsset)
local ClearTryOns = AvatarExperienceRodux.Actions.ClearTryOns
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ClearCurrentSort = require(Modules.AvatarExperience.LayeredClothingSort.Actions.ClearCurrentSort)
local StartedWaitingOnLCUpdate = require(Modules.AvatarExperience.Common.Actions.StartedWaitingOnLCUpdate)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)

require(Modules.AvatarExperience.Common.Types)

local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local ToggleTryOn = AvatarExperienceRodux.Actions.ToggleTryOn
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local MaxHats = Constants2.MaxHats
local t1 = {
	toastMessage = "Feature.Avatar.Message.HatLimitTooltip",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local t2 = {
	toastMessage = "Feature.Avatar.EmoteAlreadyAssigned",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

return function(s1: string, s2: string, p1, b1: boolean?, n1: number?, p2, t3: {[any]: any}?) -- line: 54
	-- upvalues: Cryo (copy), ClearTryOns (copy), NavigationUtils (copy), FFlagAXMISEnableMultiShopping (copy), ToggleTryOn (copy), Constants (copy), SetCurrentToastMessage (copy), t2 (copy), tutils (copy), MaxHats (copy), t1 (copy), ClearCurrentSort (copy), StartedWaitingOnLCUpdate (copy), Utils (copy), ToggleEquipAsset (copy), FFlagAXCustomizeMakeupSupport (copy)
	return function(p3) -- line: 63
		-- upvalues: b1 (copy), Cryo (copy), ClearTryOns (copy), p1 (copy), NavigationUtils (copy), FFlagAXMISEnableMultiShopping (copy), ToggleTryOn (copy), Constants (copy), s1 (copy), s2 (copy), SetCurrentToastMessage (copy), t2 (copy), tutils (copy), MaxHats (copy), t1 (copy), ClearCurrentSort (copy), StartedWaitingOnLCUpdate (copy), Utils (copy), ToggleEquipAsset (copy), FFlagAXCustomizeMakeupSupport (copy), t3 (copy), n1 (copy), p2 (copy)
		local EquippedAssets = p3:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets

		if not EquippedAssets then
			return false
		end

		if p3:getState().AvatarExperience.LayeredClothingSort.CharacterUpdatesLocked then
			return false
		end

		if not b1 then
			local TryOnItems = p3:getState().AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

			if not Cryo.isEmpty(TryOnItems) then
				p3:dispatch(ClearTryOns())

				if p1 then
					NavigationUtils.closeFiltersAndItemDetails(p1)
				end
			end
		elseif FFlagAXMISEnableMultiShopping then
			p3:dispatch(ToggleTryOn(Constants.ItemType.Asset, s1, s2, false))

			if p1 then
				NavigationUtils.closeFiltersAndItemDetails(p1)
			end
		end

		if s1 == Constants.AssetTypeIdStrings.EmoteAnimation then
			local EquippedEmotes = p3:getState().AvatarExperience.AvatarEditor.EquippedEmotes
			local v34 = EquippedEmotes.slotInfo[EquippedEmotes.selectedSlot]

			if not v34 or v34.assetId ~= s2 then
				for _, v36 in EquippedEmotes.slotInfo do
					if v36.assetId == s2 then
						p3:dispatch(SetCurrentToastMessage(t2))

						return false
					end
				end
			end
		end

		local v37 = EquippedAssets[Constants.AssetTypeIdStrings.Hat]
		local n2 = 0

		if v37 then
			n2 = tutils.fieldCount(v37)
		end

		if s1 == Constants.AssetTypeIdStrings.Hat and v37 and n2 >= MaxHats then
			local v39 = false

			if (v37 or {})[s2] then
				v39 = true
			end

			if not v39 then
				p3:dispatch(SetCurrentToastMessage(t1))

				return false
			end
		end

		if #p3:getState().AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList ~= 0 then
			p3:dispatch(ClearCurrentSort())
		end

		if Constants.LayeredAssetTypes[s1] ~= nil then
			p3:dispatch(StartedWaitingOnLCUpdate())
		end

		local v40 = Utils.isDynamicHeadEquipped(EquippedAssets)

		if s1 == Constants.AssetTypeIdStrings.Face and v40 then
			for v41, _ in Constants.DynamicHeadAssetTypes do
				for _, v44 in (Utils.getEquippedAssetIdsForType(EquippedAssets, v41)) do
					p3:dispatch(ToggleEquipAsset(v41, v44))
				end
			end
		end

		if FFlagAXCustomizeMakeupSupport and t3 then
			for _, v46 in t3 do
				if EquippedAssets[v46] then
					for v47, v48 in EquippedAssets[v46] do
						if v48.order == n1 then
							p3:dispatch(ToggleEquipAsset(v46, v47))
						end
					end
				end
			end
		end

		p3:dispatch(ToggleEquipAsset(s1, s2, n1, p2))

		return true
	end
end
