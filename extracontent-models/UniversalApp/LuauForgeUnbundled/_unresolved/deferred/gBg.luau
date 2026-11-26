local GuiService = game:GetService("GuiService")

local notificationType = require("@luauforge/deferred/gAu").NotificationType
local roactNetworking = require("@luauforge/deferred/gAz").RoactNetworking
local urlBuilder = require("@luauforge/deferred/gAw").UrlBuilder
local useRoactService = require("@luauforge/deferred/gAA").useRoactService

local module = require("@luauforge/deferred/gzS")
local fragment = module.Fragment
local useState = module.useState
local useCallback = module.useCallback

local module2 = require("@luauforge/deferred/gzT")
local button = module2.Button
local buttonVariant = module2.Enums.ButtonVariant
local inputSize = module2.Enums.InputSize

local EVENT_TYPES = require("@luauforge/deferred/gzN").Constants.EVENT_TYPES

require("@luauforge/deferred/gzW")

local module3 = require("@luauforge/deferred/gBh")
local module4 = require("@luauforge/deferred/gBi")
local setModerationStatus = require("@luauforge/deferred/gzN").SetModerationStatus
local useNotApprovedPageContext = require("@luauforge/deferred/gAo").useNotApprovedPageContext

local fFlagUseSignalsForModeration = require("@luauforge/deferred/gAd").FFlagUseSignalsForModeration

local getModerationStore = if fFlagUseSignalsForModeration then require("@luauforge/deferred/gzN").GetModerationStore else nil

local module5 = require("@luauforge/deferred/gAL")
local module6 = require("@luauforge/deferred/gAy")

local fFlagNavigateToSafetyDashboardForAppeals = require("@luauforge/deferred/gAd").FFlagNavigateToSafetyDashboardForAppeals

local function SecondChanceActionsCta(props)
	local translations = useNotApprovedPageContext().translations

	local violation = props.moderationDetail.violation
	local v6

	if fFlagNavigateToSafetyDashboardForAppeals then
		v6 = module5(violation)
	else
		v6 = urlBuilder.static.appealsPortal.main()
	end

	local v7

	if fFlagNavigateToSafetyDashboardForAppeals then
		v7 = translations.accountStatusTitle
	else
		v7 = translations.appealsPortalTitle
	end

	local v8 = module6(v6, v7)

	local v9 = useRoactService(roactNetworking)
	local dispatch = props.dispatch
	local sendPageEvent = props.sendPageEvent

	local state, setState = useState(false)
	local state2, setState2 = useState(false)

	local v10 = useCallback(function()
		setState(true)

		if sendPageEvent then
			sendPageEvent(EVENT_TYPES.SecondChanceReactivateClicked)
		end

		module4(v9):andThen(function(p2)
			setState2(false)

			if fFlagUseSignalsForModeration then
				getModerationStore(false).setModerationStatus(false)
			else
				dispatch(setModerationStatus(false))
			end

			GuiService:BroadcastNotification("", notificationType.RESTART_LUA_APP)
		end):catch(function(p2)
			setState2(true)
			setState(false)
		end)
	end, { sendPageEvent, v9, dispatch })

	local v11 = useCallback(function()
		if sendPageEvent then
			sendPageEvent(EVENT_TYPES.AppealsPortalClicked)
		end

		v8()
	end, { v8, sendPageEvent })

	local v12 = useCallback(function()
		setState2(false)
	end, {})

	return module.createElement(fragment, nil, {
		ErrorAlert = state2 and module.createElement(module3, {
			onClose = v12,
			layoutOrder = 1
		}),
		ReactivateButton = module.createElement(button, {
			text = translations.okButton,
			onActivated = v10,
			variant = buttonVariant.Emphasis,
			size = inputSize.Medium,
			width = UDim.new(1, 0),
			isLoading = state,
			isDisabled = state,
			LayoutOrder = 2,
			testId = "second-chance-reactivate-button"
		}),
		SendAppealButton = module.createElement(button, {
			text = translations.sendAppealButton,
			onActivated = v11,
			variant = buttonVariant.Standard,
			size = inputSize.Medium,
			width = UDim.new(1, 0),
			LayoutOrder = 3,
			testId = "second-chance-send-appeal-button"
		})
	})
end

return module.memo(SecondChanceActionsCta)
