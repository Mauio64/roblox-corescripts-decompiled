local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent
local React = require(parent.React)
local VPCApiProvider = require(AmpUpsell.Common.VPCApiProvider)
local AmpApiProvider = require(AmpUpsell.Common.AmpApiProvider)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(AmpUpsell.Common.LocalizationStrings)
local vpcConfirmationScreenStrings = LocalizationStrings.vpcConfirmationScreenStrings
local LocalizationStrings2 = require(AmpUpsell.Common.LocalizationStrings)
local vpcUpsellGatherEmailStrings = LocalizationStrings2.vpcUpsellGatherEmailStrings
local VPCErrorScreen = require(script.Parent.VPCErrorScreen)
local VPCConfirmationScreen = require(script.Parent.VPCConfirmationScreen)
local VPCNewParentUpsell = require(script.Parent.VPCNewParentUpsell)
local AuthCommon = require(parent.AuthCommon)
local isStringEmail = AuthCommon.Utils.isStringEmail
local AppScreens = require(AmpUpsell.Common.AppScreens)
local GetFStringPrivacyPolicyLink = require(AmpUpsell.Flags.GetFStringPrivacyPolicyLink)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Enums = require(AmpUpsell.Common.Enums)
local ActionTypeEnum = Enums.ActionTypeEnum
local VPCStepEnum = Enums.VPCStepEnum
local VPCRetryBehaviorEnum = Enums.VPCRetryBehaviorEnum

local VPCErrorUtils = require(AmpUpsell.Common.VPCErrorUtils)
local getRetryBehaviorFromErrorCodeAndRetryNum = VPCErrorUtils.getRetryBehaviorFromErrorCodeAndRetryNum
local AccessResponseEnum = Enums.AccessResponseEnum
local AuthAnalytics = require(parent.AuthAnalytics)
local authMsgShown = AuthAnalytics.Events.authMsgShown
local authButtonClick = AuthAnalytics.Events.authButtonClick
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local EventConstants = require(AmpUpsell.Common.EventConstants)
local vpcEventConstants = EventConstants.vpcEventConstants
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local ArgCheck = require(parent.ArgCheck)
local RoactServiceTags = require(parent.RoactServiceTags)
local AppLinking = RoactServiceTags.AppLinking

local GetFFlagEnableExternalBrowserForVPCPrivacyPolicy = require(AmpUpsell.Flags.GetFFlagEnableExternalBrowserForVPCPrivacyPolicy)
local RoactServiceTags2 = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags2.RoactNetworking
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppOdpRequestSentToast = SharedFlags.FFlagLuaAppOdpRequestSentToast

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppAmpWizardSendAnalyticsSessionId = SharedFlags2.FFlagLuaAppAmpWizardSendAnalyticsSessionId

