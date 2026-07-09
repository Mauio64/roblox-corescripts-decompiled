local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent

require(NotApprovedPage.Common.Types)

local EVENT_TYPES = require(NotApprovedPageParent.NotApprovedPageShared).Constants.EVENT_TYPES
local React = require(NotApprovedPageParent.React)
local useCallback = React.useCallback
local AppPage = require(NotApprovedPageParent.RobloxAppEnums).AppPage
local NavigateDown = require(NotApprovedPageParent.NavigationRodux).Thunks.NavigateDown
local UrlBuilder = require(NotApprovedPageParent.UrlBuilder).UrlBuilder
local FFlagSignalsNavP3Dispatch = require(NotApprovedPageParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v10 = if not FFlagSignalsNavP3Dispatch then nil else require(NotApprovedPageParent.RobloxAppNavigation).NavigationCommands
local Foundation = require(NotApprovedPageParent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local sendNotApprovedPageEvent = require(NotApprovedPage.Utils.sendNotApprovedPageEvent)
local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext
local useOpenLink = require(NotApprovedPage.Utils.useOpenLink)
local STATIC_PAGE_NAMES = require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils).STATIC_PAGE_NAMES
local FFlagNavigateToSafetyDashboardForAppeals = require(NotApprovedPageParent.SharedFlags).FFlagNavigateToSafetyDashboardForAppeals
local FFlagEnableNapNewWebView = require(NotApprovedPage.Flags.FFlagEnableNapNewWebView)

local function ReportMistake(p1) -- line: 46
	-- upvalues: useNotApprovedPageContext (copy), FFlagEnableNapNewWebView (copy), useOpenLink (copy), FFlagNavigateToSafetyDashboardForAppeals (copy), UrlBuilder (copy), useCallback (copy), sendNotApprovedPageEvent (copy), EVENT_TYPES (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateDown (copy), React (copy), View (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local translations = useNotApprovedPageContext().translations
	local dispatch = p1.dispatch
	local v27 = if not FFlagEnableNapNewWebView then nil else useOpenLink(if not FFlagNavigateToSafetyDashboardForAppeals then UrlBuilder.static.appealsPortal.main() else UrlBuilder.static.safetyDashboard.main(), if not FFlagNavigateToSafetyDashboardForAppeals then translations.appealsPortalTitle else translations.accountStatusTitle)
	local v28 = useCallback(function() -- line: 61
		-- upvalues: sendNotApprovedPageEvent (copy), EVENT_TYPES (copy), FFlagEnableNapNewWebView (copy), v27 (copy), AppPage (copy), FFlagNavigateToSafetyDashboardForAppeals (copy), UrlBuilder (copy), translations (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), dispatch (copy), NavigateDown (copy)
		sendNotApprovedPageEvent({
			eventType = EVENT_TYPES.AppealsPortalClicked
		})

		if FFlagEnableNapNewWebView and v27 then
			v27()

			return
		end

		local t1 = {
			name = AppPage.GenericWebPage,
			detail = if not FFlagNavigateToSafetyDashboardForAppeals then UrlBuilder.static.appealsPortal.main() else UrlBuilder.static.safetyDashboard.main(),
			extraProps = {
				title = if not FFlagNavigateToSafetyDashboardForAppeals then translations.appealsPortalTitle else translations.accountStatusTitle
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v10.down(v10.fromLegacyPage(t1))

			return
		end

		dispatch(NavigateDown(t1))
	end, {
		dispatch,
		v27,
		translations
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-medium",
		LayoutOrder = p1.layoutOrder
	}, {
		Content = React.createElement(FoundationText, {
			tag = "auto-xy text-body-large text-align-x-left text-wrap",
			LayoutOrder = 2,
			Text = translations.reportMistakeDescriptionV3
		}),
		ReportMistakeButton = React.createElement(Button, {
			LayoutOrder = 3,
			text = translations.sendAppealButton,
			onActivated = v28,
			variant = ButtonVariant.Standard,
			size = InputSize.Small,
			width = UDim.new(1, 0)
		})
	})
end

return {
	getIsVisible = function(_, _: number?, p3, p4) -- line: 107
		-- upvalues: STATIC_PAGE_NAMES (copy)
		local v33 = not not p4 and p4.educational_pass_eligible

		return (p3 or STATIC_PAGE_NAMES.Unknown) == STATIC_PAGE_NAMES.SecondChanceIntro or not v33
	end,
	renderComponent = React.memo(ReportMistake)
}
