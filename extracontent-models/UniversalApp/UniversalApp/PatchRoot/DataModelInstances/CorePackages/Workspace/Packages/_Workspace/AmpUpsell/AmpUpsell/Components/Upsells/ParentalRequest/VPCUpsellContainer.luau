local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local React = require(AmpUpsellParent.React)
local VPCApiProvider = require(AmpUpsell.Common.VPCApiProvider)
local AmpApiProvider = require(AmpUpsell.Common.AmpApiProvider)
local useLocalization = require(AmpUpsellParent.Localization).Hooks.useLocalization
local vpcConfirmationScreenStrings = require(AmpUpsell.Common.LocalizationStrings).vpcConfirmationScreenStrings
local vpcUpsellGatherEmailStrings = require(AmpUpsell.Common.LocalizationStrings).vpcUpsellGatherEmailStrings
local VPCErrorScreen = require(script.Parent.VPCErrorScreen)
local VPCConfirmationScreen = require(script.Parent.VPCConfirmationScreen)
local VPCNewParentUpsell = require(script.Parent.VPCNewParentUpsell)
local isStringEmail = require(AmpUpsellParent.AuthCommon).Utils.isStringEmail
local AppScreens = require(AmpUpsell.Common.AppScreens)
local GetFStringPrivacyPolicyLink = require(AmpUpsell.Flags.GetFStringPrivacyPolicyLink)
local useNavigation = require(AmpUpsellParent.Navigation).useNavigation
local Enums = require(AmpUpsell.Common.Enums)
local ActionTypeEnum = Enums.ActionTypeEnum
local VPCStepEnum = Enums.VPCStepEnum
local AccessResponseEnum = Enums.AccessResponseEnum
local AuthAnalytics = require(AmpUpsellParent.AuthAnalytics)
local authMsgShown = AuthAnalytics.Events.authMsgShown
local authButtonClick = AuthAnalytics.Events.authButtonClick
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local vpcEventConstants = require(AmpUpsell.Common.EventConstants).vpcEventConstants
local useAppPolicy = require(AmpUpsellParent.UniversalAppPolicy).useAppPolicy
local useRoactService = require(AmpUpsellParent.RobloxAppHooks).useRoactService
local ArgCheck = require(AmpUpsellParent.ArgCheck)
local AppLinking = require(AmpUpsellParent.RoactServiceTags).AppLinking
local GetFFlagEnableExternalBrowserForVPCPrivacyPolicy = require(AmpUpsell.Flags.GetFFlagEnableExternalBrowserForVPCPrivacyPolicy)
local RoactNetworking = require(AmpUpsellParent.RoactServiceTags).RoactNetworking

