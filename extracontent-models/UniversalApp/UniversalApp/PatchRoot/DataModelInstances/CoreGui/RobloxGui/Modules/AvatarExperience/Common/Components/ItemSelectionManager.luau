local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local ToggleTryOnThunk = require(Modules.AvatarExperience.Common.Thunks.ToggleTryOnThunk)
local ClearAnimationPreview = require(Modules.AvatarExperience.Common.Actions.ClearAnimationPreview)
local StoreAndClearTryOns = require(Modules.AvatarExperience.Common.Thunks.StoreAndClearTryOns)
local ClearAllResultsListFocusedWidgets = require(Modules.AvatarExperience.Catalog.Actions.ClearAllResultsListFocusedWidgets)
local AppPage = require(Modules.LuaApp.AppPage)
local SetOutfitTryOns = require(Modules.AvatarExperience.Common.Actions.SetOutfitTryOns)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local DeepLinkUtils = require(Modules.AvatarExperience.Common.DeepLinkUtils)
local withAppRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAppRoute)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AvatarScreenProperties = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties
local Constants = require(Modules.AvatarExperience.Common.Constants)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)

require(Modules.AvatarExperience.Common.Types)

local NavigatedToNonTryOnPage = require(Modules.AvatarExperience.Common.Actions.NavigatedToNonTryOnPage)
local NavigatedToTryOnPage = require(Modules.AvatarExperience.Common.Actions.NavigatedToTryOnPage)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXTryOnScreenFixes = AvatarExperienceFlags.FFlagAXTryOnScreenFixes
local FFlagAXFixLookTryOnReturnRemoval = AvatarExperienceFlags.FFlagAXFixLookTryOnReturnRemoval
local v30 = Roact.PureComponent:extend("ItemSelectionManager")

v30.validateProps = t.strictInterface({
	avatarRoute = t.table,
	itemSubType = t.optional(t.string),
	selectedAnimationPreview = t.optional(t.string),
	lastToggledItem = t.optional(t.table),
	lastSavedTriedOnOutfit = t.optional(t.table),
	tryOnItems = t.optional(t.table),
	lookId = if not FFlagAXFixLookTryOnReturnRemoval then nil else t.optional(t.string),
	externalNavigationRequestParams = t.optional(t.table),
	storeAndClearTryOns = t.callback,
	setOutfitTryOns = t.callback,
	clearAnimationPreview = t.callback,
	toggleTryOn = t.callback,
	clearAllResultsListFocusedWidget = t.callback,
	onNavigatedToNonTryOnPage = t.callback,
	onNavigatedToTryOnPage = t.callback,
	networking = t.callback,
	appAnalytics = t.table,
	catalogAnalytics = t.table
})
v30.defaultProps = {
	lastToggledItem = {}
}

function v30.render(_) -- line: 85
	return nil
end

local t1 = {
	[AvatarScreen.ItemDetails] = true,
	[AvatarScreen.TryOnItem] = not FFlagAXTryOnScreenFixes or nil
}
local t2 = {
	[AvatarScreen.LayeredClothingSort] = true,
	[AvatarScreen.AccessoryAdjustment] = true,
	[AvatarScreen.TryOnItem] = not not FFlagAXTryOnScreenFixes or nil
}

local function getIdAndType(p2) -- line: 100
	-- upvalues: t1 (copy)
	local current = p2.avatarRoute.current

	if t1[current.name] then
		return current.params.itemId, current.params.itemType
	end

	return nil, nil
end
local function shouldClearAnimationPreview(p3) -- line: 109
	-- upvalues: Constants (copy)
	if p3.isUnequipped then
		return true
	end

	if p3.itemType == Constants.ItemType.Asset then
		return Constants.AssetTypeIdToCategory[p3.itemSubType] ~= Constants.AssetCategories.Animation
	end

	return p3.itemSubType ~= Constants.BundleTypeIdStrings.Animations
