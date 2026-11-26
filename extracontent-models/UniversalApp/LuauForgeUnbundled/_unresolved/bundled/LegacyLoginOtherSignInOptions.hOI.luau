local CorePackages = game:GetService("CorePackages")

local UserInputService = game:GetService("UserInputService")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize

local module = require("@luauforge/bundled/fzT")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local module3 = require("@luauforge/bundled/guy")
local handleNewAuthCompletion = require("@luauforge/bundled/ghc").HandleNewAuthCompletion
local appStorageUtilities = AuthCommon.Utils.AppStorageUtilities
local user = AuthCommon.Thunks.User
local module4 = require("@luauforge/bundled/gjC")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local appLogging = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLogging

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local module6 = require("@luauforge/bundled/eie")
local module7 = require("@luauforge/bundled/egx")
local module8 = require("@luauforge/bundled/ecq")
local module9 = require("@luauforge/bundled/ggs")
local module10 = require("@luauforge/bundled/guT")
local module11 = require("@luauforge/bundled/egt")
local module12 = require("@luauforge/bundled/guz")

local module13 = require("@luauforge/bundled/ghR")
local module14 = require("@luauforge/bundled/fGg")

local module15 = require("@luauforge/bundled/hOJ")

local fFlagLandingAndAccountPickerSsoTelemetry = require("@luauforge/bundled/gru").Flags.FFlagLandingAndAccountPickerSsoTelemetry

local fFlagEnableAccountSwitchSsoLogin = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAccountSwitchSsoLogin

local eventStreamConstants = module.EventStreamConstants

local function getAppPolicy(p2)
	return p2
end

local function isPlatformSupported(p2)
	if p2 == Enum.Platform.IOS or p2 == Enum.Platform.Android then
		return module15
	end

	return module3.isDesktopBrowserSignInEnabled(p2)
end

local function LegacyLoginOtherSignInOptions(p2)
	local v5 = useDesignTokens()
	local v6 = useDispatch()
	local networking = module6(module7)
	local v7 = module6(module8)
	local v8 = module6(appLogging)
	local v9 = useAppPolicy(getAppPolicy)

	local v10 = v9.getExcludeExternalIdentityOtherSignInOptions()

	if not v10 then
		local platform = p2.platform or UserInputService:GetPlatform()
		v10 = not (if platform == Enum.Platform.IOS or platform == Enum.Platform.Android then module15 else module3.isDesktopBrowserSignInEnabled(platform))
	end

	local function acquireClient()
		return module12.acquire({
			getNetworking = function()
				return networking
			end,
			isBrowserSignInEnabled = module3.isDesktopBrowserSignInEnabled,
			completeSession = function()
				local v11 = user.fromLocalStorage()

				local v12 = if fFlagEnableAccountSwitchSsoLogin then appStorageUtilities.getAccountBlob() else nil

				if
					not fFlagEnableAccountSwitchSsoLogin
					or not module13
					or v11.userId == -1
					or v12 == nil
					or v12 == ""
				then
					return v6(module10(networking, v11, v7, v9, v8))
				end

				handleNewAuthCompletion(true, function()
					v6(module9())
				end, function()
					v6(module10(networking, v11, v7, v9, v8))
				end, false)
				return true
			end
		})
	end

	local useOtherSignInOptions = module4.getUseOtherSignInOptions()
	local function fn()
		v6(module11({ HttpError = Enum.HttpError.OK }))
	end
	local v11 = {
		isUserAuthenticated = function(): boolean
			return user.fromLocalStorage().userId ~= -1
		end,
		getCapabilities = function()
			return acquireClient().getCapabilitiesAsync()
		end,
		authenticate = function(p3)
			return acquireClient().authenticate(p3)
		end,
		eventContext = eventStreamConstants.Context.LoginForm,
		eventOrigin = 0,
		modalField = 0
	}
	local v12 = if fFlagLandingAndAccountPickerSsoTelemetry then eventStreamConstants.Context.LoginForm else nil
	v11.eventOrigin = v12
	v11.modalField = eventStreamConstants.Field.LoginOtherSignInOptionsModal
	local v13 = useOtherSignInOptions(v10, fn, v11)

	if v13 == nil then
		return nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v15 = {
		OtherSignInOptionsPadding = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v5.LuaApps.LoginView.loginContentsPadding),
			LayoutOrder = p2.LayoutOrder
		}),
		OtherSignInOptionsButton = 0,
		OtherSignInOptionsDialog = 0
	}

	local createElement2 = React.createElement

	local v18 = if module14 then buttonVariant.Standard else buttonVariant.Subtle
	v15.OtherSignInOptionsButton = createElement2(button, {
		testId = "--auth-login-button-other-sign-in-options",
		variant = v18,
		size = buttonSize.Large,
		text = v13.text,
		onActivated = v13.open,
		width = UDim.new(1, 0),
		LayoutOrder = p2.LayoutOrder + 1
	})

	v15.OtherSignInOptionsDialog = v13.dialog
	return createElement(fragment, nil, v15)
end

return LegacyLoginOtherSignInOptions
