local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local ReactivateAccount = require(NotApprovedPage.Rodux.Thunks.ReactivateAccount)
local sendNotApprovedPageEvent = require(NotApprovedPage.Utils.sendNotApprovedPageEvent)
local Constants = require(NotApprovedPageParent.NotApprovedPageShared).Constants
local EVENT_TYPES = Constants.EVENT_TYPES
local VERIFICATION_TYPES = Constants.VERIFICATION_TYPES
local INTERVENTION_TYPES = Constants.INTERVENTION_TYPES
local PUNISHMENT_TYPE_TO_INTERVENTION_MAP = Constants.PUNISHMENT_TYPE_TO_INTERVENTION_MAP

require(NotApprovedPage.Common.Types)

local React = require(NotApprovedPageParent.React)
local useState = React.useState
local useMemo = React.useMemo
local useCallback = React.useCallback
local useDispatch = require(NotApprovedPageParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(NotApprovedPageParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(NotApprovedPageParent.RoactServiceTags).RoactNetworking
local NavigateDown = require(NotApprovedPageParent.NavigationRodux).Thunks.NavigateDown
local NavigateBack = require(NotApprovedPageParent.NavigationRodux).Thunks.NavigateBack
local AppPage = require(NotApprovedPageParent.RobloxAppEnums).AppPage
local FFlagSignalsNavP3Dispatch = require(NotApprovedPageParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v21 = if not FFlagSignalsNavP3Dispatch then nil else require(NotApprovedPageParent.RobloxAppNavigation).NavigationCommands
local Foundation = require(NotApprovedPageParent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local UrlBuilder = require(NotApprovedPageParent.UrlBuilder).UrlBuilder
local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext

local function ReactivationButton(t1: {[any]: any}) -- line: 57
	-- upvalues: useState (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useNotApprovedPageContext (copy), PUNISHMENT_TYPE_TO_INTERVENTION_MAP (copy), useCallback (copy), EVENT_TYPES (copy), sendNotApprovedPageEvent (copy), AppPage (copy), UrlBuilder (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), NavigateDown (copy), NavigateBack (copy), ReactivateAccount (copy), useMemo (copy), VERIFICATION_TYPES (copy), INTERVENTION_TYPES (copy), React (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local v30, v31 = useState(false)
	local v32 = useDispatch()
	local v33 = useRoactService(RoactNetworking)
	local translations = useNotApprovedPageContext().translations
	local canReactivate = t1.canReactivate
	local moderationDetail = t1.moderationDetail
	local verificationCategory = moderationDetail.verificationCategory
	local v38 = PUNISHMENT_TYPE_TO_INTERVENTION_MAP[moderationDetail.punishmentTypeDescription]
	local v39 = useCallback(function() -- line: 70
		-- upvalues: v31 (copy), t1 (copy), EVENT_TYPES (copy), sendNotApprovedPageEvent (copy), AppPage (copy), UrlBuilder (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), v32 (copy), NavigateDown (copy)
		v31(true)

		if t1.sendPageEvent then
			t1.sendPageEvent(EVENT_TYPES.EmailVerificationClicked)
		else
			sendNotApprovedPageEvent({
				eventType = EVENT_TYPES.EmailVerificationClicked
			})
		end

		local t2 = {
			name = AppPage.EmailVerification,
			detail = UrlBuilder.fromString("www:")()
		}

		if FFlagSignalsNavP3Dispatch then
			v21.down(v21.fromLegacyPage(t2))

			return
		end

		v32(NavigateDown(t2))
	end, { v32 })
	local v40 = useCallback(function() -- line: 91
		-- upvalues: v31 (copy), t1 (copy), EVENT_TYPES (copy), sendNotApprovedPageEvent (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), v32 (copy), NavigateBack (copy), NavigateDown (copy)
		v31(true)

		if t1.sendPageEvent then
			t1.sendPageEvent(EVENT_TYPES.ParentVerificationClicked)
		else
			sendNotApprovedPageEvent({
				eventType = EVENT_TYPES.ParentVerificationClicked
			})
		end

		local t3 = {
			name = AppPage.AmpWizardContainer,
			extraProps = {
				featureName = "CanRequestPunishmentLifting",
				entryPointEventCtx = "banScreenChargebackLiftPunishment",
				recourseData = {
					punishmentType = "Chargeback"
				},
				completionCallback = function(_, _) -- line: 105
					-- upvalues: FFlagSignalsNavP3Dispatch (copy), v21 (copy), v32 (copy), NavigateBack (copy), v31 (copy)
					if FFlagSignalsNavP3Dispatch then
						v21.back()
					else
						v32(NavigateBack())
					end

					v31(false)
				end
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v21.down(v21.fromLegacyPage(t3))

			return
		end

		v32(NavigateDown(t3))
	end, {
		v32,
		moderationDetail,
		v38,
		t1.LogoutThunk
	})
	local v41 = useCallback(function() -- line: 122
		-- upvalues: v31 (copy), t1 (copy), EVENT_TYPES (copy), sendNotApprovedPageEvent (copy), v32 (copy), ReactivateAccount (copy), v33 (copy), moderationDetail (copy)
		v31(true)

		if t1.sendPageEvent then
			t1.sendPageEvent(EVENT_TYPES.ReactivateClicked)
		else
			sendNotApprovedPageEvent({
				eventType = EVENT_TYPES.ReactivateClicked
			})
		end

		v32(ReactivateAccount(v33, moderationDetail.punishmentId)):andThen(function() -- line: 131
			-- upvalues: v31 (copy)
			v31(false)
		end)
	end, {
		v32,
		v33,
		moderationDetail.punishmentId
	})
	local v42 = useMemo(function() -- line: 136
		-- upvalues: verificationCategory (copy), VERIFICATION_TYPES (copy), translations (copy), v40 (copy), v39 (copy), v38 (copy), INTERVENTION_TYPES (copy), canReactivate (copy), v41 (copy)
		if verificationCategory == VERIFICATION_TYPES.Parent then
			return {
				label = translations.parentVerificationButton,
				action = v40
			}
		end

		if verificationCategory == VERIFICATION_TYPES.Email then
			return {
				label = translations.emailVerificationButton,
				action = v39
			}
		end

		if v38 == INTERVENTION_TYPES.Banned and not canReactivate then
			return {
				label = translations.continueButton,
				action = function() -- line: 150
				end
			}
		end

		return {
			label = translations.continueButton,
			action = v41
		}
	end, {
		canReactivate,
		v40,
		v39,
		v41,
		moderationDetail.endDate,
		verificationCategory,
		v38
	})

	return React.createElement(Button, {
		testId = "reactivation-button",
		text = v42.label,
		onActivated = v42.action,
		variant = ButtonVariant.Emphasis,
		size = InputSize.Medium,
		width = UDim.new(1, 0),
		isLoading = v30,
		isDisabled = not canReactivate or (not t1.isAgreed or v30),
		LayoutOrder = t1.layoutOrder
	})
end

return React.memo(ReactivationButton)