end
local function isSingleTryOn(p4) -- line: 121
	-- upvalues: FFlagAXMISEnableMultiShopping (copy), AvatarScreenProperties (copy)
	if FFlagAXMISEnableMultiShopping then
		return false
	end

	local avatarRoute = p4.avatarRoute

	return AvatarScreenProperties[avatarRoute.opaque.name] and not AvatarScreenProperties[avatarRoute.opaque.name].isMultiTryOn
end

function v30.willUpdate(p5, p6) -- line: 131
	-- upvalues: t2 (copy), t1 (copy), FFlagAXMISEnableMultiShopping (copy), AvatarScreenProperties (copy), DeepLinkUtils (copy), FFlagAXFixLookTryOnReturnRemoval (copy)
	if t2[p6.avatarRoute.current.name] then
		return
	end

	local current = p6.avatarRoute.current
	local itemId, itemType

	if t1[current.name] then
		itemId = current.params.itemId
		itemType = current.params.itemType
	else
		itemId = nil
		itemType = nil
	end

	local itemSubType = p6.itemSubType
	local v49

	if FFlagAXMISEnableMultiShopping then
		v49 = false
	else
		local avatarRoute = p6.avatarRoute

		v49 = AvatarScreenProperties[avatarRoute.opaque.name] and not AvatarScreenProperties[avatarRoute.opaque.name].isMultiTryOn
	end

	local props = p5.props
	local v52

	if FFlagAXMISEnableMultiShopping then
		v52 = false
	else
		local avatarRoute = props.avatarRoute

		v52 = AvatarScreenProperties[avatarRoute.opaque.name] and not AvatarScreenProperties[avatarRoute.opaque.name].isMultiTryOn
	end

	if v49 and not v52 then
		local lastToggledItem = p6.lastToggledItem

		if itemId ~= lastToggledItem.itemId or itemType ~= lastToggledItem.itemType or itemSubType ~= lastToggledItem.itemSubType then
			if itemId ~= nil then
				p5.props.toggleTryOn(p5.props.networking, p5.props.catalogAnalytics, itemType, itemSubType, itemId, true, p6.avatarRoute, nil)

				return
			end

			if p5.props.externalNavigationRequestParams ~= p6.externalNavigationRequestParams and DeepLinkUtils.wasItemFromDeepLinkEquipped(p6.externalNavigationRequestParams, p5.props.avatarRoute) then
				return
			end

			p5.props.onNavigatedToTryOnPage()

			return
		end

		if FFlagAXFixLookTryOnReturnRemoval and itemId == nil and p6.lookId ~= nil then
			p5.props.onNavigatedToTryOnPage()
		end
	end
end
function v30.didUpdate(p7, p8) -- line: 194
	-- upvalues: Constants (copy), AvatarScreenProperties (copy), FFlagAXMISEnableMultiShopping (copy), Cryo (copy), AvatarScreen (copy), AppPage (copy)
	if p7.props.selectedAnimationPreview and p7.props.lastToggledItem ~= p8.lastToggledItem then
		local lastToggledItem = p7.props.lastToggledItem

		if not not lastToggledItem.isUnequipped or if lastToggledItem.itemType ~= Constants.ItemType.Asset then lastToggledItem.itemSubType ~= Constants.BundleTypeIdStrings.Animations else Constants.AssetTypeIdToCategory[lastToggledItem.itemSubType] ~= Constants.AssetCategories.Animation then
			p7.props.clearAnimationPreview()
		end
	end

	local name = p7.props.avatarRoute.opaque.name
	local v59 = AvatarScreenProperties[name] and AvatarScreenProperties[name].isTryOnOutfitResetPage
	local name2 = p8.avatarRoute.opaque.name
	local v61 = AvatarScreenProperties[name2] and AvatarScreenProperties[name2].isMultiTryOn
	local v62 = AvatarScreenProperties[name2] and AvatarScreenProperties[name2].isRefinementPage

	if v59 and name ~= name2 and not v62 then
		if not FFlagAXMISEnableMultiShopping and v61 then
			p7.props.storeAndClearTryOns()
		else
			p7.props.onNavigatedToNonTryOnPage()
		end
	end

	local v63 = AvatarScreenProperties[name] and AvatarScreenProperties[name].isMultiTryOn

	if not FFlagAXMISEnableMultiShopping and v63 and not v61 and not AvatarScreenProperties[name].isRefinementPage and p7.props.lastSavedTriedOnOutfit and not Cryo.isEmpty(p7.props.lastSavedTriedOnOutfit) then
		p7.props.setOutfitTryOns(p7.props.lastSavedTriedOnOutfit)
	end

	local v64 = AvatarScreenProperties[name] and AvatarScreenProperties[name].isRefinementPage

	if name ~= name2 and name2 == AvatarScreen.Catalog and name ~= AppPage.ExperienceDetail and not v59 and not v64 then
		p7.props.clearAllResultsListFocusedWidget()
	end
