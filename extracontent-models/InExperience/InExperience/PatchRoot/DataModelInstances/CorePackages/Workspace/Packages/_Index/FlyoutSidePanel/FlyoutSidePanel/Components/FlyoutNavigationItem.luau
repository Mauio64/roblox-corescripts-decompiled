local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local useAppPolicy = require(Parent.UniversalAppPolicy).useAppPolicy
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local RoactUtils = require(Parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = require(Parent.Navigation).useNavigation
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v11 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local default = require(Parent.LinkingProtocol).LinkingProtocol.default
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)
local PrimaryNavigationItem = require(script.Parent.PrimaryNavigationItem)
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local AppEventIngestService = require(Parent.RoactServiceTags).AppEventIngestService
local SharedFlags = require(Parent.SharedFlags)
local FFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagEnableArgusFlyoutEntry = SharedFlags.FFlagEnableArgusFlyoutEntry
local FFlagArgusTabImpliesFlyout = SharedFlags.FFlagArgusTabImpliesFlyout
local FFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav
local FFlagFlyoutTermsPrivacyFooter = require(script.Parent.Parent.Flags.FFlagFlyoutTermsPrivacyFooter)
local v26 = if not FFlagFlyoutTermsPrivacyFooter then nil else require(script.Parent.Parent.Hooks.useFlyoutItemNavigation)
local v27 = game:DefineFastString("FlyoutGiftCardSourceParam", "flyout-side-panel")

local function FlyoutNavigationItem(p1) -- line: 45
	-- upvalues: FFlagFlyoutTermsPrivacyFooter (copy), v26 (copy), useDispatch (copy), FFlagCreateConnectionsHub (copy), FFlagEnableArgusFlyoutEntry (copy), FFlagArgusTabImpliesFlyout (copy), useNavigation (copy), useSelector (copy), useAppPolicy (copy), useRoactService (copy), AppEventIngestService (copy), React (copy), AppPage (copy), FFlagEnableArgus (copy), FFlagEnableArgusImmersiveNav (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), NavigateDown (copy), default (copy), FlyoutContentSettings (copy), v27 (copy), FlyoutAnalytics (copy), useLocalization (copy), PrimaryNavigationItem (copy)
	local v30

	if FFlagFlyoutTermsPrivacyFooter then
		v30 = v26(p1.item, p1.closeDrawer, p1.buildCreatorWebNavUrl)
	else
		local v31 = useDispatch()
		local v32 = if not FFlagCreateConnectionsHub and (not FFlagEnableArgusFlyoutEntry and not FFlagArgusTabImpliesFlyout) then nil else useNavigation()
		local v33 = useSelector(function(p2) -- line: 56
			return p2.LocalUserId
		end)
		local v34 = useAppPolicy(function(p3) -- line: 59
			return p3.getGiftCardSourceRefOverride()
		end)
		local v35 = useRoactService(AppEventIngestService)

		v30 = React.useCallback(function() -- line: 65
			-- upvalues: p1 (copy), FFlagCreateConnectionsHub (copy), AppPage (copy), v32 (copy), FFlagEnableArgus (copy), FFlagEnableArgusFlyoutEntry (copy), FFlagArgusTabImpliesFlyout (copy), FFlagEnableArgusImmersiveNav (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), v31 (copy), NavigateDown (copy), default (copy), FlyoutContentSettings (copy), v33 (copy), v34 (copy), v27 (copy), FlyoutAnalytics (copy), v35 (copy)
			p1.closeDrawer()

			local url = nil

			if p1.item.context then
				if p1.item.context.url then
					url = p1.item.context.url
				elseif p1.item.context.appPage then
					local appPage = p1.item.context.appPage

					if FFlagCreateConnectionsHub and appPage == AppPage.CoHubMyConnections then
						v32.navigate(appPage)
					elseif FFlagEnableArgus and ((FFlagEnableArgusFlyoutEntry or FFlagArgusTabImpliesFlyout) and FFlagEnableArgusImmersiveNav and appPage == AppPage.Moments) then
						local t1 = {
							source = "flyout_menu",
							name = AppPage.MomentsImmersive
						}

						if FFlagSignalsNavP3Dispatch then
							v11.down(v11.fromLegacyPage(t1))
						else
							v31(NavigateDown(t1))
						end
					elseif (FFlagEnableArgusFlyoutEntry or FFlagArgusTabImpliesFlyout) and appPage == AppPage.Moments then
						v32.navigate(appPage, {
							source = "flyout_menu"
						})
					else
						local t2 = {
							name = appPage
						}

						if FFlagSignalsNavP3Dispatch then
							v11.down(v11.fromLegacyPage(t2))
						else
							v31(NavigateDown(t2))
						end
					end
				elseif p1.item.context.appUri then
					local appUri = p1.item.context.appUri

					default:isURLRegistered(appUri):andThen(function(p4) -- line: 110
						-- upvalues: default (copy), appUri (copy)
						if p4 then
							default:detectURL(appUri)
						end
					end)
				elseif p1.item.context.urlGenerator then
					local urlGenerator = p1.item.context.urlGenerator

					if p1.item.itemType == FlyoutContentSettings.ItemType.Inventory then
						url = urlGenerator(v33)
					elseif p1.item.itemType == FlyoutContentSettings.ItemType.GiftCards then
						if v34 and v34 ~= "" then
							url = urlGenerator(v34 .. "-" .. v27)
						end
					elseif p1.item.itemType == FlyoutContentSettings.ItemType.CreateGames then
						url = urlGenerator(p1.buildCreatorWebNavUrl)
					end
				end
			end

			if url then
				local t3 = {
					name = AppPage.GenericWebPage,
					detail = url,
					extraProps = {
						titleKey = p1.item.textKey
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v11.down(v11.fromLegacyPage(t3))
				else
					v31(NavigateDown(t3))
				end
			end

			FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(v35, p1.item.itemType, v33, url)
		end, {
			p1.item,
			p1.closeDrawer,
			v33,
			v34,
			v35,
			p1.buildCreatorWebNavUrl,
			v31,
			if not FFlagCreateConnectionsHub then nil else v32.navigate
		})
	end

	local v36 = useLocalization({
		text = p1.item.textKey
	})

	return React.createElement(PrimaryNavigationItem, {
		layoutOrder = p1.layoutOrder,
		onActivated = v30,
		icon = p1.item.icon,
		text = v36.text,
		notificationCount = p1.item.notificationCount
	})
end

return FlyoutNavigationItem
