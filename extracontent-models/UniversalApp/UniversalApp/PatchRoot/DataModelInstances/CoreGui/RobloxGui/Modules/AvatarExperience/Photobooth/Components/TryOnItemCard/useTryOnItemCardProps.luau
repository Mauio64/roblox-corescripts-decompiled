local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local InventoryItemType = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Enums.InventoryItemType
local useAvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.Hooks.useAvatarRoute
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)

require(Modules.AvatarExperience.Common.Types)

local ToggleTryOnThunk = require(Modules.AvatarExperience.Common.Thunks.ToggleTryOnThunk)
local SetAnimationPreview = require(Modules.AvatarExperience.Common.Actions.SetAnimationPreview)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local ClearTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.ClearTryOns
local ClearAnimationPreview = require(Modules.AvatarExperience.Common.Actions.ClearAnimationPreview)

require(script.Parent.TryOnItemCard)

local function useTryOnItemCardProps(t1: {[any]: any}) -- line: 40
	-- upvalues: React (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), Analytics (copy), useAvatarRoute (copy), useNavigation (copy), Foundation (copy), InventoryItemType (copy), ItemData (copy), useSelector (copy), Utils (copy), ClearTryOns (copy), ClearAnimationPreview (copy), ToggleTryOnThunk (copy), SetAnimationPreview (copy)
	local v21 = React.useRef(nil)
	local v22 = useDispatch()
	local v23 = useRoactService(RoactNetworking)
	local v24 = useRoactService(Analytics)
	local v25 = useAvatarRoute()
	local v26 = useNavigation()
	local v27 = Foundation.Hooks.useTokens()
	local inventoryItemType = t1.inventoryItemType
	local v29 = React.useCallback(function(p1) -- line: 51
		-- upvalues: inventoryItemType (copy), InventoryItemType (copy), ItemData (copy), t1 (copy)
		if inventoryItemType == InventoryItemType.Asset then
			return (ItemData(p1.AvatarExperience.Common, t1.itemId, inventoryItemType))
		end

		return nil
	end, {
		inventoryItemType,
		t1.itemId
	})
	local v30 = useSelector(v29)
	local v31 = React.useCallback(function(p2) -- line: 58
		-- upvalues: inventoryItemType (copy), InventoryItemType (copy), t1 (copy)
		if inventoryItemType == InventoryItemType.Outfit then
			return p2.AvatarExperience.AvatarEditor.OutfitInfos[t1.itemId]
		end

		return nil
	end, {
		inventoryItemType,
		t1.itemId
	})
	local v32 = useSelector(v31)
	local v33 = if not v30 then not v32 and "" or v32.name else v30.name
	local v34 = if not v30 then nil else v30.assetType
	local v35 = useSelector(function(p3) -- line: 68
		-- upvalues: t1 (copy)
		local LastAnimOrEmoteToggledItem = p3.AvatarExperience.AvatarScene.OutfitTryOn.LastAnimOrEmoteToggledItem

		if LastAnimOrEmoteToggledItem and LastAnimOrEmoteToggledItem.itemId == t1.itemId then
			return true
		end

		local AnimationPreview = p3.AvatarExperience.AvatarScene.TryOn.AnimationPreview

		if AnimationPreview and AnimationPreview == t1.itemId then
			return true
		end

		return false
	end)
	local v36 = React.useCallback(function() -- line: 83
		-- upvalues: t1 (copy), v30 (copy), v35 (copy), v34 (copy), Utils (copy), v22 (copy), ClearTryOns (copy), ClearAnimationPreview (copy), ToggleTryOnThunk (copy), v23 (copy), v24 (copy), v25 (copy), v26 (copy), SetAnimationPreview (copy)
		if not t1.itemId or not v30 then
			return
		end

		local v42 = not v35
		local v43 = v34 and Utils.isAnimationAssetType(v34)

		v22(ClearTryOns())
		v22(ClearAnimationPreview())

		if v42 then
			v22(ToggleTryOnThunk(v23, v24, "Asset", v30.assetType, t1.itemId, v42, v25, v26, nil))

			if v43 and v42 then
				v22(SetAnimationPreview(t1.itemId, v30.assetType))
			end
		end

		if t1.onTileClicked then
			t1.onTileClicked()
		end
	end, {
		v22,
		v23,
		v24,
		v26,
		v25,
		t1.itemId,
		v35,
		v30,
		v34,
		t1.onTileClicked
	})

	return {
		showDynamicHeadIcon = false,
		itemId = t1.itemId,
		inventoryItemType = inventoryItemType,
		itemName = v33,
		isSelected = v35,
		thumbnailRef = v21,
		onActivated = v36,
		impressionsTag = t1.impressionsTag,
		assetType = v34,
		tokens = v27,
		ref = t1.ref
	}
end

return useTryOnItemCardProps