local function VPCUpsellContainer(t1: {[any]: any}) -- line: 49
	-- upvalues: VPCApiProvider (copy), AmpApiProvider (copy), useRoactService (copy), RoactNetworking (copy), GetFFlagEnableExternalBrowserForVPCPrivacyPolicy (copy), useAppPolicy (copy), AppLinking (copy), React (copy), ActionTypeEnum (copy), VPCStepEnum (copy), useLocalization (copy), vpcUpsellGatherEmailStrings (copy), useNavigation (copy), ArgCheck (copy), GetFStringPrivacyPolicyLink (copy), AppScreens (copy), isStringEmail (copy), AccessResponseEnum (copy), authMsgShown (copy), vpcEventConstants (copy), VPCConfirmationScreen (copy), vpcConfirmationScreenStrings (copy), authButtonClick (copy), VPCNewParentUpsell (copy), authFormInteraction (copy), VPCErrorScreen (copy)
	local onCancel = t1.onCancel
	local onSuccess = t1.onSuccess
	local v35 = if not t1.vpcApiProvider then VPCApiProvider else t1.vpcApiProvider
	local v36 = if not t1.ampApiProvider then AmpApiProvider else t1.ampApiProvider
	local recourseAction = t1.recourseAction
	local recourseData = t1.recourseData
	local v39 = not t1.entryPointEventCtx and "" or t1.entryPointEventCtx
	local parentConsentTypes = t1.parentConsentTypes
	local v41 = not not t1.disablePortal and t1.disablePortal
	local v42 = not not t1.isInExperienceEntry and t1.isInExperienceEntry
	local v43 = useRoactService(RoactNetworking)
	local u44 = false
	local u45 = nil

	if GetFFlagEnableExternalBrowserForVPCPrivacyPolicy() then
		u44 = useAppPolicy(function(p1) -- line: 66
			return p1.shouldUseExternalBrowserForDisclaimerLinks()
		end)
		u45 = useRoactService(AppLinking)
	end

	local v46, v47 = React.useState(if recourseAction ~= ActionTypeEnum.ParentLink then VPCStepEnum.AlreadyLinkedSendRequest else VPCStepEnum.NewParentLoading)
	local v48, v49 = React.useState("Unknown")
	local v50, v51 = React.useState({})
	local v52, v53 = React.useState(true)
	local v54 = useLocalization(vpcUpsellGatherEmailStrings)
	local v55, v56 = React.useState(false)
	local v57, v58 = React.useState("")
	local v59, v60 = React.useState("")
	local v61 = useNavigation()

	local function openExternalBrowser(p2, p3) -- line: 88
		-- upvalues: ArgCheck (copy)
		ArgCheck.isNotNil(p2, "linking")
		ArgCheck.isType(p3, "string", "url")
		p2:openURL(p3)
	end
	local function handleEmailInput(s1: string) -- line: 109
		-- upvalues: v58 (copy), isStringEmail (copy), v56 (copy), v60 (copy), v54 (copy)
		v58(s1)

		if isStringEmail(s1) then
			v56(true)
			v60("")

			return
		end

		v56(false)

		if s1 == "" then
			v60("")

			return
		end

		v60(v54.errorText)
	end

	local v64, v65 = React.useState(0)
	local onRetryAmp = t1.onRetryAmp

	local function onRetryVPC() -- line: 127
		-- upvalues: v65 (copy), v64 (copy), v51 (copy), v49 (copy), v58 (copy), isStringEmail (copy), v56 (copy), v60 (copy), v47 (copy), recourseAction (copy), ActionTypeEnum (copy), VPCStepEnum (copy)
		v65(v64 + 1)
		v51({})
		v49("Unknown")
		v58("")

		if isStringEmail("") then
			v56(true)
			v60("")
		else
			v56(false)
			v60("")
		end

		v47(if recourseAction ~= ActionTypeEnum.ParentLink then VPCStepEnum.AlreadyLinkedSendRequest else VPCStepEnum.NewParentCollectEmail)
	end
	local function getLinkedParentEmailsAndSendRequestToAllParents() -- line: 139
		-- upvalues: v35 (copy), v43 (copy), v51 (copy), parentConsentTypes (copy), recourseData (copy), v47 (copy), VPCStepEnum (copy), v49 (copy)
		v35.getLinkedParentEmails(v43):andThen(function(p4) -- line: 142
			-- upvalues: v51 (copy)
			v51(p4.parentEmails)
		end):catch(function(_) -- line: 145
		end)
		v35.sendRequestToAllParents(v43, parentConsentTypes, recourseData):andThen(function(_) -- line: 149
			-- upvalues: v47 (copy), VPCStepEnum (copy)
			v47(VPCStepEnum.RequestSent)
		end):catch(function(p7) -- line: 152
			-- upvalues: v49 (copy), v47 (copy), VPCStepEnum (copy)
			v49(p7.code)
			v47(VPCStepEnum.Error)
		end)
	end
	local function sendRequestToNewParent(p8) -- line: 158
		-- upvalues: v35 (copy), v43 (copy), parentConsentTypes (copy), recourseData (copy), v47 (copy), VPCStepEnum (copy), v49 (copy)
		v35.sendRequestToNewParent(v43, p8, parentConsentTypes, recourseData):andThen(function(_) -- line: 161
			-- upvalues: v47 (copy), VPCStepEnum (copy)
			v47(VPCStepEnum.RequestSent)
		end):catch(function(p10) -- line: 164
			-- upvalues: v49 (copy), v47 (copy), VPCStepEnum (copy)
			v49(p10.code)
			v47(VPCStepEnum.Error)
		end)
	end
	local function getIsChildSubjectToParentalControls() -- line: 170
		-- upvalues: v36 (copy), AccessResponseEnum (copy), v53 (copy), v47 (copy), VPCStepEnum (copy)
		local v78 = v36.getFeatureAccess({ "IsChildSubjectToParentalControls" })
		local v79 = true

		if v78.featureAccessList and v78.featureAccessList[1] then
			v79 = v78.featureAccessList[1].access ~= AccessResponseEnum.Denied
		end

		v53(v79)
		v47(VPCStepEnum.NewParentCollectEmail)
	end

	React.useEffect(function() -- line: 180
		-- upvalues: recourseAction (copy), ActionTypeEnum (copy), getLinkedParentEmailsAndSendRequestToAllParents (copy), getIsChildSubjectToParentalControls (copy)
		if recourseAction == ActionTypeEnum.ParentConsent then
			getLinkedParentEmailsAndSendRequestToAllParents()

			return
		end

		if recourseAction == ActionTypeEnum.ParentLink then
			getIsChildSubjectToParentalControls()
		end
	end, { v64 })

	if v46 == VPCStepEnum.RequestSent then
		authMsgShown(v39, "", vpcEventConstants.confirmationPageLoadField, "")

		return React.createElement(VPCConfirmationScreen, {
			messageStrings = vpcConfirmationScreenStrings,
			parentEmails = v50,
			onAck = function() -- line: 193
				-- upvalues: authButtonClick (copy), v39 (copy), vpcEventConstants (copy), onSuccess (copy)
				authButtonClick(v39, vpcEventConstants.confirmationPageButton)
				onSuccess()
			end,
			disablePortal = v41,
			isInExperienceEntry = v42
		})
	end

	if v46 == VPCStepEnum.NewParentCollectEmail then
		authMsgShown(v39, "", vpcEventConstants.collectEmailPageLoadField, "")

		return React.createElement(VPCNewParentUpsell, {
			onCancel = onCancel,
			onCollectEmailAndSendRequest = function(p11) -- line: 204
				-- upvalues: authButtonClick (copy), v39 (copy), vpcEventConstants (copy), v51 (copy), v47 (copy), VPCStepEnum (copy), sendRequestToNewParent (copy)
				authButtonClick(v39, vpcEventConstants.collectEmailPageSubmitButton)
				v51({ p11 })
				v47(VPCStepEnum.NewParentSendRequest)
				sendRequestToNewParent(p11)
			end,
			onTextChange = function(p12) -- line: 210
				-- upvalues: authFormInteraction (copy), v39 (copy), vpcEventConstants (copy), handleEmailInput (copy)
				authFormInteraction(v39, vpcEventConstants.collectEmailPageInteractFormField)
				handleEmailInput(p12)
			end,
			canSendRequest = v55,
			textInput = v57,
			openPrivacyPolicyLink = function() -- line: 95
				-- upvalues: GetFFlagEnableExternalBrowserForVPCPrivacyPolicy (copy), u44 (ref), u45 (ref), GetFStringPrivacyPolicyLink (copy), ArgCheck (copy), v61 (copy), AppScreens (copy), v54 (copy)
				if GetFFlagEnableExternalBrowserForVPCPrivacyPolicy() and u44 then
					local v74 = u45
					local v75 = GetFStringPrivacyPolicyLink()

					ArgCheck.isNotNil(v74, "linking")
					ArgCheck.isType(v75, "string", "url")
					v74:openURL(v75)

					return
				end

				v61.navigate(AppScreens.GenericWebPage, {
					detail = GetFStringPrivacyPolicyLink(),
					extraProps = {
						transitionAnimation = "SlideInFromBottom",
						title = v54.privacyLinkText
					}
				})
			end,
			errorText = v59,
			messageStrings = vpcUpsellGatherEmailStrings,
			isChildSubjectToParentalControls = v52,
			disablePortal = v41,
			isInExperienceEntry = v42
		})
	end

	if v46 == VPCStepEnum.AlreadyLinkedSendRequest then
		return nil
	end

	if v46 == VPCStepEnum.NewParentSendRequest then
		return nil
	end

	if v46 == VPCStepEnum.NewParentLoading then
		return nil
	end

	authMsgShown(v39, "", vpcEventConstants.errorPageLoadField, v48)

	return React.createElement(VPCErrorScreen, {
		errorCode = v48,
		onRetryAmp = function() -- line: 233
			-- upvalues: authButtonClick (copy), v39 (copy), vpcEventConstants (copy), onRetryAmp (copy)
			authButtonClick(v39, vpcEventConstants.errorPageRetryButton)
			onRetryAmp()
		end,
		onRetryVPC = function() -- line: 237
			-- upvalues: authButtonClick (copy), v39 (copy), vpcEventConstants (copy), onRetryVPC (copy)
			authButtonClick(v39, vpcEventConstants.errorPageRetryButton)
			onRetryVPC()
		end,
		onCancel = function() -- line: 241
			-- upvalues: authButtonClick (copy), v39 (copy), vpcEventConstants (copy), onCancel (copy)
			authButtonClick(v39, vpcEventConstants.errorPageCancelButton)
			onCancel()
		end,
		onSuccess = function() -- line: 245
			-- upvalues: authButtonClick (copy), v39 (copy), vpcEventConstants (copy), onSuccess (copy)
			authButtonClick(v39, vpcEventConstants.confirmationPageButton)
			onSuccess()
		end,
		retryNum = v64,
		disablePortal = v41,
		isInExperienceEntry = v42
	})
end

return VPCUpsellContainer
