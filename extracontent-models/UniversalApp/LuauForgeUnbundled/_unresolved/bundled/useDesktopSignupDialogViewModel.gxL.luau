local AppStorageService = game:GetService("AppStorageService")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local React = require(CorePackages.Packages.React)
local Promise = require(CorePackages.Packages.Promise)

require("@luauforge/bundled/gvU")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local localStorageKey = require("@luauforge/bundled/dFv").Enums.LocalStorageKey
local robloxLocaleIdKey = require("@game/CorePackages/Workspace/Packages/Localization").RobloxLocaleIdKey
local roactRodux = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux
local useDispatch = roactRodux.useDispatch
local useSelector = roactRodux.useSelector

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local module3 = require("@luauforge/bundled/gxM")
local module4 = require("@luauforge/bundled/eie")
local module5 = require("@luauforge/bundled/egx")
local module6 = require("@luauforge/bundled/ecq")
local module7 = require("@luauforge/bundled/grb")
local module8 = require("@luauforge/bundled/fzS")
local module9 = require("@luauforge/bundled/dzD")
local module10 = require("@luauforge/bundled/ehl")
local module11 = require("@luauforge/bundled/gxO")
local module12 = require("@luauforge/bundled/grJ")
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local module14 = require("@luauforge/bundled/gfG")
local module15 = require("@luauforge/bundled/gut")
local module16 = require("@luauforge/bundled/gxP")
local module17 = require("@luauforge/bundled/ggs")
local module18 = require("@luauforge/bundled/ggi")
local module19 = require("@luauforge/bundled/fCM")
local module20 = require("@luauforge/bundled/ehm")
local module21 = require("@luauforge/bundled/gvP")
local module22 = require("@luauforge/bundled/gxQ")
local module23 = require("@luauforge/bundled/gxR")
local module24 = require("@luauforge/bundled/gxS")
local module25 = require("@luauforge/bundled/gxW")

local module26 = require("@luauforge/bundled/ghR")
local module27 = require("@luauforge/bundled/guM")

local module28 = require("@luauforge/bundled/gxX")

local getFFlagEnableAuditForSinglePageSignUp = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAuditForSinglePageSignUp

local accountLinkingAlertType = AuthCommon.Enums.AccountLinkingAlertType
local preAuthDeepLinkUrlStore = AuthCommon.Stores.PreAuthDeepLinkUrlStore
local useOpenDisclaimerLinks = AuthCommon.Hooks.useOpenDisclaimerLinks
local auditContentContext = AuthCommon.Stores.AuditContentContext.AuditContentContext
local getLinkedPlatformAccountName = AuthCommon.Utils.getLinkedPlatformAccountName

local singlePageSignUpScreen = module8.Context.SinglePageSignUpScreen
local desktopSignupDialog = module8.Origin.DesktopSignupDialog
local v5 = if module27 then desktopSignupDialog else nil
local v6 = {
	[module11.InvalidPassword] = "Authentication.SignUp.Response.PasswordComplexity"
}

local v7 = {
	[module11.EmptyAccountSwitchBlobRequired] = module9.Auth.AccountSwitcherSignupEmptyBlobRequiredError,
	[module11.ParentEmptyAccountSwitchBlobRequired] = module9.Auth.AccountSwitcherParentSignupEmptyBlobRequiredError
}

local v8 = {
	[module11.AccountLinkingRequired] = accountLinkingAlertType.RetryLogInAlreadyLinked,
	[module11.AccountLinkingFailed] = accountLinkingAlertType.RetryLogInGenericError
}

local v9 = {
	BirthdayFocused = module8.Field.Birthday,
	UsernameFocused = module8.Field.Username,
	PasswordFocused = module8.Field.Password
}

local v10 = {
	PasswordShown = module8.Button.ShowPassword,
	PasswordHidden = module8.Button.HidePassword,
	GenderFemaleActivated = module8.Button.GenderFemale,
	GenderMaleActivated = module8.Button.GenderMale
}

local function getAppPolicy(p2)
	return p2
end

local function getAgreementIds(items)
	local ids = {}

	for k, item in items do
		table.insert(ids, item.id)
	end

	return ids
