local MultiPageSignup = script:FindFirstAncestor("MultiPageSignup")
local MultiPageSignupParent = MultiPageSignup.Parent
local AppStorageService = game:GetService("AppStorageService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local React = require(MultiPageSignupParent.React)
local Promise = require(MultiPageSignupParent.Promise)
local UIBlox = require(MultiPageSignupParent.UIBlox)
local Cryo = require(MultiPageSignupParent.Cryo)
local AuthSignup = require(MultiPageSignupParent.AuthSignup)
local SignUp = AuthSignup.Thunks.SignUp
local SignUpV2ErrorCodes = AuthSignup.Enums.SignUpV2ErrorCodes
local RoactServiceTags = require(MultiPageSignupParent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local AppGuiService = RoactServiceTags.AppGuiService
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local useAppPolicy = require(MultiPageSignupParent.UniversalAppPolicy).useAppPolicy
local useRoactService = require(MultiPageSignupParent.RobloxAppHooks).useRoactService
local useDispatch = require(MultiPageSignupParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(MultiPageSignupParent.Localization).Hooks.useLocalization
local useDesignTokens = require(MultiPageSignupParent.Style).useDesignTokens
local useShowDisclaimerLinks = require(MultiPageSignup.Hooks.useShowDisclaimerLinks)
local FetchSignupUserAgreements = require(MultiPageSignupParent.UserAgreements).FetchSignupUserAgreements
local OpenAccountSwitchingErrorOverlay = require(MultiPageSignupParent.AccountSwitcher).OpenAccountSwitchingErrorOverlay
local CloseCentralOverlay = require(MultiPageSignupParent.CentralOverlay).Thunks.CloseCentralOverlay
local SetCurrentToastMessage = require(MultiPageSignupParent.ToastRodux).Actions.SetCurrentToastMessage
local ToastType = require(MultiPageSignupParent.ToastRodux).Enums.ToastType
local AuthCommon = require(MultiPageSignupParent.AuthCommon)
local DisclaimerLinks = AuthCommon.Components.DisclaimerLinks
local LogoutAllLoggedInUsers = AuthCommon.Thunks.LogoutAllLoggedInUsers
local AppStorageUtilities = AuthCommon.Utils.AppStorageUtilities
local User = AuthCommon.Thunks.User
local AuthLocalStorageKeys = AuthCommon.Enums.AuthLocalStorageKeys
local AccountSwitcherConstants = AuthCommon.Common.AccountSwitcherConstants
local FetchAndStoreUserAppLaunchInfo = AuthCommon.Thunks.FetchAndStoreUserAppLaunchInfo
local LogoutReasonNames = AuthCommon.Enums.LogoutReasonNames
local UserActivationFramework = require(MultiPageSignupParent.UserActivationFramework)
local FullPageActivationFrameworkContext = UserActivationFramework.Context.FullPageActivationFrameworkContext
local ActivationFrameworkWrapper = UserActivationFramework.Components.ActivationFrameworkWrapper
local PayloadKey = UserActivationFramework.Enums.PayloadKey
local CallbackStatus = UserActivationFramework.Enums.CallbackStatus
local useAttemptNextNavigation = UserActivationFramework.Hooks.useAttemptNextNavigation
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Button = UIBlox.App.Button.Button
local PasskeyErrorAlert = require(MultiPageSignup.Components.PasskeyErrorAlert)
local AuthAnalytics = require(MultiPageSignupParent.AuthAnalytics)
local MultiPageSignupConstants = require(MultiPageSignup.Analytics.MultiPageSignupConstants)
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local authClientError = AuthAnalytics.Events.authClientError
local authButtonClick = AuthAnalytics.Events.authButtonClick
local authMsgShown = AuthAnalytics.Events.authMsgShown
local SharedFlags = require(MultiPageSignupParent.SharedFlags)
local GetFFlagEnableMultiPageSignupV2Updates = SharedFlags.GetFFlagEnableMultiPageSignupV2Updates
local FFlagEnableMultipageSignupNonInteractiveUserAgreementsPage = SharedFlags.FFlagEnableMultipageSignupNonInteractiveUserAgreementsPage
local FFlagAddReasonToEveryLogout = SharedFlags.FFlagAddReasonToEveryLogout
local GetFFlagEnableAccountSwitcherFoundationDesign = SharedFlags.GetFFlagEnableAccountSwitcherFoundationDesign
local GetFFlagEnableAccountSwitcherRedesignIXP = SharedFlags.GetFFlagEnableAccountSwitcherRedesignIXP
local RoactAppExperiment = require(MultiPageSignupParent.RoactAppExperiment)
local AppBtidLayers = require(MultiPageSignupParent.ExperimentLayers).AppBtidLayers
local _ = {
	Male = "Male",
	Female = "Female",
	Unknown = "Unknown"
}

return function(t1: {[any]: any}) -- line: 90
	-- upvalues: useRoactService (copy), RoactNetworking (copy), useDesignTokens (copy), React (copy), FullPageActivationFrameworkContext (copy), useShowDisclaimerLinks (copy), useAttemptNextNavigation (copy), GetFFlagEnableAccountSwitcherRedesignIXP (copy), RoactAppExperiment (copy), AppBtidLayers (copy), GetFFlagEnableAccountSwitcherFoundationDesign (copy), useDispatch (copy), RoactAnalytics (copy), AppGuiService (copy), useAppPolicy (copy), Promise (copy), LogoutAllLoggedInUsers (copy), CloseCentralOverlay (copy), AppStorageUtilities (copy), User (copy), AppStorageService (copy), AuthLocalStorageKeys (copy), FFlagAddReasonToEveryLogout (copy), GuiService (copy), LogoutReasonNames (copy), authMsgShown (copy), EventStreamConstants (copy), OpenAccountSwitchingErrorOverlay (copy), PayloadKey (copy), SignUp (copy), useLocalization (copy), ButtonType (copy), CallbackStatus (copy), ActivationFrameworkWrapper (copy), GetFFlagEnableMultiPageSignupV2Updates (copy), FFlagEnableMultipageSignupNonInteractiveUserAgreementsPage (copy), HttpService (copy), FetchSignupUserAgreements (copy), Cryo (copy), FetchAndStoreUserAppLaunchInfo (copy), authClientError (copy), SignUpV2ErrorCodes (copy), AccountSwitcherConstants (copy), SetCurrentToastMessage (copy), ToastType (copy), DisclaimerLinks (copy), Button (copy), authButtonClick (copy), MultiPageSignupConstants (copy), PasskeyErrorAlert (copy)
	local v62 = useRoactService(RoactNetworking)
	local v63 = useDesignTokens()
	local v64 = React.useContext(FullPageActivationFrameworkContext)
	local activationFrameworkState = v64.activationFrameworkState
	local v66, v67 = React.useState("Unknown")
	local v68 = useShowDisclaimerLinks()
	local v69, v70 = React.useState(false)
	local v71 = useAttemptNextNavigation(t1.navigation)
	local monoDeps = v64.monoDeps
	local v73 = not GetFFlagEnableAccountSwitcherRedesignIXP() or RoactAppExperiment.useBrowserTrackerExperiment({ AppBtidLayers.AccountSwitcherLayer }, function(p1) -- line: 105
		-- upvalues: AppBtidLayers (copy)
		return (p1[AppBtidLayers.AccountSwitcherLayer] or {}).enableAccountSwitcherFoundationDesign == true
	end)
	local v74 = GetFFlagEnableAccountSwitcherFoundationDesign() and v73
	local ResetAppState = monoDeps.ResetAppState
	local Logout = monoDeps.Logout
	local v77 = useDispatch()
	local v78 = useRoactService(RoactAnalytics)
	local v79 = useRoactService(AppGuiService)
	local v80 = useAppPolicy(function(p2) -- line: 121
		return p2
	end)

	local function v81() -- line: 138
		-- upvalues: v77 (copy), CloseCentralOverlay (copy)
		return v77(CloseCentralOverlay())
	end
	local function v82() -- line: 142
		-- upvalues: AppStorageUtilities (copy), User (copy), v62 (copy), LogoutAllLoggedInUsers (copy), v77 (copy), ResetAppState (copy), Promise (copy), AppStorageService (copy), AuthLocalStorageKeys (copy), FFlagAddReasonToEveryLogout (copy), GuiService (copy), LogoutReasonNames (copy), Logout (copy), CloseCentralOverlay (copy)
		local v95 = AppStorageUtilities.getAccountBlob()
		local v96 = User.fromLocalStorage().userId ~= -1
		local v97 = v62

		LogoutAllLoggedInUsers(v97, v95):await()

		if v96 == true then
			v77(ResetAppState())
			Promise.resolve()
			AppStorageService:SetItem(AuthLocalStorageKeys.CredentialValue, "")
			AppStorageService:Flush()

			if FFlagAddReasonToEveryLogout then
				local v98 = v62
				local v99 = GuiService
				local MultiStepSignupAccountSwitchNotAllowed = LogoutReasonNames.MultiStepSignupAccountSwitchNotAllowed

				v77(Logout(v98, v99, MultiStepSignupAccountSwitchNotAllowed))
			else
				local v101 = v62
				local v102 = GuiService

				v77(Logout(v101, v102, nil))
			end
		end

		v77(CloseCentralOverlay())
	end

	local v83 = (tonumber(activationFrameworkState.payloadTable[PayloadKey.SignupAge]) or 100) < 13
	local v84 = useLocalization({
		genderMale = "Authentication.SignUp.Label.GenderMale",
		genderFemale = "Authentication.SignUp.Label.GenderFemale",
		genderBoy = "Authentication.SignUp.Labely.Boy",
		genderGirl = "Authentication.SignUp.Label.Girl"
	})

	local function useButtonStates() -- line: 222
		-- upvalues: React (copy), ButtonType (copy), v67 (copy)
		local v113, v114 = React.useState(ButtonType.Secondary)
		local v115, v116 = React.useState(ButtonType.Secondary)
		local v117, v118 = React.useState(ButtonType.Secondary)

		local function changeButtonState(p3, p4) -- line: 227
			-- upvalues: v114 (copy), ButtonType (copy), v116 (copy), v118 (copy), v67 (copy)
			v114(ButtonType.Secondary)
			v116(ButtonType.Secondary)
			v118(ButtonType.Secondary)

			if p3 == ButtonType.Secondary then
				p4(ButtonType.PrimarySystem)

				return
			end

			p4(ButtonType.Secondary)
			v67("Unknown")
		end

		return {
			maleButtonState = v113,
			femaleButtonState = v115,
			preferNotToSayButtonState = v117,
			changeMaleButtonState = function() -- line: 246
				-- upvalues: v67 (copy), changeButtonState (copy), v113 (copy), v114 (copy)
				v67("Male")
				changeButtonState(v113, v114)
			end,
			changeFemaleButtonState = function() -- line: 250
				-- upvalues: v67 (copy), changeButtonState (copy), v115 (copy), v116 (copy)
				v67("Female")
				changeButtonState(v115, v116)
			end,
			changePreferNotToSayButtonState = function() -- line: 254
				-- upvalues: v67 (copy), changeButtonState (copy), v117 (copy), v118 (copy)
				v67("Unknown")
				changeButtonState(v117, v118)
			end
		}
	end

	local v86 = useButtonStates()
	local t2 = {
		buttonTextKey = "",
		shouldShowButton = false,
		isButtonEnabled = false,
		onButtonClicked = function() -- line: 270
			-- upvalues: CallbackStatus (copy)
			return {
				payloadAddendum = nil,
				status = CallbackStatus.NeedsReset
			}
		end
	}

	return React.createElement(ActivationFrameworkWrapper, {
		titleTextKey = "Authentication.SignUp.Header.GenderPage6",
		bodyTextKey = "Authentication.SignUp.Description.GenderHelp2",
		headingTextKey = "Authentication.SignUp.Action.CreateAccount",
		shouldExpandMiddleContent = true,
		namespace = t1.namespace,
		primaryButton = {
			shouldShowButton = true,
			isButtonEnabled = true,
			buttonTextKey = not GetFFlagEnableMultiPageSignupV2Updates() and "Authentication.SignUp.Action.CreateAccount" or "CommonUI.Controls.Action.Done",
			onButtonClicked = function() -- line: 286
				-- upvalues: activationFrameworkState (copy), PayloadKey (copy), FFlagEnableMultipageSignupNonInteractiveUserAgreementsPage (copy), HttpService (copy), FetchSignupUserAgreements (copy), v62 (copy), v78 (copy), Cryo (copy), v66 (copy), SignUp (copy), v79 (copy), v80 (copy), AppStorageUtilities (copy), User (copy), FetchAndStoreUserAppLaunchInfo (copy), authClientError (copy), t1 (copy), EventStreamConstants (copy), CallbackStatus (copy), SignUpV2ErrorCodes (copy), v70 (copy), v74 (copy), v82 (copy), v81 (copy), AccountSwitcherConstants (copy), authMsgShown (copy), v77 (copy), OpenAccountSwitchingErrorOverlay (copy), SetCurrentToastMessage (copy), ToastType (copy), v63 (copy)
				local v120 = activationFrameworkState.payloadTable[PayloadKey.SignupAgreedUserAgreements]
				local data

				if FFlagEnableMultipageSignupNonInteractiveUserAgreementsPage and (v120 and #v120 > 0) then
					data = HttpService:JSONDecode(v120)
				else
					local v122

					v122, data = FetchSignupUserAgreements(v62, v78):andThen(function(p5) -- line: 297
						-- upvalues: Cryo (copy)
						return Cryo.List.map(p5, function(p6) -- line: 298
							return p6.id
						end)
					end):await()
				end

				local t3 = {
					username = activationFrameworkState.payloadTable[PayloadKey.SignupUsername],
					birthday = activationFrameworkState.payloadTable[PayloadKey.SignupBirthdayTimestampUtc],
					password = activationFrameworkState.payloadTable[PayloadKey.SignupPassword],
					gender = v66,
					agreementIds = data,
					passkeySessionId = activationFrameworkState.payloadTable[PayloadKey.SignupPasskeySessionId],
					passkeyRegistrationResponse = activationFrameworkState.payloadTable[PayloadKey.SignupPasskeyResult]
				}
				local v124 = activationFrameworkState.payloadTable[PayloadKey.CredentialsProtocolPasswordRegistrationAvailable] == "true"
				local v125, v126 = SignUp(v62, nil, v79, v78, v80, t3, v124):andThen(function(p7) -- line: 315
					-- upvalues: AppStorageUtilities (copy), User (copy), FetchAndStoreUserAppLaunchInfo (copy), v62 (copy), authClientError (copy), t1 (copy), EventStreamConstants (copy), CallbackStatus (copy), PayloadKey (copy), v66 (copy)
					AppStorageUtilities.setAccountBlob(p7.responseBody.accountBlob)
					AppStorageUtilities.setDiscoveryClientFallbackCache("")
					AppStorageUtilities.flush()
					User.clearLocalStorage()

					if not FetchAndStoreUserAppLaunchInfo(v62) then
						authClientError(t1.namespace, EventStreamConstants.State.FetchUserInfoError)

						return {
							status = CallbackStatus.PageError
						}
					end

					return {
						payloadAddendum = {
							[PayloadKey.SignupGender] = v66
						},
						status = CallbackStatus.Success
					}
				end, function(p8) -- line: 336
					-- upvalues: SignUpV2ErrorCodes (copy), v70 (copy), CallbackStatus (copy), v74 (copy), v82 (copy), v81 (copy), AccountSwitcherConstants (copy), activationFrameworkState (copy), PayloadKey (copy), authMsgShown (copy), t1 (copy), EventStreamConstants (copy), v77 (copy), OpenAccountSwitchingErrorOverlay (copy), authClientError (copy), SetCurrentToastMessage (copy), ToastType (copy), v63 (copy)
					if p8 == SignUpV2ErrorCodes.PasskeyRegistrationFailed then
						v70(true)

						return {
							status = CallbackStatus.PageError
						}
					end

					if p8 == SignUpV2ErrorCodes.EmptyAccountSwitchBlobRequired or p8 == SignUpV2ErrorCodes.ParentEmptyAccountSwitchBlobRequired then
						local v132 = not v74 and "Authentication.AccountSwitch.Header.LogoutAllAccounts" or "Authentication.AccountSwitch.Header.SignOutOtherAccounts"
						local v133 = if not v74 then p8 ~= SignUpV2ErrorCodes.EmptyAccountSwitchBlobRequired and "Authentication.AccountSwitch.Description.ParentLogoutConfirmation" or "Authentication.AccountSwitch.Description.LogoutConfirmation" else "Authentication.AccountSwitch.Description.ContinueSignOutOthers"
						local v134 = not v74 and "Authentication.AccountSwitch.Action.LogoutAllAccounts" or "Authentication.AccountSwitch.Action.Continue"
						local v135 = v82
						local v136 = v81
						local v137 = if p8 ~= SignUpV2ErrorCodes.EmptyAccountSwitchBlobRequired then AccountSwitcherConstants.AccountSwitcherParentLoginEmptyBlobRequiredError else AccountSwitcherConstants.AccountSwitcherLoginEmptyBlobRequiredError
						local v138 = activationFrameworkState.payloadTable[PayloadKey.SignupUsername]

						authMsgShown(t1.namespace, activationFrameworkState.currentState, EventStreamConstants.Field.AccountSwitchingErrorModalShown, v137)
						v77(OpenAccountSwitchingErrorOverlay(v132, v133, v134, "Authentication.CrossDevice.Action.CancelLogin", v135, v136, v137, v138))

						return {
							status = CallbackStatus.PageError
						}
					end

					authClientError(t1.namespace, EventStreamConstants.State.GenericSignupError .. "," .. tostring(p8))

					local s1 = "Authentication.Login.Response.SomethingWentWrong"

					if p8 == SignUpV2ErrorCodes.UnavailableInRegion then
						s1 = "Authentication.SignUp.Description.RobloxNotAvailableInRegion"
					end

					v77(SetCurrentToastMessage({
						slideIn = true,
						toastType = ToastType.NetworkingError,
						toastMessage = s1,
						toastIconColorStyle = {
							Transparency = 0,
							Color = v63.Color.System.Alert.Color3
						}
					}))

					return {
						status = CallbackStatus.PageError
					}
				end):await()

				if v125 and v126 then
					return v126
				end

				return {
					status = CallbackStatus.PageError
				}
			end
		},
		navigation = t1.navigation,
		subFooterContent = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				FillDirection = Enum.FillDirection.Vertical
			}),
			DisclaimerLinks = if not v68 then nil else React.createElement(DisclaimerLinks, {
				ctx = t1.namespace,
				state = activationFrameworkState.currentState
			})
		})
	}, {
		Content = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v63.Size.Size_400)
			}),
			MaleButton = React.createElement(Button, {
				layoutOrder = 2,
				buttonType = v86.maleButtonState,
				size = UDim2.new(1, 0, 0, v63.Size.Size_1200),
				text = if not GetFFlagEnableMultiPageSignupV2Updates() or not v83 then v84.genderMale else v84.genderBoy,
				onActivated = function() -- line: 436
					-- upvalues: authButtonClick (copy), MultiPageSignupConstants (copy), v86 (copy)
					authButtonClick(MultiPageSignupConstants.ctx.multiPageSignup, MultiPageSignupConstants.btn.male, MultiPageSignupConstants.state.selectGenderComponent)
					v86.changeMaleButtonState()
				end
			}),
			FemaleButton = React.createElement(Button, {
				layoutOrder = 3,
				buttonType = v86.femaleButtonState,
				size = UDim2.new(1, 0, 0, v63.Size.Size_1200),
				text = if not GetFFlagEnableMultiPageSignupV2Updates() or not v83 then v84.genderFemale else v84.genderGirl,
				onActivated = function() -- line: 453
					-- upvalues: authButtonClick (copy), MultiPageSignupConstants (copy), v86 (copy)
					authButtonClick(MultiPageSignupConstants.ctx.multiPageSignup, MultiPageSignupConstants.btn.female, MultiPageSignupConstants.state.selectGenderComponent)
					v86.changeFemaleButtonState()
				end
			})
		}),
		ErrorToastContainer = v69 and React.createElement(PasskeyErrorAlert, {
			onActivated = function() -- line: 464
				-- upvalues: v70 (copy), v71 (copy), t2 (copy)
				v70(false)
				v71(t2)
			end
		})
	})
end
