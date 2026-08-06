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
local FFlagFixMomentsExperienceFallback = SharedFlags.FFlagFixMomentsExperienceFallback
local FFlagFlyoutTermsPrivacyFooter = require(script.Parent.Parent.Flags.FFlagFlyoutTermsPrivacyFooter)
local v27 = if not FFlagFlyoutTermsPrivacyFooter then nil else require(script.Parent.Parent.Hooks.useFlyoutItemNavigation)
local v28 = game:DefineFastString("FlyoutGiftCardSourceParam", "flyout-side-panel")

local function FlyoutNavigationItem(p1) -- line: 46
	-- upvalues: FFlagFlyoutTermsPrivacyFooter (copy), v27 (copy), useDispatch (copy), FFlagCreateConnectionsHub (copy), FFlagEnableArgusFlyoutEntry (copy), FFlagArgusTabImpliesFlyout (copy), FFlagFixMomentsExperienceFallback (copy), useNavigation (copy), useSelector (copy), useAppPolicy (copy), useRoactService (copy), AppEventIngestService (copy), React (copy), AppPage (copy), FFlagEnableArgus (copy), FFlagEnableArgusImmersiveNav (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), NavigateDown (copy), default (copy), FlyoutContentSettings (copy), v28 (copy), FlyoutAnalytics (copy), useLocalization (copy), PrimaryNavigationItem (copy)
	local v31

	if FFlagFlyoutTermsPrivacyFooter then
		v31 = v27(p1.item, p1.closeDrawer, p1.buildCreatorWebNavUrl)
	else
		local v32 = useDispatch()
		local v33 = if not FFlagCreateConnectionsHub and (not FFlagEnableArgusFlyoutEntry and (not FFlagArgusTabImpliesFlyout and not FFlagFixMomentsExperienceFallback)) then nil else useNavigation()
		local v34 = useSelector(function(p2) -- line: 58
			return p2.LocalUserId
		end)
		local v35 = useAppPolicy(function(p3) -- line: 61
			return p3.getGiftCardSourceRefOverride()
		end)
		local v36 = useRoactService(AppEventIngestService)

		v31 = React.useCallback(function() -- line: 67
			-- upvalues: p1 (copy), FFlagCreateConnectionsHub (copy), AppPage (copy), v33 (copy), FFlagEnableArgus (copy), FFlagEnableArgusFlyoutEntry (copy), FFlagArgusTabImpliesFlyout (copy), FFlagEnableArgusImmersiveNav (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), v32 (copy), NavigateDown (copy), FFlagFixMomentsExperienceFallback (copy), default (copy), FlyoutContentSettings (copy), v34 (copy), v35 (copy), v28 (copy), FlyoutAnalytics (copy), v36 (copy)
			p1.closeDrawer()

			local url = nil

			if p1.item.context then
				if p1.item.context.url then
					url = p1.item.context.url
				elseif p1.item.context.appPage then
					local appPage = p1.item.context.appPage

					if FFlagCreateConnectionsHub and appPage == AppPage.CoHubMyConnections then
						v33.navigate(appPage)
					elseif FFlagEnableArgus and ((FFlagEnableArgusFlyoutEntry or FFlagArgusTabImpliesFlyout) and FFlagEnableArgusImmersiveNav and appPage == AppPage.Moments) then
						local t1 = {
							source = "flyout_menu",
							name = AppPage.MomentsImmersive
						}

						if FFlagSignalsNavP3Dispatch then
							v11.down(v11.fromLegacyPage(t1))
						else
							v32(NavigateDown(t1))
						end
					elseif FFlagFixMomentsExperienceFallback and appPage == AppPage.Moments then
						v33.navigate(appPage, {
							source = "flyout_menu"
						})
					elseif (FFlagEnableArgusFlyoutEntry or FFlagArgusTabImpliesFlyout) and appPage == AppPage.Moments then
						v33.navigate(appPage, {
							source = "flyout_menu"
						})
					else
						local t2 = {
							name = appPage
						}

						if FFlagSignalsNavP3Dispatch then
							v11.down(v11.fromLegacyPage(t2))
						else
							v32(NavigateDown(t2))
						end
					end
				elseif p1.item.context.appUri then
					local appUri = p1.item.context.appUri

					default:isURLRegistered(appUri):andThen(function(p4) -- line: 116
						-- upvalues: default (copy), appUri (copy)
						if p4 then
							default:detectURL(appUri)
						end
					end)
				elseif p1.item.context.urlGenerator then
					local urlGenerator = p1.item.context.urlGenerator

					if p1.item.itemType == FlyoutContentSettings.ItemType.Inventory then
						url = urlGenerator(v34)
					elseif p1.item.itemType == FlyoutContentSettings.ItemType.GiftCards then
						if v35 and v35 ~= "" then
							url = urlGenerator(v35 .. "-" .. v28)
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
					v32(NavigateDown(t3))
				end
			end

			FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(v36, p1.item.itemType, v34, url)
		end, {
			p1.item,
			p1.closeDrawer,
			v34,
			v35,
			v36,
			p1.buildCreatorWebNavUrl,
			v32,
			if not FFlagCreateConnectionsHub then nil else v33.navigate
		})
	end

	local v37 = useLocalization({
		text = p1.item.textKey
	})

	return React.createElement(PrimaryNavigationItem, {
		layoutOrder = p1.layoutOrder,
		onActivated = v31,
		icon = p1.item.icon,
		text = v37.text,
		notificationCount = p1.item.notificationCount
	})
end

return FlyoutNavigationItem
