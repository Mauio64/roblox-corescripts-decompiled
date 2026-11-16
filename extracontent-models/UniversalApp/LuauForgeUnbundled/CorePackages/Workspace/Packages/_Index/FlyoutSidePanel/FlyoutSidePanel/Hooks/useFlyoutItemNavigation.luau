local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/UniversalAppPolicy").useAppPolicy
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Navigation").useNavigation
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/NavigationRodux").Thunks.NavigateDown
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local fFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav
local fFlagFlyoutFilterWebViewsAndBrowserLinks = SharedFlags.FFlagFlyoutFilterWebViewsAndBrowserLinks
local FFlagFlyoutResolveItemContextOnActivation = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FFlagFlyoutResolveItemContextOnActivation")

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppNavigation").NavigationCommands else nil

local LinkingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/LinkingProtocol")
local deepLinkSource = LinkingProtocol.Enums.DeepLinkSource
local default = LinkingProtocol.LinkingProtocol.default
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppHooks").useRoactService
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactServiceTags").AppEventIngestService
local fFlagCreateConnectionsHub = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagCreateConnectionsHub

local FlyoutContentSettings = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Config/FlyoutContentSettings")
local FlyoutAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Analytics/FlyoutAnalytics")

local defineFastString = game:DefineFastString("FlyoutGiftCardSourceParam", "flyout-side-panel")

local function useFlyoutItemNavigation(data, callback, p2)
	local v5 = useDispatch()
	local v6 = if fFlagCreateConnectionsHub or fFlagEnableArgus then useNavigation() else nil
	local v7 = useSelector(function(p3)
		return p3.LocalUserId
	end)

	local v8 = useAppPolicy(function(p3)
		return p3.getGiftCardSourceRefOverride()
	end)

	local v9 = useAppPolicy(function(p3)
		return p3
	end)

	local v10 = useRoactService(appEventIngestService)
	local useCallback = React.useCallback
	local function fn()
		callback()
		local v11 = nil
		local v12 = if FFlagFlyoutResolveItemContextOnActivation and data.getContext then data.getContext() else data.context

		if v12 then
			if v12.url then
				v11 = v12.url
			elseif v12.appPage then
				local appPage2 = v12.appPage

				if fFlagCreateConnectionsHub and appPage2 == appPage.CoHubMyConnections then
					v6.navigate(appPage2)
				elseif
					fFlagEnableArgus
					and fFlagEnableArgusImmersiveNav
					and appPage2 == appPage.Moments
				then
					local v13 = {
						name = appPage.MomentsImmersive,
						source = "flyout_menu"
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v13))
					else
						v5(navigateDown(v13))
					end
				elseif appPage2 == appPage.Moments then
					v6.navigate(appPage2, { source = "flyout_menu" })
				else
					local v13 = { name = appPage2 }

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v13))
					else
						v5(navigateDown(v13))
					end
				end
			elseif v12.appUri then
				local appUri = v12.appUri
				default:isURLRegistered(appUri):andThen(function(p3)
					if p3 then
						if default:isInternalDlicEnabled() then
							default:detectDeeplinkIntent((default:createInternalDlic(
								appUri,
								deepLinkSource.LuaInternal
							)))
						else
							default:detectURL(appUri)
						end
					end
				end)
			elseif v12.urlGenerator then
				local urlGenerator = v12.urlGenerator

				if data.itemType == FlyoutContentSettings.ItemType.Inventory then
					v11 = urlGenerator(v7)
				elseif data.itemType == FlyoutContentSettings.ItemType.GiftCards then
					if v8 and v8 ~= "" then
						v11 = urlGenerator(v8 .. "-" .. defineFastString)
					end
				elseif data.itemType == FlyoutContentSettings.ItemType.CreateGames then
					v11 = urlGenerator(p2)
				elseif
					data.itemType == FlyoutContentSettings.ItemType.Terms
					or data.itemType == FlyoutContentSettings.ItemType.Privacy
				then
					v11 = urlGenerator(v7, v9)
				end
			end
		end

		if v11 then
			local v13 = fFlagFlyoutFilterWebViewsAndBrowserLinks

			if v13 then
				if v12 == nil or v12.destinationType ~= FlyoutContentSettings.DestinationType.WebLink then
					v13 = false
				else
					v13 = v9.shouldUseExternalBrowserForMorePageItem()
				end
			end

			if v13 then
				default:openURL(v11)
			else
				local v14 = {
					name = appPage.GenericWebPage,
					detail = v11,
					extraProps = { titleKey = data.textKey }
				}

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v14))
				else
					v5(navigateDown(v14))
				end
			end
		end

		FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(v10, data.itemType, v7, v11)
	end

	local v12 = if fFlagCreateConnectionsHub then v6.navigate else nil
	return useCallback(fn, {
		data,
		callback,
		v7,
		v8,
		v10,
		p2,
		v5,
		v9,
		v12
	})
end

return useFlyoutItemNavigation
