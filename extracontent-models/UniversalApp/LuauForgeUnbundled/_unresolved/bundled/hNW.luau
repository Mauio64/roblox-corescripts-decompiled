local AppStorageService = game:GetService("AppStorageService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/hNw")
local module2 = require("@luauforge/bundled/hNT")
local module3 = require("@luauforge/bundled/hNA")
local module4 = require("@luauforge/bundled/hNX")

local module5 = require("@luauforge/bundled/hNz")
local signUp = module5.Thunks.SignUp
local signUpV2ErrorCodes = module5.Enums.SignUpV2ErrorCodes

local module6 = require("@luauforge/bundled/hNO")
local roactNetworking = module6.RoactNetworking
local appGuiService = module6.AppGuiService
local roactAnalytics = module6.RoactAnalytics

local useAppPolicy = require("@luauforge/bundled/hNN").useAppPolicy
local useRoactService = require("@luauforge/bundled/hNL").useRoactService
local useDispatch = require("@luauforge/bundled/hNK").Hooks.RoactRodux.useDispatch
local useLocalization = require("@luauforge/bundled/hNC").Hooks.useLocalization
local useDesignTokens = require("@luauforge/bundled/hND").useDesignTokens
local module7 = require("@luauforge/bundled/hNM")

local fetchSignupUserAgreements = require("@luauforge/bundled/hNY").FetchSignupUserAgreements
local openAccountSwitchingErrorOverlay = require("@luauforge/bundled/hNZ").OpenAccountSwitchingErrorOverlay
local closeCentralOverlay = require("@luauforge/bundled/hOa").Thunks.CloseCentralOverlay

local setCurrentToastMessage = require("@luauforge/bundled/hOb").Actions.SetCurrentToastMessage
local toastType = require("@luauforge/bundled/hOb").Enums.ToastType

local module8 = require("@luauforge/bundled/hNy")
local disclaimerLinks = module8.Components.DisclaimerLinks
local logoutAllLoggedInUsers = module8.Thunks.LogoutAllLoggedInUsers
local appStorageUtilities = module8.Utils.AppStorageUtilities
local user = module8.Thunks.User
local authLocalStorageKeys = module8.Enums.AuthLocalStorageKeys
local accountSwitcherConstants = module8.Common.AccountSwitcherConstants
local fetchAndStoreUserAppLaunchInfo = module8.Thunks.FetchAndStoreUserAppLaunchInfo
local logoutReasonNames = module8.Enums.LogoutReasonNames

local module9 = require("@luauforge/bundled/hMJ")
local fullPageActivationFrameworkContext = module9.Context.FullPageActivationFrameworkContext
local activationFrameworkWrapper = module9.Components.ActivationFrameworkWrapper
local payloadKey = module9.Enums.PayloadKey
local callbackStatus = module9.Enums.CallbackStatus
local useAttemptNextNavigation = module9.Hooks.useAttemptNextNavigation

local buttonType = module3.App.Button.Enum.ButtonType
local button = module3.App.Button.Button

local module10 = require("@luauforge/bundled/hOc")

local module11 = require("@luauforge/bundled/hNH")
local module12 = require("@luauforge/bundled/hNG")
local eventStreamConstants = module11.EventStreamConstants
local authClientError = module11.Events.authClientError
local authButtonClick = module11.Events.authButtonClick
local authMsgShown = module11.Events.authMsgShown

local module13 = require("@luauforge/bundled/hNE")

local getFFlagEnableMultiPageSignupV2Updates = module13.GetFFlagEnableMultiPageSignupV2Updates

local fFlagEnableMultipageSignupNonInteractiveUserAgreementsPage = module13.FFlagEnableMultipageSignupNonInteractiveUserAgreementsPage
local fFlagAddReasonToEveryLogout = module13.FFlagAddReasonToEveryLogout

local v5 = { Male = "Male", Female = "Female", Unknown = "Unknown" }

