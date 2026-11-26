local module = require("@luauforge/bundled/gtJ")

local react = module.React
local roactRodux = module.RoactRodux
local useLocalization = module.Localization.Hooks.useLocalization
local foundation = module.Foundation
local sheet = foundation.Sheet
local view = foundation.View
local text = foundation.Text
local buttonVariant = foundation.Enums.ButtonVariant
local inputSize = foundation.Enums.InputSize
local externalIdentitySignInOptions = module.LandingPage.Components.ExternalIdentitySignInOptions
local authCommon = module.AuthCommon
local appPage = module.RobloxAppEnums.AppPage
local navigateDown = module.NavigationRodux.Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = module.SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagLoginV2FullFlowDevOverride = module.SharedFlags.FFlagLoginV2FullFlowDevOverride

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/gun").NavigationCommands else nil

local roactAppExperiment = module.RoactAppExperiment
local fStringLuaLoginRevampIxpLayer = module.SharedFlags.FStringLuaLoginRevampIxpLayer
local getFFlagEnableMultiPageSignup = module.SharedFlags.GetFFlagEnableMultiPageSignup
local appBtidLayers = module.ExperimentLayers.AppBtidLayers

local useModalFocus = module.AccountSwitching.useModalFocus

local module2 = require("@luauforge/bundled/guk")
local module3 = require("@luauforge/bundled/gul")
local fFlagAccountSwitcherFocusNavigation = module.SharedFlags.FFlagAccountSwitcherFocusNavigation
local fFlagEnableAccountSwitchSsoLogin = module.SharedFlags.FFlagEnableAccountSwitchSsoLogin

local fFlagEnableAccountSwitcherExternalIdentityButtons = module.SharedFlags.FFlagEnableAccountSwitcherExternalIdentityButtons

