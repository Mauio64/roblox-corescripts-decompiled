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
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local RemoveLookFromTryOn = require(Modules.AvatarExperience.Common.Actions.RemoveLookFromTryOn)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local TryOnLookV2 = require(Modules.AvatarExperience.Common.Thunks.TryOnLookV2)

require(Modules.AvatarExperience.Common.Types)

local function useTryOnLook(t1: {[any]: any}) -- line: 44
	-- upvalues: useNavigation (copy), useAvatarRoute (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), Analytics (copy), useAdaptiveScrolling (copy), React (copy), SetFullView (copy), FullView (copy), FFlagAXMISEnableMultiShopping (copy), AvatarScreen (copy), TryOnLookV2 (copy), PeekViewState (copy), RemoveLookFromTryOn (copy), SetTryOnManagerPeekViewState (copy), WidgetConstants (copy)
	local v23 = useNavigation()
	local v24 = useAvatarRoute()
	local v25 = useDispatch()
	local v26 = useRoactService(RoactNetworking)
	local v27 = useRoactService(Analytics)
	local v28 = useAdaptiveScrolling()
	local itemId = t1.itemId
	local itemType = t1.itemType
	local itemData = t1.itemData
	local isSelected = t1.isSelected
	local v33 = v24 and (v24.opaque and v24.opaque.name)
	local isOrganic = t1.isOrganic
	local widgetAnalyticsInfo = t1.widgetAnalyticsInfo
	local sendCatalogItemClickAnalytics = t1.sendCatalogItemClickAnalytics
	local textButtonRef = t1.textButtonRef

	return React.useCallback(function() -- line: 67
		-- upvalues: itemId (copy), itemType (copy), isSelected (copy), v28 (copy), textButtonRef (copy), v33 (copy), v25 (copy), SetFullView (copy), v27 (copy), FullView (copy), FFlagAXMISEnableMultiShopping (copy), AvatarScreen (copy), TryOnLookV2 (copy), v26 (copy), v23 (copy), widgetAnalyticsInfo (copy), PeekViewState (copy), RemoveLookFromTryOn (copy), SetTryOnManagerPeekViewState (copy), isOrganic (copy), sendCatalogItemClickAnalytics (copy), WidgetConstants (copy)
		if not itemId or not itemType then
			return
		end

		if not isSelected then
			if v28 then
				local v38 = if not textButtonRef then nil else textButtonRef.current

				if v38 ~= nil then
					v28.setSelectedItemInstance(v38)
				end
			end

			if v33 ~= nil then
				v25(SetFullView(v27, v33, FullView.None))
			end

			local n1 = 2

			if FFlagAXMISEnableMultiShopping and v33 ~= AvatarScreen.MySharedAvatars then
				n1 = 1
			end

			v25(TryOnLookV2(v26, v23, widgetAnalyticsInfo, itemId, if not FFlagAXMISEnableMultiShopping then nil else PeekViewState.SuperBrief, n1))
		else
			if v28 then
				v28.setSelectedItemInstance(nil)
			end

			if FFlagAXMISEnableMultiShopping then
				v25(RemoveLookFromTryOn(itemId))
			end

			v25(SetTryOnManagerPeekViewState(PeekViewState.Closed))
		end

		if isOrganic then
			if not isSelected and sendCatalogItemClickAnalytics then
				sendCatalogItemClickAnalytics()

				return
			end
		else
			v27.widgetInteractionV2(widgetAnalyticsInfo, if not isSelected then WidgetConstants.ActionType.ITEM_CLICK else WidgetConstants.ActionType.ITEM_DESELECTED)
		end
	end, {
		v25,
		itemId,
		itemData,
		v26,
		v27,
		itemType,
		v23,
		widgetAnalyticsInfo,
		v28,
		isSelected,
		v33,
		isOrganic,
		textButtonRef,
		sendCatalogItemClickAnalytics
	})
end

return useTryOnLook
