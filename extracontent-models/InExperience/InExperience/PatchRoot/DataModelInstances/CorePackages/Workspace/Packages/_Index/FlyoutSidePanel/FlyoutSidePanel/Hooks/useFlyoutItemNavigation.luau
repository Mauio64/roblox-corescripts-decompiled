local FlyoutSidePanel = script:FindFirstAncestor("FlyoutSidePanel")
local parent = FlyoutSidePanel.Parent
local React = require(parent.React)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav
local FFlagFlyoutFilterWebViewsAndBrowserLinks = SharedFlags.FFlagFlyoutFilterWebViewsAndBrowserLinks
local FFlagFlyoutResolveItemContextOnActivation = require(FlyoutSidePanel.Flags.FFlagFlyoutResolveItemContextOnActivation)
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local LinkingProtocol = require(parent.LinkingProtocol)
local DeepLinkSource = LinkingProtocol.Enums.DeepLinkSource
local default = LinkingProtocol.LinkingProtocol.default
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local SharedFlags2 = require(parent.SharedFlags)
local FFlagCreateConnectionsHub = SharedFlags2.FFlagCreateConnectionsHub

local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)

local defineFastString = game:DefineFastString("FlyoutGiftCardSourceParam", "flyout-side-panel")

local function useFlyoutItemNavigation(data, callback, callback2)
	local v = useDispatch()
	local v2

	if FFlagCreateConnectionsHub or FFlagEnableArgus then
		v2 = useNavigation()
	else
		v2 = nil
	end

	local v3 = useSelector(function(p)
		return p.LocalUserId
	end)

	local v4 = useAppPolicy(function(p)
		return p.getGiftCardSourceRefOverride()
	end)

	local v5 = useAppPolicy(function(p)
		return p
	end)

	local v6 = useRoactService(AppEventIngestService)
	local useCallback = React.useCallback
	local function fn()
		callback()
		local detail = nil
		local v7

		if FFlagFlyoutResolveItemContextOnActivation and data.getContext then
			v7 = data.getContext()
		else
			v7 = data.context
		end

		if v7 then
			if v7.url then
				detail = v7.url
			elseif v7.appPage then
				local appPage = v7.appPage

				if FFlagCreateConnectionsHub and appPage == AppPage.CoHubMyConnections then
					v2.navigate(appPage)
				elseif FFlagEnableArgus and FFlagEnableArgusImmersiveNav and appPage == AppPage.Moments then
					local v8 = { name = AppPage.MomentsImmersive, source = "flyout_menu" }

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v8))
					else
						v(NavigateDown(v8))
					end
				elseif appPage == AppPage.Moments then
					v2.navigate(appPage, { source = "flyout_menu" })
				else
					local v8 = { name = appPage }

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v8))
					else
						v(NavigateDown(v8))
					end
				end
			elseif v7.appUri then
				local appUri = v7.appUri
				default:isURLRegistered(appUri):andThen(function(p)
					if p then
						if default:isInternalDlicEnabled() then
							default:detectDeeplinkIntent((default:createInternalDlic(appUri, DeepLinkSource.LuaInternal)))
						else
							default:detectURL(appUri)
						end
					end
				end)
			elseif v7.urlGenerator then
				local urlGenerator = v7.urlGenerator

				if data.itemType == FlyoutContentSettings.ItemType.Inventory then
					detail = urlGenerator(v3)
				elseif data.itemType == FlyoutContentSettings.ItemType.GiftCards then
					if v4 and v4 ~= "" then
						detail = urlGenerator(v4 .. "-" .. defineFastString)
					end
				elseif data.itemType == FlyoutContentSettings.ItemType.CreateGames then
					detail = urlGenerator(callback2)
				elseif
					data.itemType == FlyoutContentSettings.ItemType.Terms
					or data.itemType == FlyoutContentSettings.ItemType.Privacy
				then
					detail = urlGenerator(v3, v5)
				end
			end
		end

		if detail then
			local v8 = FFlagFlyoutFilterWebViewsAndBrowserLinks

			if v8 then
				if v7 == nil or v7.destinationType ~= FlyoutContentSettings.DestinationType.WebLink then
					v8 = false
				else
					v8 = v5.shouldUseExternalBrowserForMorePageItem()
				end
			end

			if v8 then
				default:openURL(detail)
			else
				local v9 = {
					name = AppPage.GenericWebPage,
					detail = detail,
					extraProps = { titleKey = data.textKey }
				}

				if FFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v9))
				else
					v(NavigateDown(v9))
				end
			end
		end

		FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(v6, data.itemType, v3, detail)
	end

	local v7

	if FFlagCreateConnectionsHub then
		v7 = v2.navigate
	end

	return useCallback(fn, {
		data,
		callback,
		v3,
		v4,
		v6,
		callback2,
		v,
		v5,
		v7
	})
end

return useFlyoutItemNavigation