end

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function useDesktopSignupDialogViewModel(data)
	local onClose = data.onClose
	local usesKoreaKISAAgreements = data.usesKoreaKISAAgreements == true
	local shouldSkipVPCSignupFlow = data.shouldSkipVPCSignupFlow == true
	local v11 = useDispatch()
	local v12 = useSelector(selectScreenSize)
	local v13 = module4(module5)
	local v14 = module4(module6)
	local v15 = module4(module7)
	local v16 = module4(appGuiService)
	local v17 = useAppPolicy(getAppPolicy)
	local v18 = module3({})[robloxLocaleIdKey]
	local v20 = { ctx = singlePageSignUpScreen, state = 0, origin = 0 }

	local v21 = if module28 then preAuthDeepLinkUrlStore.getUrl() or desktopSignupDialog else nil
	v20.state = v21
	v20.origin = if module28 then desktopSignupDialog else nil
	local v23 = useOpenDisclaimerLinks(v20)

	local v24 = auditContentContext.useAuditContentContext()
	local capturedAuditContent = v24.capturedAuditContent
	local additionalAuditContent = v24.additionalAuditContent

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local ref = React.useRef({})
	local ref2 = React.useRef(nil)

	local ref3 = React.useRef(true)

	React.useEffect(function()
		ref3.current = true
		return function()
			ref3.current = false
		end
	end, {})

	React.useEffect(function()
		v15.reportScreenLoaded(singlePageSignUpScreen)

		local v25 = preAuthDeepLinkUrlStore.getUrl()

		if module28 then
			v25 = v25 or desktopSignupDialog
		end

		local v26 = if module28 then desktopSignupDialog else v5
		module22(v13):andThen(function(p2)
			if p2 and p2.IsAltBrowserTracker ~= nil then
				ref2.current = p2.IsAltBrowserTracker
				v15.reportAuthPageload(singlePageSignUpScreen, v25, ref2.current, v26)
			elseif module28 then
				ref2.current = false
				v15.reportAuthPageload(singlePageSignUpScreen, v25, ref2.current, v26)
			end
		end, function()
			v15.reportAuthPageload(singlePageSignUpScreen, v25, ref2.current, v26)
		end)

		if v17.getAddUserAgreementIdsToSignupRequest() or usesKoreaKISAAgreements then
			module21(v13, v14):andThen(function(current)
				if current then
					ref.current = current
				end
			end, function() end)
		end
	end, {})

	local v25 = React.useCallback(function(): boolean
		local v26 = Models.fromLocalStorage().userId ~= -1
		module16(v13, module14.getAccountBlob()):await()

		if v26 then
			v11(module17())
			AppStorageService:SetItem(localStorageKey.CredentialValue, "")
			AppStorageService:Flush()
			v11(module18(v13, GuiService))
		end

		v11(module19())
		return not v26
	end, { v13, v11 })

	local v26 = React.useCallback(function(p2, p3, callback, callback2)
		local flag = false
		v11(module15(
			"Authentication.AccountSwitch.Header.SignOutOtherAccounts",
			"Authentication.AccountSwitch.Description.ContinueSignOutOthers",
			"Authentication.AccountSwitch.Action.Continue",
			"Authentication.CrossDevice.Action.CancelLogin",
			function()
				if flag then
					return
				end

				flag = true

				if v25() then
					callback()
				end
			end,
			function()
				v11(module19())
				callback2()
			end,
			p2,
			p3,
			nil,
			true
		))
	end, { v11, v25 })

	local v27 = React.useCallback(function(p2)
		local v28 = if p2 ~= nil then v8[p2] else nil

		if v28 == nil then
			local v30 = if p2 ~= nil then v6[p2] else nil
			return {
				errorCode = p2,
				errorTextKey = v30 or "Feature.Reauthentication.Message.Error.Default"
			}
		end

		onClose()
		v11(module20(module10.AccountLinkingAlert, { alertType = v28 }))

		return { errorCode = p2, isHandled = true }
	end, { v11, onClose })

	local v28 = React.useCallback(function(p2)
		if ref3.current then
			setState2(p2)
		end
	end, {})

	local v29 = React.useCallback(function(data2)
		v15.reportSignUpButtonClicked(singlePageSignUpScreen)
		local url = preAuthDeepLinkUrlStore.getUrl()
		module23(v13, url):andThen(function(p2)
			v15.reportAuthButtonClick(
				singlePageSignUpScreen,
				module8.Button.SignUp,
				p2,
				url,
				ref2.current,
				desktopSignupDialog
			)
		end)

		local v30 = {
			birthday = data2.birthday,
			username = data2.username,
			password = data2.password,
			gender = data2.gender,
			locale = v18
		}

		if v17.getAddUserAgreementIdsToSignupRequest() and #ref.current > 0 then
			local ids = {}

			for k, v31 in ref.current do
				table.insert(ids, v31.id)
			end

			v30.agreementIds = ids
		end

		if getFFlagEnableAuditForSinglePageSignUp() then
			v30.capturedAuditContent = capturedAuditContent
			v30.additionalAuditContent = additionalAuditContent
		end

		return Promise.new(function(p2, callback)
			local v31 = false
			local fn
			local function onCaptchaFinished(p3, p4)
				if p3 then
					fn(p4)
					return
				end

				v31 = true

				if not ref3.current then
					return
				end

				setState(false)
				callback({ errorCode = module11.Captcha, isHandled = true })
			end

			fn = function(p3)
				if v31 or not ref3.current then
					return
				end

				v11(module12(
					v13,
					nil,
					v16,
					onCaptchaFinished,
					p3,
					v14,
					v17,
					v30,
					false,
					false,
					false,
					false,
					v15,
					false,
					v5
				)):andThen(
					p2,
					function(p4)
						if not ref3.current then
							return
						end

						if p4 == module11.Captcha then
							setState(true)
							return
						end

						setState(false)
						module25(v15, p4)

						local v32 = if p4 ~= nil then v7[p4] else nil

						if module26 and v32 ~= nil then
							v26(v32, data2.username, function()
								fn(nil)
							end, function()
								v31 = true
								callback({ errorCode = p4, isHandled = true })
							end)
						else
							callback(v27(p4))
						end
					end
				)
			end

			if usesKoreaKISAAgreements then
				module24({
					dispatch = v11,
					networking = v13,
					appPolicy = v17,
					agreements = ref.current,
					screenSize = v12,
					shouldSkipVPCSignupFlow = shouldSkipVPCSignupFlow,
					signUpInfo = v30,
					age = data2.age,
					setIsConsentStepActive = v28
				}):andThen(function(p3)
					v30 = p3
					fn(nil)
				end, callback)
			else
				fn(nil)
			end
		end)
	end, {
		additionalAuditContent,
		v14,
		v17,
		v15,
		capturedAuditContent,
		v11,
		v16,
		v27,
		v18,
		v13,
		v26,
		v12,
		v28,
		shouldSkipVPCSignupFlow,
		usesKoreaKISAAgreements
	})

	return {
		isFormHidden = state or state2,
		dismiss = React.useCallback(function()
			local v31 = if module28 then preAuthDeepLinkUrlStore.getUrl() or desktopSignupDialog else nil
			v15.reportAuthButtonClick(
				singlePageSignUpScreen,
				module8.Button.DismissCornerX,
				v31,
				nil,
				ref2.current,
				desktopSignupDialog
			)

			onClose()
		end, { v15, onClose }),
		submit = v29,
		onLegalLinkSelected = React.useCallback(function(p2)
			if p2 == "terms" then
				v23.openTerms()
			else
				v23.openPrivacy()
			end
		end, { v23 }),
		onFieldInteraction = React.useCallback(function(p2)
			local v33 = v10[p2]

			if p2 == "BirthdayFocused" then
				v15.reportFocus(singlePageSignUpScreen, module8.Field.Birthday)
			elseif p2 == "UsernameFocused" then
				v15.reportUsernameFocus(singlePageSignUpScreen)
			elseif p2 == "PasswordFocused" then
				v15.reportPasswordFocus(singlePageSignUpScreen)
			elseif v33 ~= nil then
				v15.reportButtonClicked(singlePageSignUpScreen, v33)
			end

			if not module28 then
				return
			end

			local v34 = v9[p2]

			if v34 ~= nil then
				v15.reportAuthFormInteraction(
					singlePageSignUpScreen,
					v34,
					module8.ActionType.Focus,
					desktopSignupDialog
				)

				return
			end

			if p2 == "BirthdayConfirmed" then
				v33 = module8.Button.ConfirmBirthday
			end

			if v33 ~= nil then
				local v35 = preAuthDeepLinkUrlStore.getUrl() or desktopSignupDialog
				v15.reportAuthButtonClick(
					singlePageSignUpScreen,
					v33,
					v35,
					nil,
					ref2.current,
					desktopSignupDialog
				)
			end
		end, { v15 }),
		linkedPlatformAccountName = getLinkedPlatformAccountName(v17)
	}
end

return useDesktopSignupDialogViewModel
