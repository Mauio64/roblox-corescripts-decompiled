local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local React = require(NotApprovedPageParent.React)
local Fragment = React.Fragment
local useCallback = React.useCallback
local UrlBuilder = require(NotApprovedPageParent.UrlBuilder).UrlBuilder
local Foundation = require(NotApprovedPageParent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext
local sendNotApprovedPageEvent = require(NotApprovedPage.Utils.sendNotApprovedPageEvent)
local useOpenLink = require(NotApprovedPage.Utils.useOpenLink)
local EVENT_TYPES = require(NotApprovedPageParent.NotApprovedPageShared).Constants.EVENT_TYPES
local FFlagNavigateToSafetyDashboardForAppeals = require(NotApprovedPageParent.SharedFlags).FFlagNavigateToSafetyDashboardForAppeals

require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils)

local function DeleteCta(_) -- line: 31
	-- upvalues: useNotApprovedPageContext (copy), useOpenLink (copy), FFlagNavigateToSafetyDashboardForAppeals (copy), UrlBuilder (copy), useCallback (copy), sendNotApprovedPageEvent (copy), EVENT_TYPES (copy), React (copy), Fragment (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local translations = useNotApprovedPageContext().translations
	local v19 = useOpenLink(if not FFlagNavigateToSafetyDashboardForAppeals then UrlBuilder.static.appealsPortal.main() else UrlBuilder.static.safetyDashboard.main(), if not FFlagNavigateToSafetyDashboardForAppeals then translations.appealsPortalTitle else translations.accountStatusTitle)
	local v20 = useCallback(function() -- line: 42
		-- upvalues: sendNotApprovedPageEvent (copy), EVENT_TYPES (copy), v19 (copy)
		sendNotApprovedPageEvent({
			eventType = EVENT_TYPES.AppealsPortalClicked
		})
		v19()
	end, { v19 })

	return React.createElement(Fragment, nil, {
		AppealButton = React.createElement(Button, {
			LayoutOrder = 1,
			text = translations.reportMistakeButton,
			onActivated = v20,
			variant = ButtonVariant.SoftEmphasis,
			size = InputSize.Medium,
			width = UDim.new(1, 0)
		})
	})
end

return React.memo(DeleteCta)
