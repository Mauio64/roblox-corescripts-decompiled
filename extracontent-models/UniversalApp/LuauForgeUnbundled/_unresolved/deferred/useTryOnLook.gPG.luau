local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local useAdaptiveScrolling = AvatarExperienceCommon.Hooks.useAdaptiveScrolling
local fullView = AvatarExperienceCommon.Enums.FullView

local widgetConstants = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").WidgetConstants
local peekViewState = require("@luauforge/bundled/dzD").PeekViewState
local module2 = require("@luauforge/bundled/dHL")
local removeLookFromTryOn = module2.Actions.RemoveLookFromTryOn
local setTryOnManagerPeekViewState = module2.Actions.SetTryOnManagerPeekViewState
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module3 = require("@luauforge/bundled/fvF")
local module4 = require("@luauforge/bundled/gnZ")
local module5 = require("@luauforge/deferred/goJ")
require("@luauforge/bundled/dMc")

local function useTryOnLook(data)
	local v5 = useNavigation()
	local v6 = useAvatarRoute()
	local v7 = useDispatch()
	local v8 = useRoactService(roactNetworking)
	local v9 = useRoactService(module3)
	local v10 = useAdaptiveScrolling()

	local itemId = data.itemId
	local itemType = data.itemType
	local itemData = data.itemData
	local isSelected = data.isSelected
	local name = v6 and v6.opaque and v6.opaque.name

	local isOrganic = data.isOrganic
	local widgetAnalyticsInfo = data.widgetAnalyticsInfo
	local sendCatalogItemClickAnalytics = data.sendCatalogItemClickAnalytics

	local textButtonRef = data.textButtonRef

	return React.useCallback(function()
		if not (itemId and itemType) then
			return
		end

		if isSelected then
			if v10 then
				v10.setSelectedItemInstance(nil)
			end

			v7(removeLookFromTryOn(itemId))
			v7(setTryOnManagerPeekViewState(peekViewState.Closed))
		else
			if v10 then
				local current = if textButtonRef then textButtonRef.current else nil

				if current ~= nil then
					v10.setSelectedItemInstance(current)
				end
			end

			if name ~= nil then
				v7(module4(v9, name, fullView.None))
			end

			local v11 = name == avatarScreen.MySharedAvatars and 2 or 1

			v7(module5(v8, v5, widgetAnalyticsInfo, itemId, peekViewState.SuperBrief, v11))
		end

		if isOrganic then
			if not isSelected and sendCatalogItemClickAnalytics then
				sendCatalogItemClickAnalytics()
			end
		else
			local widgetInteractionV2 = v9.widgetInteractionV2

			local v12 = if isSelected then widgetConstants.ActionType.ITEM_DESELECTED else widgetConstants.ActionType.ITEM_CLICK
			widgetInteractionV2(widgetAnalyticsInfo, v12)
		end
	end, {
		v7,
		itemId,
		itemData,
		v8,
		v9,
		itemType,
		v5,
		widgetAnalyticsInfo,
		v10,
		isSelected,
		name,
		isOrganic,
		textButtonRef,
		sendCatalogItemClickAnalytics
	})
end

return useTryOnLook
