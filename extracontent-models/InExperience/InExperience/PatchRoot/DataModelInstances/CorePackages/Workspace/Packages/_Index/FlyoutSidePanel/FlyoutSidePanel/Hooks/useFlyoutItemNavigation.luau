local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local useAppPolicy = require(Parent.UniversalAppPolicy).useAppPolicy
local RoactUtils = require(Parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useNavigation = require(Parent.Navigation).useNavigation
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local SharedFlags = require(Parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagEnableArgusFlyoutEntry = SharedFlags.FFlagEnableArgusFlyoutEntry
local FFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav
local v15 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local default = require(Parent.LinkingProtocol).LinkingProtocol.default
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local AppEventIngestService = require(Parent.RoactServiceTags).AppEventIngestService
local FFlagCreateConnectionsHub = require(Parent.SharedFlags).FFlagCreateConnectionsHub
local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local v22 = game:DefineFastString("FlyoutGiftCardSourceParam", "flyout-side-panel")

local function useFlyoutItemNavigation(p1, p2: ((...any) -> ...any), p3: ((...any) -> ...any)?) -- line: 31
	-- upvalues: useDispatch (copy), FFlagCreateConnectionsHub (copy), FFlagEnableArgus (copy), useNavigation (copy), useSelector (copy), useAppPolicy (copy), useRoactService (copy), AppEventIngestService (copy), React (copy), AppPage (copy), FFlagEnableArgusFlyoutEntry (copy), FFlagEnableArgusImmersiveNav (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), NavigateDown (copy), default (copy), FlyoutContentSettings (copy), v22 (copy), FlyoutAnalytics (copy)
	local v27 = useDispatch()
	local v28 = if not FFlagCreateConnectionsHub and not FFlagEnableArgus then nil else useNavigation()
	local v29 = useSelector(function(p4) -- line: 38
		return p4.LocalUserId
	end)
	local v30 = useAppPolicy(function(p5) -- line: 41
		return p5.getGiftCardSourceRefOverride()
	end)
	local v31 = useAppPolicy(function(p6) -- line: 44
		return p6
	end)
	local v32 = useRoactService(AppEventIngestService)

	return React.useCallback(function() -- line: 50
		-- upvalues: p2 (copy), p1 (copy), FFlagCreateConnectionsHub (copy), AppPage (copy), v28 (copy), FFlagEnableArgus (copy), FFlagEnableArgusFlyoutEntry (copy), FFlagEnableArgusImmersiveNav (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), v27 (copy), NavigateDown (copy), default (copy), FlyoutContentSettings (copy), v29 (copy), v30 (copy), v22 (copy), p3 (copy), v31 (copy), FlyoutAnalytics (copy), v32 (copy)
		p2()

		local url = nil

		if p1.context then
			if p1.context.url then
				url = p1.context.url
			elseif p1.context.appPage then
				local appPage = p1.context.appPage

				if FFlagCreateConnectionsHub and appPage == AppPage.CoHubMyConnections then
					v28.navigate(appPage)
				elseif FFlagEnableArgus and FFlagEnableArgusFlyoutEntry and FFlagEnableArgusImmersiveNav and appPage == AppPage.Moments then
					local t1 = {
						source = "flyout_menu",
						name = AppPage.MomentsImmersive
					}

					if FFlagSignalsNavP3Dispatch then
						v15.down(v15.fromLegacyPage(t1))
					else
						v27(NavigateDown(t1))
					end
				elseif appPage == AppPage.Moments then
					v28.navigate(appPage, {
						source = "flyout_menu"
					})
				else
					local t2 = {
						name = appPage
					}

					if FFlagSignalsNavP3Dispatch then
						v15.down(v15.fromLegacyPage(t2))
					else
						v27(NavigateDown(t2))
					end
				end
			elseif p1.context.appUri then
				local appUri = p1.context.appUri

				default:isURLRegistered(appUri):andThen(function(p7) -- line: 95
					-- upvalues: default (copy), appUri (copy)
					if p7 then
						default:detectURL(appUri)
					end
				end)
			elseif p1.context.urlGenerator then
				local urlGenerator = p1.context.urlGenerator

				if p1.itemType == FlyoutContentSettings.ItemType.Inventory then
					url = urlGenerator(v29)
				elseif p1.itemType == FlyoutContentSettings.ItemType.GiftCards then
					if v30 and v30 ~= "" then
						url = urlGenerator(v30 .. "-" .. v22)
					end
				elseif p1.itemType == FlyoutContentSettings.ItemType.CreateGames then
					url = urlGenerator(p3)
				elseif p1.itemType == FlyoutContentSettings.ItemType.Terms or p1.itemType == FlyoutContentSettings.ItemType.Privacy then
					url = urlGenerator(v29, v31)
				end
			end
		end

		if url then
			local t3 = {
				name = AppPage.GenericWebPage,
				detail = url,
				extraProps = {
					titleKey = p1.textKey
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v15.down(v15.fromLegacyPage(t3))
			else
				v27(NavigateDown(t3))
			end
		end

		FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(v32, p1.itemType, v29, url)
	end, {
		p1,
		p2,
		v29,
		v30,
		v32,
		p3,
		v27,
		v31,
		if not FFlagCreateConnectionsHub then nil else v28.navigate
	})
end

return useFlyoutItemNavigation