local function AccountSwitchingAddAccount(props)
	local v5 = useLocalization({
		titleText = "Authentication.AccountSwitch.Action.AddAnAccount",
		loginText = "Authentication.AccountSwitch.Action.SignInToExistingAccount",
		signInToAnotherAccountText = fFlagEnableAccountSwitcherExternalIdentityButtons and "Authentication.AccountPicker.Button.SignIntoAnotherAccount" or nil,
		createText = "Authentication.AccountPicker.Button.CreateAccount"
	})

	local state, setState = react.useState(true)

	local v6 = authCommon.Experiments.AuthEntryVariant.Control
	local state2, setState2, state3, setState3, v7, v8, v9, v10

	if fFlagEnableAccountSwitcherExternalIdentityButtons then
		state2, setState2 = react.useState({})

		state3, setState3 = react.useState(nil)
		v7 = react.useRef(nil)
		v8 = react.useRef(true)
		v9 = react.useRef(false)
		v10 = react.useRef({})
		v6 = authCommon.Experiments.useAuthEntryVariant()
	else
		state2 = {}

		v7 = { current = nil }
		v8 = { current = true }

		setState2 = function(p2) end

		v9 = { current = false }

		setState3 = function(p2) end

		v10 = { current = {} }
	end

	local origin = props.origin or module3.ctx.accountSwitcher

	local v11 = fFlagEnableAccountSwitcherExternalIdentityButtons
		and v6 == authCommon.Experiments.AuthEntryVariant.FoundationSso
	local v12 = fFlagEnableAccountSwitcherExternalIdentityButtons and state3 ~= nil
	local v13 = if v11 then #state2 > 0 and props.authenticateWithExternalIdentity ~= nil else v11

	local function cancelActiveExternalIdentityOperation()
		local current = v7.current

		if current ~= nil then
			v7.current = nil
			current.cancel()
		end
	end

	if fFlagEnableAccountSwitcherExternalIdentityButtons then
		react.useEffect(function()
			v8.current = true
			return function()
				v8.current = false
				local current = v7.current

				if current ~= nil then
					v7.current = nil
					current.cancel()
				end
			end
		end, {})

		react.useEffect(function()
			if
				not v11
				or props.getExternalIdentityCapabilities == nil
				or props.authenticateWithExternalIdentity == nil
			then
				setState2({})
				return
			end

			local v14 = false
			local getExternalIdentityCapabilities = props.getExternalIdentityCapabilities
			task.spawn(function()
				local externalIdentityCapabilities = getExternalIdentityCapabilities()

				if v14 or not v8.current then
					return
				end

				local v15 = {}

				if externalIdentityCapabilities and externalIdentityCapabilities.google then
					table.insert(v15, "google")
				end

				if externalIdentityCapabilities and externalIdentityCapabilities.apple then
					table.insert(v15, "apple")
				end

				setState2(v15)
			end)

			return function()
				v14 = true
			end
		end, { v11, props.getExternalIdentityCapabilities, props.authenticateWithExternalIdentity })

		local v14 = table.find(state2, "google") ~= nil
		local v15 = table.find(state2, "apple") ~= nil

		react.useEffect(function()
			if not v13 then
				return
			end

			for k, v16 in state2 do
				if v10.current[v16] then
					continue
				end

				v10.current[v16] = true
				local sendButtonShownEvent = module2.sendButtonShownEvent
				local accountSwitcherAddAccount = module3.ctx.accountSwitcherAddAccount

				local v18 = if v16 == "google" then module3.btn.googleSso else module3.btn.appleSso
				sendButtonShownEvent(accountSwitcherAddAccount, origin, v18, module3.state.visible)
			end
		end, { v13, v14, v15 })
	end

	react.useEffect(function()
		if fFlagEnableAccountSwitcherExternalIdentityButtons then
			module2.sendModalShownEvent(module3.ctx.accountSwitcherAddAccount, origin, module3.state.shown)
		elseif props.origin then
			module2.sendModalShownEvent(module3.ctx.accountSwitcherAddAccount, props.origin)
		end
	end, {})

	local v14 = roactAppExperiment.useBrowserTrackerExperiment(
		{ fStringLuaLoginRevampIxpLayer },
		function(p2)
			local v15 = p2[fStringLuaLoginRevampIxpLayer] or {}

			return {
				showLoginRevamp = fFlagLoginV2FullFlowDevOverride or v15.showLoginRevamp
			}
		end
	)
	local v15

	if fFlagEnableAccountSwitchSsoLogin then
		v15 = authCommon.Experiments.useAuthEntryVariant(nil, false) ~= authCommon.Experiments.AuthEntryVariant.Control
	else
		v15 = false
	end

	local function onClose()
		if fFlagEnableAccountSwitcherExternalIdentityButtons then
			if v9.current then
				return
			end

			v9.current = true
			local current = v7.current

			if current ~= nil then
				v7.current = nil
				current.cancel()
			end

			module2.sendButtonClickEvent(
				module3.ctx.accountSwitcherAddAccount,
				origin,
				module3.btn.dismissSheet,
				module3.state.dismissed
			)
		end

		setState(false)

		if props.onClose then
			props.onClose(true)
		end
	end

	local function fn()
		if fFlagEnableAccountSwitcherExternalIdentityButtons then
			v9.current = true
			local current = v7.current

			if current ~= nil then
				v7.current = nil
				current.cancel()
			end

			module2.sendButtonClickEvent(
				module3.ctx.accountSwitcherAddAccount,
				origin,
				module3.btn.login,
				module3.state.addAccount
			)
		elseif props.origin then
			module2.sendButtonClickEvent(
				module3.ctx.accountSwitcherAddAccount,
				props.origin,
				module3.btn.login
			)
		end

		setState(false)

		if props.onClose then
			props.onClose()
		end

		if props.openDesktopLoginDialog and props.openDesktopLoginDialog() then
			return
		end

		if v14.showLoginRevamp or v15 then
			if props.navigateToLoginV2 then
				props.navigateToLoginV2()
			end
		elseif props.navigateToLogin then
			props.navigateToLogin()
		end
	end

	local function onActivated()
		if fFlagEnableAccountSwitcherExternalIdentityButtons then
			v9.current = true
			local current = v7.current

			if current ~= nil then
				v7.current = nil
				current.cancel()
			end

			module2.sendButtonClickEvent(
				module3.ctx.accountSwitcherAddAccount,
				origin,
				module3.btn.signup,
				module3.state.addAccount
			)
		elseif props.origin then
			module2.sendButtonClickEvent(
				module3.ctx.accountSwitcherAddAccount,
				props.origin,
				module3.btn.signup
			)
		end

		setState(false)

		if props.onClose then
			props.onClose()
		end

		if getFFlagEnableMultiPageSignup() and props.shouldEnableMultiPageSignup then
			if props.navigateToMultiPageSignUp then
				props.navigateToMultiPageSignUp()
			end
		elseif
			(props.openDesktopSignupDialog == nil or not props.openDesktopSignupDialog())
			and props.navigateToSignUp
		then
			props.navigateToSignUp()
		end
	end

	local function onActivated2(p2)
		if props.authenticateWithExternalIdentity == nil then
			return
		end

		local current = v7.current

		if current == nil then
			local sendButtonClickEvent = module2.sendButtonClickEvent
			local accountSwitcherAddAccount = module3.ctx.accountSwitcherAddAccount

			local v17 = if p2 == "google" then module3.btn.googleSso else module3.btn.appleSso
			sendButtonClickEvent(accountSwitcherAddAccount, origin, v17, module3.state.externalIdentity)

			setState3(p2)
			local authenticateWithExternalIdentity = props.authenticateWithExternalIdentity(p2)
			v7.current = authenticateWithExternalIdentity
			authenticateWithExternalIdentity.promise:andThen(function(p3)
				if v7.current ~= authenticateWithExternalIdentity then
					return
				end

				v7.current = nil

				if not v8.current then
					return
				end

				setState3(nil)

				if p3 == nil or p3.status ~= "success" then
					if p3 ~= nil and p3.status == "failed" and props.onExternalIdentityFailed then
						props.onExternalIdentityFailed()
					end
				else
					v9.current = true
					setState(false)

					if props.onClose then
						props.onClose()
					end
				end
			end)
		else
			local current2 = v7.current

			if current2 ~= nil then
				v7.current = nil
				current2.cancel()
			end

			current.promise:andThen(function(p3)
				if v8.current and p3 ~= nil and p3.status ~= "success" and v7.current == nil then
					onActivated2(p2)
				end
			end)
		end
	end

	local v16 = useModalFocus()
	local createElement = react.createElement
	local button = foundation.Button
	local v18 = if v11 then v5.signInToAnotherAccountText else v5.loginText
	local element = createElement(button, {
		text = v18,
		variant = buttonVariant.Standard,
		onActivated = fn,
		isDisabled = if fFlagEnableAccountSwitcherExternalIdentityButtons then v12 else nil,
		tag = "col size-full-0",
		width = UDim.new(1, 0),
		LayoutOrder = v13 and 1 or nil
	})

	local element2 = react.createElement(foundation.Button, {
		text = v5.createText,
		variant = buttonVariant.Standard,
		onActivated = onActivated,
		isDisabled = if fFlagEnableAccountSwitcherExternalIdentityButtons then v12 else nil,
		tag = "col size-full-0",
		width = UDim.new(1, 0),
		LayoutOrder = v13 and 2 or nil
	})

	local createElement3 = react.createElement
	local fragment = react.Fragment
	local createElement4 = react.createElement
	local root = sheet.Root

	if not fFlagAccountSwitcherFocusNavigation then
		v16 = nil
	end

	return createElement3(fragment, nil, {
		AddAccountSheet = createElement4(
			root,
			{ onClose = onClose, preferCenterSheet = true, isOpen = state, ref = v16 },
			{
				Header = react.createElement(sheet.Header, nil, {
					Title = react.createElement(text, {
						Text = v5.titleText,
						tag = "auto-xy text-heading-small content-emphasis"
					})
				}),
				StandardButtons = react.createElement(sheet.Content, {
					tag = "col auto-y gap-small"
				}, {
					ActionList = react.createElement(view, {
						tag = v13 and "col gap-medium size-full-0 auto-y padding-bottom-medium" or "col auto-y gap-small size-full-0 padding-bottom-medium"
					}, v13 and {
						PrimaryActions = react.createElement(
							view,
							{
								LayoutOrder = 1,
								tag = "col gap-small size-full-0 auto-y"
							},
							{ LoginButton = element, SignUpButton = element2 }
						),
						ExternalIdentitySignInOptions = react.createElement(externalIdentitySignInOptions, {
							layoutOrder = 2,
							providers = state2,
							size = inputSize.Medium,
							isDisabled = v12,
							onActivated = onActivated2
						})
					} or { LoginButton = element, SignUpButton = element2 })
				})
			}
		)
	})
end

if getFFlagEnableMultiPageSignup() then
	AccountSwitchingAddAccount = roactAppExperiment.connectBrowserTrackerLayer(
		{ appBtidLayers.SignupLayer },
		function(p2, p3)
			return {
				shouldEnableMultiPageSignup = (p2[appBtidLayers.SignupLayer] or {}).shouldEnableMultiPageSignup
			}
		end
	)(AccountSwitchingAddAccount)
end

local v5 = roactRodux.connect(nil, function(callback)
	return {
		navigateToLogin = function()
			local v6 = { name = appPage.Login }

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v6))
			else
				callback(navigateDown(v6))
			end
		end,
		navigateToLoginV2 = function()
			local v6 = { name = appPage.LoginV2 }

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v6))
			else
				callback(navigateDown(v6))
			end
		end,
		navigateToSignUp = function()
			local v6 = { name = appPage.SinglePageSignUp }

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v6))
			else
				callback(navigateDown(v6))
			end
		end,
		navigateToMultiPageSignUp = function()
			local v6 = {
				name = appPage.MultiPageSignup,
				extraProps = { enforceResetState = true }
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v6))
			else
				callback(navigateDown(v6))
			end
		end
	}
end)(AccountSwitchingAddAccount)

return react.memo(v5)