end

local v36 = RoactRodux.connect(function(p9, p10) -- line: 260
	-- upvalues: t1 (copy), ItemData (copy), CatalogUtils (copy), FFlagAXFixLookTryOnReturnRemoval (copy)
	local current = p10.avatarRoute.current
	local itemId, itemType

	if t1[current.name] then
		itemId = current.params.itemId
		itemType = current.params.itemType
	else
		itemId = nil
		itemType = nil
	end

	local v70 = ItemData(p9.AvatarExperience.Common, itemId, itemType)
	local v71 = CatalogUtils.GetItemSubType(itemType, v70)
	local LastToggledItem = p9.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledItem
	local v73 = p9.AvatarExperience.ExternalNavigationRequest.params or {}

	return {
		itemSubType = v71,
		lastToggledItem = LastToggledItem,
		lastSavedTriedOnOutfit = p9.AvatarExperience.AvatarScene.LastSavedTriedOnOutfit,
		tryOnItems = p9.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems,
		lookId = if not FFlagAXFixLookTryOnReturnRemoval then nil else p9.AvatarExperience.AvatarScene.OutfitTryOn.LookId,
		selectedAnimationPreview = p9.AvatarExperience.AvatarScene.TryOn.AnimationPreview,
		externalNavigationRequestParams = v73
	}
end, function(p11) -- line: 280
	-- upvalues: StoreAndClearTryOns (copy), SetOutfitTryOns (copy), ClearAnimationPreview (copy), ClearAllResultsListFocusedWidgets (copy), NavigatedToNonTryOnPage (copy), NavigatedToTryOnPage (copy), ToggleTryOnThunk (copy)
	return {
		storeAndClearTryOns = function() -- line: 282
			-- upvalues: p11 (copy), StoreAndClearTryOns (copy)
			p11(StoreAndClearTryOns())
		end,
		setOutfitTryOns = function(p12) -- line: 286
			-- upvalues: p11 (copy), SetOutfitTryOns (copy)
			p11(SetOutfitTryOns(p12))
		end,
		clearAnimationPreview = function() -- line: 290
			-- upvalues: p11 (copy), ClearAnimationPreview (copy)
			p11(ClearAnimationPreview())
		end,
		clearAllResultsListFocusedWidget = function() -- line: 294
			-- upvalues: p11 (copy), ClearAllResultsListFocusedWidgets (copy)
			return p11(ClearAllResultsListFocusedWidgets())
		end,
		onNavigatedToNonTryOnPage = function() -- line: 298
			-- upvalues: p11 (copy), NavigatedToNonTryOnPage (copy)
			return p11(NavigatedToNonTryOnPage())
		end,
		onNavigatedToTryOnPage = function() -- line: 302
			-- upvalues: p11 (copy), NavigatedToTryOnPage (copy)
			return p11(NavigatedToTryOnPage())
		end,
		toggleTryOn = function(p13, p14, p15, p16, p17, p18, p19, p20) -- line: 306
			-- upvalues: p11 (copy), ToggleTryOnThunk (copy)
			p11(ToggleTryOnThunk(p13, p14, p15, p16, p17, p18, p19, p20))
		end
	}
end)(v30)

return (withAppRoute((RoactServices.connect({
	catalogAnalytics = Analytics,
	appAnalytics = RoactAnalytics,
	networking = RoactNetworking
})(v36))))
