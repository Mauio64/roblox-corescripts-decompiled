local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local VPCApiProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/VPCApiProvider")
local AmpApiProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/AmpApiProvider")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Localization").Hooks.useLocalization
local vpcConfirmationScreenStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/LocalizationStrings").vpcConfirmationScreenStrings
local vpcUpsellGatherEmailStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/LocalizationStrings").vpcUpsellGatherEmailStrings
local VPCErrorScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/ParentalRequest/VPCErrorScreen")
local VPCConfirmationScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/ParentalRequest/VPCConfirmationScreen")
local VPCNewParentUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/ParentalRequest/VPCNewParentUpsell")
local isStringEmail = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AuthCommon").Utils.isStringEmail
local AppScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/AppScreens")
local GetFStringPrivacyPolicyLink = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFStringPrivacyPolicyLink")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Navigation").useNavigation
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Enums")
local actionTypeEnum = Enums.ActionTypeEnum
local vpcStepEnum = Enums.VPCStepEnum
local vpcRetryBehaviorEnum = Enums.VPCRetryBehaviorEnum

local getRetryBehaviorFromErrorCodeAndRetryNum = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/VPCErrorUtils").getRetryBehaviorFromErrorCodeAndRetryNum
local accessResponseEnum = Enums.AccessResponseEnum
local AuthAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AuthAnalytics")
local authMsgShown = AuthAnalytics.Events.authMsgShown
local authButtonClick = AuthAnalytics.Events.authButtonClick
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local vpcEventConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/EventConstants").vpcEventConstants
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UniversalAppPolicy").useAppPolicy
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RobloxAppHooks").useRoactService
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/ArgCheck")
local appLinking = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactServiceTags").AppLinking

local GetFFlagEnableExternalBrowserForVPCPrivacyPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableExternalBrowserForVPCPrivacyPolicy")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactServiceTags").RoactNetworking
local fFlagLuaAppOdpRequestSentToast = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/SharedFlags").FFlagLuaAppOdpRequestSentToast

local fFlagLuaAppAmpWizardSendAnalyticsSessionId = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/SharedFlags").FFlagLuaAppAmpWizardSendAnalyticsSessionId

