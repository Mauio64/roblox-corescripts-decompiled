local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local sendNotApprovedPageEvent = require(NotApprovedPage.Utils.sendNotApprovedPageEvent)
local EVENT_TYPES = require(NotApprovedPageParent.NotApprovedPageShared).Constants.EVENT_TYPES
local React = require(NotApprovedPageParent.React)
local useCallback = React.useCallback
local AppPage = require(NotApprovedPageParent.RobloxAppEnums).AppPage
local NavigateDown = require(NotApprovedPageParent.NavigationRodux).Thunks.NavigateDown
local UrlBuilder = require(NotApprovedPageParent.UrlBuilder).UrlBuilder
local FFlagSignalsNavP3Dispatch = require(NotApprovedPageParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v11 = if not FFlagSignalsNavP3Dispatch then nil else require(NotApprovedPageParent.RobloxAppNavigation).NavigationCommands
local Foundation = require(NotApprovedPageParent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local renderPageItemsFromList = require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils).renderPageItemsFromList
local ViolationEvidenceConfig = require(NotApprovedPage.Components.pageItemConfigs.configs.ViolationEvidenceConfig)
local BadUtterancesConfig = require(NotApprovedPage.Components.pageItemConfigs.configs.BadUtterancesConfig)
local SimpleModeratorNoteConfig = require(NotApprovedPage.Components.pageItemConfigs.configs.SimpleModeratorNoteConfig)
local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext
local useOpenLink = require(NotApprovedPage.Utils.useOpenLink)
local FFlagNavigateToSafetyDashboardForAppeals = require(NotApprovedPageParent.SharedFlags).FFlagNavigateToSafetyDashboardForAppeals
local FFlagEnableNapNewWebView = require(NotApprovedPage.Flags.FFlagEnableNapNewWebView)
local t1 = {
	ViolationEvidenceConfig,
	BadUtterancesConfig,
	SimpleModeratorNoteConfig
}

local function RecentActivity(p1) -- line: 62
	-- upvalues: useNotApprovedPageContext (copy), FFlagEnableNapNewWebView (copy), useOpenLink (copy), FFlagNavigateToSafetyDashboardForAppeals (copy), UrlBuilder (copy), renderPageItemsFromList (copy), t1 (copy), useCallback (copy), sendNotApprovedPageEvent (copy), EVENT_TYPES (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), NavigateDown (copy), React (copy), View (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local translations = useNotApprovedPageContext().translations
	local v30 = if not FFlagEnableNapNewWebView then nil else useOpenLink(if not FFlagNavigateToSafetyDashboardForAppeals then UrlBuilder.static.appealsPortal.main() else UrlBuilder.static.safetyDashboard.main(), if not FFlagNavigateToSafetyDashboardForAppeals then translations.appealsPortalTitle else translations.accountStatusTitle)
	local interventionId = p1.moderationDetail.interventionId
	local consequenceTransparencyMessage = p1.moderationDetail.consequenceTransparencyMessage
	local dispatch = p1.dispatch
	local v34 = renderPageItemsFromList(t1, p1.moderationDetail, p1.dispatch)
	local v35 = useCallback(function() -- line: 83
		-- upvalues: sendNotApprovedPageEvent (copy), EVENT_TYPES (copy), FFlagEnableNapNewWebView (copy), v30 (copy), AppPage (copy), FFlagNavigateToSafetyDashboardForAppeals (copy), UrlBuilder (copy), translations (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), dispatch (copy), NavigateDown (copy)
		sendNotApprovedPageEvent({
			eventType = EVENT_TYPES.AppealsPortalClicked
		})

		if FFlagEnableNapNewWebView and v30 then
			v30()

			return
		end

		local t2 = {
			name = AppPage.GenericWebPage,
			detail = if not FFlagNavigateToSafetyDashboardForAppeals then UrlBuilder.static.appealsPortal.main() else UrlBuilder.static.safetyDashboard.main(),
			extraProps = {
				title = if not FFlagNavigateToSafetyDashboardForAppeals then translations.appealsPortalTitle else translations.accountStatusTitle
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v11.down(v11.fromLegacyPage(t2))

			return
		end

		dispatch(NavigateDown(t2))
	end, {
		dispatch,
		v30,
		translations
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-medium",
		LayoutOrder = p1.layoutOrder
	}, {
		Heading = React.createElement(FoundationText, {
			tag = "auto-xy text-title-large text-align-x-left content-emphasis text-wrap",
			LayoutOrder = 1,
			Text = translations.latestActivityLabel
		}),
		Content = React.createElement(View, {
			tag = "size-full-0 auto-y col gap-xsmall",
			LayoutOrder = 2
		}, {
			EvidenceCard = React.createElement(View, {
				tag = "size-full-0 auto-y col bg-shift-100 radius-medium padding-large gap-small",
				LayoutOrder = 1
			}, {
				Evidence = React.createElement(View, {
					tag = "size-full-0 auto-y col",
					LayoutOrder = 1
				}, unpack(v34)),
				DecisionMethod = consequenceTransparencyMessage ~= "" and React.createElement(FoundationText, {
					tag = "auto-xy text-body-medium text-align-x-left text-wrap",
					RichText = true,
					LayoutOrder = 2,
					Text = `<b>{ translations.decisionMethodLabel }:</b>\n{ consequenceTransparencyMessage }`
				}),
				ViewActivityButton = React.createElement(Button, {
					LayoutOrder = 3,
					text = translations.viewMoreButton,
					onActivated = v35,
					variant = ButtonVariant.Standard,
					size = InputSize.Small,
					width = UDim.new(1, 0)
				})
			}),
			InterventionId = React.createElement(FoundationText, {
				tag = "auto-xy text-caption-medium text-align-x-left text-wrap content-muted",
				LayoutOrder = 2,
				Text = interventionId
			})
		})
	})
end

return {
	getIsVisible = function() -- line: 162
		return true
	end,
	renderComponent = React.memo(RecentActivity)
}