local function VPCUpsellContainer(props)
	local onCancel = props.onCancel
	local onSuccess = props.onSuccess
	local v

	if props.vpcApiProvider then
		v = props.vpcApiProvider
	else
		v = VPCApiProvider
	end

	local v2

	if props.ampApiProvider then
		v2 = props.ampApiProvider
	else
		v2 = AmpApiProvider
	end

	local recourseAction = props.recourseAction
	local recourseData = props.recourseData
	local v3 = not props.entryPointEventCtx and "" or props.entryPointEventCtx
	local parentConsentTypes = props.parentConsentTypes
	local disablePortal

	if props.disablePortal then
		disablePortal = props.disablePortal
	else
		disablePortal = false
	end

	local isInExperienceEntry

	if props.isInExperienceEntry then
		isInExperienceEntry = props.isInExperienceEntry
	else
		isInExperienceEntry = false
	end

	local onRequestSent = props.onRequestSent
	local analyticsSessionId = props.analyticsSessionId
	local vpcEntryAnalytics = props.vpcEntryAnalytics

	local v4 = useRoactService(RoactNetworking)
	local v5, v6

	if GetFFlagEnableExternalBrowserForVPCPrivacyPolicy() then
		v5 = useAppPolicy(function(p)
			return p.shouldUseExternalBrowserForDisclaimerLinks()
		end)

		v6 = useRoactService(AppLinking)
	else
		v5 = false
		v6 = nil
	end

	local useState = React.useState
	local v7

	if recourseAction == ActionTypeEnum.ParentLink then
		v7 = VPCStepEnum.NewParentLoading
	else
		v7 = VPCStepEnum.AlreadyLinkedSendRequest
	end

	local state, setState = useState(v7)

	local state2, setState2 = React.useState("Unknown")
	local state3, setState3 = React.useState({})
	local state4, setState4 = React.useState(true)

	local v8 = useLocalization(vpcUpsellGatherEmailStrings)
	local state5, setState5 = React.useState(false)
	local state6, setState6 = React.useState("")
	local state7, setState7 = React.useState("")
	local v9 = useNavigation()

	local function openExternalBrowser(object, p) -- 1 equivalent call inferred from this helper
		ArgCheck.isNotNil(object, "linking")
		ArgCheck.isType(p, "string", "url")

		object:openURL(p)
	end

	local function fn()
		if not (GetFFlagEnableExternalBrowserForVPCPrivacyPolicy() and v5) then
			v9.navigate(AppScreens.GenericWebPage, {
				detail = GetFStringPrivacyPolicyLink(),
				extraProps = {
					title = v8.privacyLinkText,
					transitionAnimation = "SlideInFromBottom"
				}
			})

			return
		end

		openExternalBrowser(v6, GetFStringPrivacyPolicyLink()) -- inferred equivalent call
	end

	local function handleEmailInput(p: string)
		setState6(p)

		if isStringEmail(p) then
			setState5(true)
			setState7("")
		else
			setState5(false)

			if p == "" then
				setState7("")
			else
				setState7(v8.errorText)
			end
		end
	end

	local state8, setState8 = React.useState(0)
	local onRetryAmp = props.onRetryAmp
	local function onRetryVPC()
		setState8(state8 + 1)
		setState3({})
		setState2("Unknown")
		setState6("")

		if isStringEmail("") then
			setState5(true)
		else
			setState5(false)
		end

		setState7("")
		local v10

		if recourseAction == ActionTypeEnum.ParentLink then
			v10 = VPCStepEnum.NewParentCollectEmail
		else
			v10 = VPCStepEnum.AlreadyLinkedSendRequest
		end

		setState(v10)
	end

	local function finishSuccessfulRequest(p)
		setState(VPCStepEnum.RequestSent)

		if FFlagLuaAppOdpRequestSentToast and onRequestSent then
			local v10

			if p then
				v10 = p.sessionId
			end

			pcall(onRequestSent, v10)
		end
	end

	local function getLinkedParentEmailsAndSendRequestToAllParents()
		v.getLinkedParentEmails(v4):andThen(function(p)
			setState3(p.parentEmails)
		end):catch(function(_) end)

		v.sendRequestToAllParents(v4, parentConsentTypes, recourseData, analyticsSessionId):andThen(finishSuccessfulRequest):catch(function(p)
			setState2(p.code)
			setState(VPCStepEnum.Error)
		end)
	end

	local function sendRequestToNewParent(p)
		v.sendRequestToNewParent(v4, p, parentConsentTypes, recourseData, analyticsSessionId):andThen(finishSuccessfulRequest):catch(function(p2)
			setState2(p2.code)
			setState(VPCStepEnum.Error)
		end)
	end

	local function getIsChildSubjectToParentalControls()
		local featureAccess = v2.getFeatureAccess({ "IsChildSubjectToParentalControls" })

		setState4(not (featureAccess.featureAccessList and featureAccess.featureAccessList[1]) or featureAccess.featureAccessList[1].access ~= AccessResponseEnum.Denied)
		setState(VPCStepEnum.NewParentCollectEmail)
	end

	React.useEffect(function()
		if recourseAction == ActionTypeEnum.ParentConsent then
			getLinkedParentEmailsAndSendRequestToAllParents()
		elseif recourseAction == ActionTypeEnum.ParentLink then
			getIsChildSubjectToParentalControls()
		end
	end, { state8 })
	local ref

	if FFlagLuaAppAmpWizardSendAnalyticsSessionId then
		ref = React.useRef(nil)
	else
		ref = nil
	end

	local ref2

	if FFlagLuaAppAmpWizardSendAnalyticsSessionId then
		ref2 = React.useRef(false)
	else
		ref2 = nil
	end

	if FFlagLuaAppAmpWizardSendAnalyticsSessionId then
		React.useEffect(function()
			if vpcEntryAnalytics == nil or ref == nil or ref.current == state then
				return
			end

			ref.current = state

			if state == VPCStepEnum.NewParentCollectEmail then
				if ref2 then
					ref2.current = false
				end

				vpcEntryAnalytics.remoteEmailShown()
			elseif state == VPCStepEnum.RequestSent then
				vpcEntryAnalytics.remoteRequestSent()
			elseif state == VPCStepEnum.Error then
				if getRetryBehaviorFromErrorCodeAndRetryNum(state2, state8) == VPCRetryBehaviorEnum.Success then
					vpcEntryAnalytics.remoteRequestSent()
				else
					vpcEntryAnalytics.remoteRequestError(state2)
				end
			end
		end, { state, state2, state8, vpcEntryAnalytics })
	end

	if state == VPCStepEnum.RequestSent then
		authMsgShown(v3, "", vpcEventConstants.confirmationPageLoadField, "")
		return React.createElement(VPCConfirmationScreen, {
			messageStrings = vpcConfirmationScreenStrings,
			parentEmails = state3,
			onAck = function()
				authButtonClick(v3, vpcEventConstants.confirmationPageButton)

				if vpcEntryAnalytics then
					vpcEntryAnalytics.remoteRequestOk()
				end

				onSuccess()
			end,
			onClose = vpcEntryAnalytics and function()
				vpcEntryAnalytics.remoteRequestClose()
				authButtonClick(v3, vpcEventConstants.confirmationPageButton)
				onSuccess()
			end or nil,
			disablePortal = disablePortal,
			isInExperienceEntry = isInExperienceEntry
		})
	end

	if state == VPCStepEnum.NewParentCollectEmail then
		authMsgShown(v3, "", vpcEventConstants.collectEmailPageLoadField, "")
		return React.createElement(VPCNewParentUpsell, {
			onCancel = function()
				if vpcEntryAnalytics then
					vpcEntryAnalytics.remoteRequestClose()
				end

				onCancel()
			end,
			onCollectEmailAndSendRequest = function(p)
				authButtonClick(v3, vpcEventConstants.collectEmailPageSubmitButton)

				if vpcEntryAnalytics then
					vpcEntryAnalytics.remoteEmailSubmit()
				end

				setState3({ p })
				setState(VPCStepEnum.NewParentSendRequest)
				sendRequestToNewParent(p)
			end,
			onTextChange = function(p)
				authFormInteraction(v3, vpcEventConstants.collectEmailPageInteractFormField)

				if vpcEntryAnalytics and ref2 and not ref2.current and p ~= "" then
					ref2.current = true
					vpcEntryAnalytics.remoteEmailEntered()
				end

				handleEmailInput(p)
			end,
			canSendRequest = state5,
			textInput = state6,
			openPrivacyPolicyLink = fn,
			errorText = state7,
			messageStrings = vpcUpsellGatherEmailStrings,
			isChildSubjectToParentalControls = state4,
			disablePortal = disablePortal,
			isInExperienceEntry = isInExperienceEntry
		})
	end

	if not (state ~= VPCStepEnum.AlreadyLinkedSendRequest and state ~= VPCStepEnum.NewParentSendRequest and state ~= VPCStepEnum.NewParentLoading) then
		return nil
	end

	authMsgShown(v3, "", vpcEventConstants.errorPageLoadField, state2)
	return React.createElement(VPCErrorScreen, {
		errorCode = state2,
		onRetryAmp = function()
			authButtonClick(v3, vpcEventConstants.errorPageRetryButton)

			if vpcEntryAnalytics then
				vpcEntryAnalytics.remoteRequestRetry()
			end

			onRetryAmp()
		end,
		onRetryVPC = function()
			authButtonClick(v3, vpcEventConstants.errorPageRetryButton)

			if vpcEntryAnalytics then
				vpcEntryAnalytics.remoteRequestRetry()
			end

			onRetryVPC()
		end,
		onCancel = function()
			authButtonClick(v3, vpcEventConstants.errorPageCancelButton)

			if vpcEntryAnalytics then
				vpcEntryAnalytics.remoteRequestCancel()
			end

			onCancel()
		end,
		onClose = vpcEntryAnalytics and function()
			vpcEntryAnalytics.remoteRequestClose()
			authButtonClick(v3, vpcEventConstants.errorPageCancelButton)
			onCancel()
		end or nil,
		onSuccess = function()
			authButtonClick(v3, vpcEventConstants.confirmationPageButton)

			if vpcEntryAnalytics then
				vpcEntryAnalytics.remoteRequestOk()
			end

			onSuccess()
		end,
		retryNum = state8,
		disablePortal = disablePortal,
		isInExperienceEntry = isInExperienceEntry
	})
end

return VPCUpsellContainer