local function VPCUpsellContainer(props)
	local onCancel = props.onCancel
	local onSuccess = props.onSuccess
	local v5 = if props.vpcApiProvider then props.vpcApiProvider else VPCApiProvider
	local v6 = if props.ampApiProvider then props.ampApiProvider else AmpApiProvider
	local recourseAction = props.recourseAction
	local recourseData = props.recourseData
	local v7 = not props.entryPointEventCtx and "" or props.entryPointEventCtx
	local parentConsentTypes = props.parentConsentTypes
	local v8 = if props.disablePortal then props.disablePortal else false
	local v9 = if props.isInExperienceEntry then props.isInExperienceEntry else false
	local onRequestSent = props.onRequestSent
	local analyticsSessionId = props.analyticsSessionId
	local vpcEntryAnalytics = props.vpcEntryAnalytics

	local v10 = useRoactService(roactNetworking)
	local v11, v12

	if GetFFlagEnableExternalBrowserForVPCPrivacyPolicy() then
		v11 = useAppPolicy(function(p2)
			return p2.shouldUseExternalBrowserForDisclaimerLinks()
		end)

		v12 = useRoactService(appLinking)
	else
		v11 = false
		v12 = nil
	end

	local useState = React.useState
	local v13

	if recourseAction == actionTypeEnum.ParentLink then
		v13 = vpcStepEnum.NewParentLoading
	else
		v13 = vpcStepEnum.AlreadyLinkedSendRequest
	end

	local state, setState = useState(v13)

	local state2, setState2 = React.useState("Unknown")
	local state3, setState3 = React.useState({})
	local state4, setState4 = React.useState(true)

	local v14 = useLocalization(vpcUpsellGatherEmailStrings)
	local state5, setState5 = React.useState(false)
	local state6, setState6 = React.useState("")
	local state7, setState7 = React.useState("")
	local v15 = useNavigation()

	local function openExternalBrowser(object, p2)
		ArgCheck.isNotNil(object, "linking")
		ArgCheck.isType(p2, "string", "url")

		object:openURL(p2)
	end

	local function fn()
		if not (GetFFlagEnableExternalBrowserForVPCPrivacyPolicy() and v11) then
			v15.navigate(AppScreens.GenericWebPage, {
				detail = GetFStringPrivacyPolicyLink(),
				extraProps = {
					title = v14.privacyLinkText,
					transitionAnimation = "SlideInFromBottom"
				}
			})

			return
		end

		local v16 = v12
		local v17 = GetFStringPrivacyPolicyLink()
		ArgCheck.isNotNil(v16, "linking")
		ArgCheck.isType(v17, "string", "url")

		v16:openURL(v17)
	end

	local function handleEmailInput(p2)
		setState6(p2)

		if isStringEmail(p2) then
			setState5(true)
			setState7("")
		else
			setState5(false)

			if p2 == "" then
				setState7("")
			else
				setState7(v14.errorText)
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

		local v17 = if recourseAction == actionTypeEnum.ParentLink then vpcStepEnum.NewParentCollectEmail else vpcStepEnum.AlreadyLinkedSendRequest
		setState(v17)
	end

	local function finishSuccessfulRequest(p2)
		setState(vpcStepEnum.RequestSent)

		if fFlagLuaAppOdpRequestSentToast and onRequestSent then
			local v17 = if p2 then p2.sessionId else nil
			pcall(onRequestSent, v17)
		end
	end

	local function getLinkedParentEmailsAndSendRequestToAllParents()
		v5.getLinkedParentEmails(v10):andThen(function(p2)
			setState3(p2.parentEmails)
		end):catch(function(p2) end)

		v5.sendRequestToAllParents(v10, parentConsentTypes, recourseData, analyticsSessionId):andThen(finishSuccessfulRequest):catch(function(p2)
			setState2(p2.code)
			setState(vpcStepEnum.Error)
		end)
	end

	local function sendRequestToNewParent(p2)
		v5.sendRequestToNewParent(v10, p2, parentConsentTypes, recourseData, analyticsSessionId):andThen(finishSuccessfulRequest):catch(function(p3)
			setState2(p3.code)
			setState(vpcStepEnum.Error)
		end)
	end

	local function getIsChildSubjectToParentalControls()
		local featureAccess = v6.getFeatureAccess({ "IsChildSubjectToParentalControls" })

		setState4(not (featureAccess.featureAccessList and featureAccess.featureAccessList[1]) or featureAccess.featureAccessList[1].access ~= accessResponseEnum.Denied)
		setState(vpcStepEnum.NewParentCollectEmail)
	end

	React.useEffect(function()
		if recourseAction == actionTypeEnum.ParentConsent then
			getLinkedParentEmailsAndSendRequestToAllParents()
		elseif recourseAction == actionTypeEnum.ParentLink then
			getIsChildSubjectToParentalControls()
		end
	end, { state8 })

	local ref = if fFlagLuaAppAmpWizardSendAnalyticsSessionId then React.useRef(nil) else nil
	local ref2 = if fFlagLuaAppAmpWizardSendAnalyticsSessionId then React.useRef(false) else nil

	if fFlagLuaAppAmpWizardSendAnalyticsSessionId then
		React.useEffect(function()
			if vpcEntryAnalytics == nil or ref == nil or ref.current == state then
				return
			end

			ref.current = state

			if state == vpcStepEnum.NewParentCollectEmail then
				if ref2 then
					ref2.current = false
				end

				vpcEntryAnalytics.remoteEmailShown()
			elseif state == vpcStepEnum.RequestSent then
				vpcEntryAnalytics.remoteRequestSent()
			elseif state == vpcStepEnum.Error then
				if getRetryBehaviorFromErrorCodeAndRetryNum(state2, state8) == vpcRetryBehaviorEnum.Success then
					vpcEntryAnalytics.remoteRequestSent()
				else
					vpcEntryAnalytics.remoteRequestError(state2)
				end
			end
		end, { state, state2, state8, vpcEntryAnalytics })
	end

	if state == vpcStepEnum.RequestSent then
		authMsgShown(v7, "", vpcEventConstants.confirmationPageLoadField, "")
		return React.createElement(VPCConfirmationScreen, {
			messageStrings = vpcConfirmationScreenStrings,
			parentEmails = state3,
			onAck = function()
				authButtonClick(v7, vpcEventConstants.confirmationPageButton)

				if vpcEntryAnalytics then
					vpcEntryAnalytics.remoteRequestOk()
				end

				onSuccess()
			end,
			onClose = vpcEntryAnalytics and function()
				vpcEntryAnalytics.remoteRequestClose()
				authButtonClick(v7, vpcEventConstants.confirmationPageButton)
				onSuccess()
			end or nil,
			disablePortal = v8,
			isInExperienceEntry = v9
		})
	end

	if state == vpcStepEnum.NewParentCollectEmail then
		authMsgShown(v7, "", vpcEventConstants.collectEmailPageLoadField, "")
		return React.createElement(VPCNewParentUpsell, {
			onCancel = function()
				if vpcEntryAnalytics then
					vpcEntryAnalytics.remoteRequestClose()
				end

				onCancel()
			end,
			onCollectEmailAndSendRequest = function(p2)
				authButtonClick(v7, vpcEventConstants.collectEmailPageSubmitButton)

				if vpcEntryAnalytics then
					vpcEntryAnalytics.remoteEmailSubmit()
				end

				setState3({ p2 })
				setState(vpcStepEnum.NewParentSendRequest)
				sendRequestToNewParent(p2)
			end,
			onTextChange = function(p2)
				authFormInteraction(v7, vpcEventConstants.collectEmailPageInteractFormField)

				if vpcEntryAnalytics and ref2 and not ref2.current and p2 ~= "" then
					ref2.current = true
					vpcEntryAnalytics.remoteEmailEntered()
				end

				handleEmailInput(p2)
			end,
			canSendRequest = state5,
			textInput = state6,
			openPrivacyPolicyLink = fn,
			errorText = state7,
			messageStrings = vpcUpsellGatherEmailStrings,
			isChildSubjectToParentalControls = state4,
			disablePortal = v8,
			isInExperienceEntry = v9
		})
	end

	if not (state ~= vpcStepEnum.AlreadyLinkedSendRequest and state ~= vpcStepEnum.NewParentSendRequest and state ~= vpcStepEnum.NewParentLoading) then
		return nil
	end

	authMsgShown(v7, "", vpcEventConstants.errorPageLoadField, state2)
	return React.createElement(VPCErrorScreen, {
		errorCode = state2,
		onRetryAmp = function()
			authButtonClick(v7, vpcEventConstants.errorPageRetryButton)

			if vpcEntryAnalytics then
				vpcEntryAnalytics.remoteRequestRetry()
			end

			onRetryAmp()
		end,
		onRetryVPC = function()
			authButtonClick(v7, vpcEventConstants.errorPageRetryButton)

			if vpcEntryAnalytics then
				vpcEntryAnalytics.remoteRequestRetry()
			end

			onRetryVPC()
		end,
		onCancel = function()
			authButtonClick(v7, vpcEventConstants.errorPageCancelButton)

			if vpcEntryAnalytics then
				vpcEntryAnalytics.remoteRequestCancel()
			end

			onCancel()
		end,
		onClose = vpcEntryAnalytics and function()
			vpcEntryAnalytics.remoteRequestClose()
			authButtonClick(v7, vpcEventConstants.errorPageCancelButton)
			onCancel()
		end or nil,
		onSuccess = function()
			authButtonClick(v7, vpcEventConstants.confirmationPageButton)

			if vpcEntryAnalytics then
				vpcEntryAnalytics.remoteRequestOk()
			end

			onSuccess()
		end,
		retryNum = state8,
		disablePortal = v8,
		isInExperienceEntry = v9
	})
end

return VPCUpsellContainer
