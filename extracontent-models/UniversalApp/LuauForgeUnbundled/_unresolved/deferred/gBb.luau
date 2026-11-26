local module = require("@luauforge/deferred/gBc")
local module2 = require("@luauforge/deferred/gzX")

local constants = require("@luauforge/deferred/gzN").Constants
local EVENT_TYPES = constants.EVENT_TYPES
local VERIFICATION_TYPES = constants.VERIFICATION_TYPES
local INTERVENTION_TYPES = constants.INTERVENTION_TYPES
local PUNISHMENT_TYPE_TO_INTERVENTION_MAP = constants.PUNISHMENT_TYPE_TO_INTERVENTION_MAP

require("@luauforge/deferred/gzP")

local module3 = require("@luauforge/deferred/gzS")
local useState = module3.useState
local useMemo = module3.useMemo
local useCallback = module3.useCallback
local useDispatch = require("@luauforge/deferred/gAC").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/deferred/gAA").useRoactService
local roactNetworking = require("@luauforge/deferred/gAz").RoactNetworking
local navigateDown = require("@luauforge/deferred/gAv").Thunks.NavigateDown
local navigateBack = require("@luauforge/deferred/gAv").Thunks.NavigateBack
local appPage = require("@luauforge/deferred/gAu").AppPage

local fFlagSignalsNavP3Dispatch = require("@luauforge/deferred/gAd").FFlagSignalsNavP3Dispatch
local fFlagLuaAppVpcUpsellNamespace = require("@luauforge/deferred/gAd").FFlagLuaAppVpcUpsellNamespace

local fStringLuaAppVpcAccountManagementAmpNameSpace = require("@luauforge/deferred/gAd").FStringLuaAppVpcAccountManagementAmpNameSpace

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/deferred/gAx").NavigationCommands else nil

local module4 = require("@luauforge/deferred/gzT")
local button = module4.Button
local buttonVariant = module4.Enums.ButtonVariant
local inputSize = module4.Enums.InputSize

local urlBuilder = require("@luauforge/deferred/gAw").UrlBuilder

local useNotApprovedPageContext = require("@luauforge/deferred/gAo").useNotApprovedPageContext

local function ReactivationButton(props)
	local state, setState = useState(false)

	local v5 = useDispatch()
	local v6 = useRoactService(roactNetworking)
	local translations = useNotApprovedPageContext().translations

	local canReactivate = props.canReactivate

	local moderationDetail = props.moderationDetail
	local verificationCategory = moderationDetail.verificationCategory
	local v7 = PUNISHMENT_TYPE_TO_INTERVENTION_MAP[moderationDetail.punishmentTypeDescription]

	local v8 = useCallback(function()
		setState(true)

		if props.sendPageEvent then
			props.sendPageEvent(EVENT_TYPES.EmailVerificationClicked)
		else
			module2({ eventType = EVENT_TYPES.EmailVerificationClicked })
		end

		local v9 = {
			name = appPage.EmailVerification,
			detail = urlBuilder.fromString("www:")()
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v9))
		else
			v5(navigateDown(v9))
		end
	end, { v5 })

	local v9 = useCallback(function()
		setState(true)

		if props.sendPageEvent then
			props.sendPageEvent(EVENT_TYPES.ParentVerificationClicked)
		else
			module2({ eventType = EVENT_TYPES.ParentVerificationClicked })
		end

		local v10 = {
			name = appPage.AmpWizardContainer,
			extraProps = {
				featureName = "CanRequestPunishmentLifting",
				recourseData = { punishmentType = "Chargeback" },
				entryPointEventCtx = "banScreenChargebackLiftPunishment",
				nameSpace = if fFlagLuaAppVpcUpsellNamespace then fStringLuaAppVpcAccountManagementAmpNameSpace else nil,
				completionCallback = function(p2, p3)
					if fFlagSignalsNavP3Dispatch then
						navigationCommands.back()
					else
						v5(navigateBack())
					end

					setState(false)
				end
			}
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v10))
		else
			v5(navigateDown(v10))
		end
	end, { v5, moderationDetail, v7, props.LogoutThunk })

	local v10 = useCallback(function()
		setState(true)

		if props.sendPageEvent then
			props.sendPageEvent(EVENT_TYPES.ReactivateClicked)
		else
			module2({ eventType = EVENT_TYPES.ReactivateClicked })
		end

		v5(module(v6, moderationDetail.punishmentId)):andThen(function()
			setState(false)
		end)
	end, { v5, v6, moderationDetail.punishmentId })

	local v11 = useMemo(function()
		if verificationCategory == VERIFICATION_TYPES.Parent then
			return { label = translations.parentVerificationButton, action = v9 }
		end

		if verificationCategory == VERIFICATION_TYPES.Email then
			return { label = translations.emailVerificationButton, action = v8 }
		end

		if v7 == INTERVENTION_TYPES.Banned and not canReactivate then
			return {
				label = translations.continueButton,
				action = function() end
			}
		end

		return { label = translations.continueButton, action = v10 }
	end, {
		canReactivate,
		v9,
		v8,
		v10,
		moderationDetail.endDate,
		verificationCategory,
		v7
	})

	return module3.createElement(button, {
		text = v11.label,
		onActivated = v11.action,
		variant = buttonVariant.Emphasis,
		size = inputSize.Medium,
		width = UDim.new(1, 0),
		isLoading = state,
		isDisabled = not canReactivate or not props.isAgreed or state,
		LayoutOrder = props.layoutOrder,
		testId = "reactivation-button"
	})
end

return module3.memo(ReactivationButton)