return function(p2)
	local v6 = useRoactService(roactNetworking)
	local v7 = useDesignTokens()
	local v8 = module.useContext(fullPageActivationFrameworkContext)
	local activationFrameworkState = v8.activationFrameworkState
	local state, setState = module.useState("Unknown")
	local v9 = module7()
	local state2, setState2 = module.useState(false)
	local v10 = useAttemptNextNavigation(p2.navigation)

	local monoDeps = v8.monoDeps

	local resetAppState = monoDeps.ResetAppState
	local logout = monoDeps.Logout

	local v11 = useDispatch()

	local v12 = useRoactService(roactAnalytics)
	local v13 = useRoactService(appGuiService)
	local v14 = useAppPolicy(function(p3)
		return p3
	end)

	local function fn()
		return v11(closeCentralOverlay())
	end

	local function fn2()
		local accountBlob = appStorageUtilities.getAccountBlob()
		local v15 = user.fromLocalStorage().userId ~= -1
		logoutAllLoggedInUsers(v6, accountBlob):await()

		if v15 == true then
			v11(resetAppState())
			module2.resolve()

			AppStorageService:SetItem(authLocalStorageKeys.CredentialValue, "")
			AppStorageService:Flush()

			if fFlagAddReasonToEveryLogout then
				v11(logout(v6, GuiService, logoutReasonNames.MultiStepSignupAccountSwitchNotAllowed))
			else
				v11(logout(v6, GuiService, nil))
			end
		end

		v11(closeCentralOverlay())
	end

	local v15 = (tonumber(activationFrameworkState.payloadTable[payloadKey.SignupAge]) or 100) < 13

	local v16 = useLocalization({
		genderMale = "Authentication.SignUp.Label.GenderMale",
		genderFemale = "Authentication.SignUp.Label.GenderFemale",
		genderBoy = "Authentication.SignUp.Labely.Boy",
		genderGirl = "Authentication.SignUp.Label.Girl"
	})

	local function useButtonStates()
		local state3, setState3 = module.useState(buttonType.Secondary)
		local state4, setState4 = module.useState(buttonType.Secondary)
		local state5, setState5 = module.useState(buttonType.Secondary)

		local function changeButtonState(state6, setState6)
			setState3(buttonType.Secondary)
			setState4(buttonType.Secondary)
			setState5(buttonType.Secondary)

			if state6 == buttonType.Secondary then
				setState6(buttonType.PrimarySystem)
				return
			end

			setState6(buttonType.Secondary)
			setState("Unknown")
		end

		return {
			maleButtonState = state3,
			femaleButtonState = state4,
			preferNotToSayButtonState = state5,
			changeMaleButtonState = function()
				setState("Male")
				changeButtonState(state3, setState3)
			end,
			changeFemaleButtonState = function()
				setState("Female")
				changeButtonState(state4, setState4)
			end,
			changePreferNotToSayButtonState = function()
				setState("Unknown")
				changeButtonState(state5, setState5)
			end
		}
	end

	local v17 = useButtonStates()

	local v18 = {
		buttonTextKey = "",
		shouldShowButton = false,
		isButtonEnabled = false,
		onButtonClicked = function()
			return { payloadAddendum = nil, status = callbackStatus.NeedsReset }
		end
	}

	local createElement = module.createElement
	local v20 = {
		namespace = p2.namespace,
		titleTextKey = "Authentication.SignUp.Header.GenderPage6",
		bodyTextKey = "Authentication.SignUp.Description.GenderHelp2",
		headingTextKey = "Authentication.SignUp.Action.CreateAccount",
		primaryButton = {
			buttonTextKey = getFFlagEnableMultiPageSignupV2Updates() and "CommonUI.Controls.Action.Done" or "Authentication.SignUp.Action.CreateAccount",
			shouldShowButton = true,
			isButtonEnabled = true,
			onButtonClicked = function()
				local v21 = activationFrameworkState.payloadTable[payloadKey.SignupAgreedUserAgreements]
				local v22

				if fFlagEnableMultipageSignupNonInteractiveUserAgreementsPage and v21 and #v21 > 0 then
					v22 = HttpService:JSONDecode(v21)
				else
					local v23
					v23, v22 = fetchSignupUserAgreements(v6, v12):andThen(function(p3)
						return module4.List.map(p3, function(p4)
							return p4.id
						end)
					end):await()
				end

				local v25, v26 = signUp(v6, nil, v13, v12, v14, {
					username = activationFrameworkState.payloadTable[payloadKey.SignupUsername],
					birthday = activationFrameworkState.payloadTable[payloadKey.SignupBirthdayTimestampUtc],
					password = activationFrameworkState.payloadTable[payloadKey.SignupPassword],
					gender = state,
					agreementIds = v22,
					passkeySessionId = activationFrameworkState.payloadTable[payloadKey.SignupPasskeySessionId],
					passkeyRegistrationResponse = activationFrameworkState.payloadTable[payloadKey.SignupPasskeyResult]
				}, activationFrameworkState.payloadTable[payloadKey.CredentialsProtocolPasswordRegistrationAvailable] == "true"):andThen(function(p3)
					appStorageUtilities.setAccountBlob(p3.responseBody.accountBlob)
					appStorageUtilities.setDiscoveryClientFallbackCache("")
					appStorageUtilities.flush()

					user.clearLocalStorage()

					if not fetchAndStoreUserAppLaunchInfo(v6) then
						authClientError(p2.namespace, eventStreamConstants.State.FetchUserInfoError)

						return { status = callbackStatus.PageError }
					end

					return {
						payloadAddendum = { [payloadKey.SignupGender] = state },
						status = callbackStatus.Success
					}
				end, function(p3)
					if p3 == signUpV2ErrorCodes.PasskeyRegistrationFailed then
						setState2(true)

						return { status = callbackStatus.PageError }
					end

					if
						p3 == signUpV2ErrorCodes.EmptyAccountSwitchBlobRequired
						or p3 == signUpV2ErrorCodes.ParentEmptyAccountSwitchBlobRequired
					then
						local v29

						if p3 == signUpV2ErrorCodes.EmptyAccountSwitchBlobRequired then
							v29 = accountSwitcherConstants.AccountSwitcherLoginEmptyBlobRequiredError
						else
							v29 = accountSwitcherConstants.AccountSwitcherParentLoginEmptyBlobRequiredError
						end

						local v30 = activationFrameworkState.payloadTable[payloadKey.SignupUsername]
						authMsgShown(
							p2.namespace,
							activationFrameworkState.currentState,
							eventStreamConstants.Field.AccountSwitchingErrorModalShown,
							v29
						)

						v11(openAccountSwitchingErrorOverlay(
							"Authentication.AccountSwitch.Header.SignOutOtherAccounts",
							"Authentication.AccountSwitch.Description.ContinueSignOutOthers",
							"Authentication.AccountSwitch.Action.Continue",
							"Authentication.CrossDevice.Action.CancelLogin",
							fn2,
							fn,
							v29,
							v30
						))

						return { status = callbackStatus.PageError }
					else
						authClientError(
							p2.namespace,
							eventStreamConstants.State.GenericSignupError .. "," .. tostring(p3)
						)

						local v27 = p3 == signUpV2ErrorCodes.UnavailableInRegion
							and "Authentication.SignUp.Description.RobloxNotAvailableInRegion"
							or "Authentication.Login.Response.SomethingWentWrong"

						v11(setCurrentToastMessage({
							toastType = toastType.NetworkingError,
							toastMessage = v27,
							toastIconColorStyle = {
								Color = v7.Color.System.Alert.Color3,
								Transparency = 0
							},
							slideIn = true
						}))

						return { status = callbackStatus.PageError }
					end
				end):await()

				if v25 and v26 then
					return v26
				end

				return { status = callbackStatus.PageError }
			end
		},
		navigation = p2.navigation,
		shouldExpandMiddleContent = true,
		subFooterContent = 0
	}

	local createElement2 = module.createElement
	local v22 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v23 = {
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			FillDirection = Enum.FillDirection.Vertical
		}),
		DisclaimerLinks = 0
	}

	local v24 = if v9 then module.createElement(disclaimerLinks, {
		ctx = p2.namespace,
		state = activationFrameworkState.currentState
	}) else nil
	v23.DisclaimerLinks = v24
	v20.subFooterContent = createElement2("Frame", v22, v23)

	local createElement3 = module.createElement
	local v27 = { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) }
	local children = {
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v7.Size.Size_400)
		}),
		MaleButton = 0,
		FemaleButton = 0
	}

	local createElement4 = module.createElement
	local v29 = {
		buttonType = v17.maleButtonState,
		layoutOrder = 2,
		size = UDim2.new(1, 0, 0, v7.Size.Size_1200),
		text = 0,
		onActivated = 0
	}
	local v30 = if getFFlagEnableMultiPageSignupV2Updates() and v15 then v16.genderBoy else v16.genderMale
	v29.text = v30

	function v29.onActivated()
		authButtonClick(
			module12.ctx.multiPageSignup,
			module12.btn.male,
			module12.state.selectGenderComponent
		)

		v17.changeMaleButtonState()
	end

	children.MaleButton = createElement4(button, v29)

	local createElement5 = module.createElement
	local v32 = {
		buttonType = v17.femaleButtonState,
		layoutOrder = 3,
		size = UDim2.new(1, 0, 0, v7.Size.Size_1200),
		text = 0,
		onActivated = 0
	}
	local v33 = if getFFlagEnableMultiPageSignupV2Updates() and v15 then v16.genderGirl else v16.genderFemale
	v32.text = v33

	function v32.onActivated()
		authButtonClick(
			module12.ctx.multiPageSignup,
			module12.btn.female,
			module12.state.selectGenderComponent
		)

		v17.changeFemaleButtonState()
	end

	children.FemaleButton = createElement5(button, v32)
	return createElement(activationFrameworkWrapper, v20, {
		Content = createElement3("Frame", v27, children),
		ErrorToastContainer = state2 and module.createElement(module10, {
			onActivated = function()
				setState2(false)
				v10(v18)
			end
		})
	})
end
