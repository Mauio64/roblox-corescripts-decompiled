local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useAvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.Hooks.useAvatarRoute
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local useAdaptiveScrolling = AvatarExperienceCommon.Hooks.useAdaptiveScrolling
local FullView = AvatarExperienceCommon.Enums.FullView
local WidgetConstants = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).WidgetConstants
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local FFlagAXMISEnableMultiShopping = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMISEnableMultiShopping
local SetTryOnManagerPeekViewState = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.SetTryOnManagerPeekViewState
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local SetAnimationPreview = require(Modules.AvatarExperience.Common.Actions.SetAnimationPreview)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local ToggleTryOnThunk = require(Modules.AvatarExperience.Common.Thunks.ToggleTryOnThunk)
local CloseAllItemDetails = require(Modules.AvatarExperience.Common.Thunks.CloseAllItemDetails)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)

require(Modules.AvatarExperience.Common.Types)

local t1 = {
	toastMessage = "Feature.Avatar.Label.LayeredClothingR15Warning",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

local function useTryOnAssetOrBundle(t2: {[any]: any}) -- line: 59
	-- upvalues: useNavigation (copy), useAvatarRoute (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), Analytics (copy), Analytics2 (copy), useAdaptiveScrolling (copy), React (copy), CatalogUtils (copy), FFlagAXMISEnableMultiShopping (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), ToggleTryOnThunk (copy), FullView (copy), SetFullView (copy), Constants (copy), SetCurrentToastMessage (copy), t1 (copy), SetAnimationPreview (copy), WidgetConstants (copy), WebApi (copy), CloseAllItemDetails (copy)
	local v30 = useNavigation()
	local v31 = useAvatarRoute()
	local v32 = useDispatch()
	local v33 = useRoactService(RoactNetworking)
	local v34 = useRoactService(Analytics)
	local v35 = useRoactService(Analytics2)
	local v36 = useAdaptiveScrolling()
	local itemId = t2.itemId
	local itemType = t2.itemType
	local itemData = t2.itemData
	local isSelected = t2.isSelected
	local fullView = t2.fullView
	local isAvatarR6 = t2.isAvatarR6
	local isItemDetailsViewStateFull = t2.isItemDetailsViewStateFull
	local maybePromptForR15Upgrade = t2.maybePromptForR15Upgrade
	local widgetAnalyticsInfo = t2.widgetAnalyticsInfo
	local adTrackingData = t2.adTrackingData
	local sendCatalogItemClickAnalytics = t2.sendCatalogItemClickAnalytics
	local textButtonRef = t2.textButtonRef

	return React.useCallback(function() -- line: 86
		-- upvalues: itemId (copy), itemType (copy), maybePromptForR15Upgrade (copy), CatalogUtils (copy), itemData (copy), isSelected (copy), FFlagAXMISEnableMultiShopping (copy), v32 (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), ToggleTryOnThunk (copy), v33 (copy), v35 (copy), v31 (copy), v30 (copy), widgetAnalyticsInfo (copy), v36 (copy), textButtonRef (copy), fullView (copy), FullView (copy), SetFullView (copy), v34 (copy), isAvatarR6 (copy), Constants (copy), SetCurrentToastMessage (copy), t1 (copy), SetAnimationPreview (copy), sendCatalogItemClickAnalytics (copy), WidgetConstants (copy), adTrackingData (copy), WebApi (copy), isItemDetailsViewStateFull (copy), CloseAllItemDetails (copy)
		if not itemId or not itemType then
			return
		end

		if maybePromptForR15Upgrade() then
			return
		end

		local v49 = CatalogUtils.GetItemSubType(itemType, itemData)
		local v50 = isSelected

		if FFlagAXMISEnableMultiShopping then
			v32(SetTryOnManagerPeekViewState(PeekViewState.Closed))
		end

		v32(ToggleTryOnThunk(v33, v35, itemType, v49, itemId, true, v31, v30, widgetAnalyticsInfo, nil, not FFlagAXMISEnableMultiShopping and nil))

		if not FFlagAXMISEnableMultiShopping and v36 then
			v32(SetTryOnManagerPeekViewState(PeekViewState.Closed))
		end

		if v36 and v50 then
			v36.setSelectedItemInstance()
		end

		if not v50 then
			if v36 then
				v36.setSelectedItemInstance(textButtonRef.current)
			end

			if isSelected then
				return
			end

			if fullView[v31.opaque.name] == FullView.UIFullView then
				v32(SetFullView(v34, v31.opaque.name, FullView.None))
			end
		end

		if isSelected then
			return
		end

		local v51 = itemData and itemData.assetType

		if isAvatarR6 and v51 ~= Constants.AssetTypeIdStrings.HairAccessory and Constants.LayeredAssetTypes[v51] ~= nil then
			v32(SetCurrentToastMessage(t1))
		end

		if itemType == Constants.ItemType.Asset and Constants.AssetTypeIdToCategory[v49] == Constants.AssetCategories.Animation then
			v32(SetAnimationPreview(itemId, v51))
		end

		if sendCatalogItemClickAnalytics then
			sendCatalogItemClickAnalytics()
		end

		if widgetAnalyticsInfo then
			v35.widgetInteractionV2(widgetAnalyticsInfo, WidgetConstants.ActionType.ITEM_CLICK)
		end

		if adTrackingData then
			WebApi.TrackSponsoredItemClick(v33, adTrackingData)
		end

		if isItemDetailsViewStateFull then
			v32(CloseAllItemDetails(v30))
		end
	end, {
		v32,
		itemId,
		maybePromptForR15Upgrade,
		itemData,
		v33,
		v35,
		itemType,
		v31,
		v30,
		widgetAnalyticsInfo,
		v36,
		fullView,
		isAvatarR6,
		isItemDetailsViewStateFull,
		v34,
		adTrackingData,
		isSelected,
		sendCatalogItemClickAnalytics
	})
end

return useTryOnAssetOrBundle
