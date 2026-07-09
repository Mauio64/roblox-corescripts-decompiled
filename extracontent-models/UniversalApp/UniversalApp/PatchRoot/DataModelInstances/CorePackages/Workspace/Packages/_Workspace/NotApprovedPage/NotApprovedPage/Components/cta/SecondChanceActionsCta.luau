local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local GuiService = game:GetService("GuiService")
local NotApprovedPageParent = NotApprovedPage.Parent
local NotificationType = require(NotApprovedPageParent.RobloxAppEnums).NotificationType
local RoactNetworking = require(NotApprovedPageParent.RoactServiceTags).RoactNetworking
local UrlBuilder = require(NotApprovedPageParent.UrlBuilder).UrlBuilder
local useRoactService = require(NotApprovedPageParent.RobloxAppHooks).useRoactService
local React = require(NotApprovedPageParent.React)
local Fragment = React.Fragment
local useState = React.useState
local useCallback = React.useCallback
local Foundation = require(NotApprovedPageParent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local EVENT_TYPES = require(NotApprovedPageParent.NotApprovedPageShared).Constants.EVENT_TYPES

require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils)

local ErrorAlert = require(NotApprovedPage.Components.ErrorAlert)
local PostConsequenceCommutation = require(NotApprovedPage.Http.PostConsequenceCommutation)
local SetModerationStatus = require(NotApprovedPageParent.NotApprovedPageShared).SetModerationStatus
local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext
local useOpenLink = require(NotApprovedPage.Utils.useOpenLink)
local FFlagNavigateToSafetyDashboardForAppeals = require(NotApprovedPageParent.SharedFlags).FFlagNavigateToSafetyDashboardForAppeals

local function SecondChanceActionsCta(p1) -- line: 39
	-- upvalues: useNotApprovedPageContext (copy), useOpenLink (copy), FFlagNavigateToSafetyDashboardForAppeals (copy), UrlBuilder (copy), useRoactService (copy), RoactNetworking (copy), useState (copy), useCallback (copy), EVENT_TYPES (copy), PostConsequenceCommutation (copy), SetModerationStatus (copy), GuiService (copy), NotificationType (copy), React (copy), Fragment (copy), ErrorAlert (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local translations = useNotApprovedPageContext().translations
	local v26 = useOpenLink(if not FFlagNavigateToSafetyDashboardForAppeals then UrlBuilder.static.appealsPortal.main() else UrlBuilder.static.safetyDashboard.main(), if not FFlagNavigateToSafetyDashboardForAppeals then translations.appealsPortalTitle else translations.accountStatusTitle)
	local v27 = useRoactService(RoactNetworking)
	local dispatch = p1.dispatch
	local sendPageEvent = p1.sendPageEvent
	local v30, v31 = useState(false)
	local v32, v33 = useState(false)
	local v34 = useCallback(function() -- line: 57
		-- upvalues: v31 (copy), sendPageEvent (copy), EVENT_TYPES (copy), PostConsequenceCommutation (copy), v27 (copy), v33 (copy), dispatch (copy), SetModerationStatus (copy), GuiService (copy), NotificationType (copy)
		v31(true)

		if sendPageEvent then
			sendPageEvent(EVENT_TYPES.SecondChanceReactivateClicked)
		end

		PostConsequenceCommutation(v27):andThen(function(_) -- line: 65
			-- upvalues: v33 (copy), dispatch (copy), SetModerationStatus (copy), GuiService (copy), NotificationType (copy)
			v33(false)
			dispatch(SetModerationStatus(false))
			GuiService:BroadcastNotification("", NotificationType.RESTART_LUA_APP)
		end):catch(function(_) -- line: 70
			-- upvalues: v33 (copy), v31 (copy)
			v33(true)
			v31(false)
		end)
	end, {
		sendPageEvent,
		v27,
		dispatch
	})
	local v35 = useCallback(function() -- line: 76
		-- upvalues: sendPageEvent (copy), EVENT_TYPES (copy), v26 (copy)
		if sendPageEvent then
			sendPageEvent(EVENT_TYPES.AppealsPortalClicked)
		end

		v26()
	end, {
		v26,
		sendPageEvent
	})
	local v36 = useCallback(function() -- line: 83
		-- upvalues: v33 (copy)
		v33(false)
	end, {})

	return React.createElement(Fragment, nil, {
		ErrorAlert = v32 and React.createElement(ErrorAlert, {
			layoutOrder = 1,
			onClose = v36
		}),
		ReactivateButton = React.createElement(Button, {
			LayoutOrder = 2,
			testId = "second-chance-reactivate-button",
			text = translations.okButton,
			onActivated = v34,
			variant = ButtonVariant.Emphasis,
			size = InputSize.Medium,
			width = UDim.new(1, 0),
			isLoading = v30,
			isDisabled = v30
		}),
		SendAppealButton = React.createElement(Button, {
			LayoutOrder = 3,
			testId = "second-chance-send-appeal-button",
			text = translations.sendAppealButton,
			onActivated = v35,
			variant = ButtonVariant.Standard,
			size = InputSize.Medium,
			width = UDim.new(1, 0)
		})
	})
end

return React.memo(SecondChanceActionsCta)
