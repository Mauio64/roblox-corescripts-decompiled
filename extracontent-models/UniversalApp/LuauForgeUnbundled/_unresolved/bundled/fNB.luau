local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ecR")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module3 = require("@luauforge/bundled/eda")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module4 = require("@luauforge/bundled/dYT")
local module5 = require("@luauforge/bundled/fMG")
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local t = require(CorePackages.Packages.t)
local withStyle = UIBlox.Style.withStyle
local module6 = require("@luauforge/bundled/edC")
local module7 = require("@luauforge/bundled/fsy")
local Colors = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Colors")
local alignment = require("@game/CorePackages/Workspace/Packages/AuthCommon").Enums.Alignment

local module9 = require("@luauforge/bundled/dCp")
local module10 = require("@luauforge/bundled/eee")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

local module12 = require("@luauforge/bundled/edO")
local module13 = require("@luauforge/bundled/edP")
local module14 = require("@luauforge/bundled/fot")

local authenticationProtocol = require("@luauforge/bundled/fND").AuthenticationProtocol
local module15 = require("@luauforge/bundled/fNa")
local module16 = require("@luauforge/bundled/fNK")
local module17 = require("@luauforge/bundled/fNQ")
local module18 = require("@luauforge/bundled/fNR")
local module19 = require("@luauforge/bundled/fNX")
local module20 = require("@luauforge/bundled/fNZ")
local module21 = require("@luauforge/bundled/fOc")
local module22 = require("@luauforge/bundled/fNW")
local module23 = require("@luauforge/bundled/fNS")
local module24 = require("@luauforge/bundled/fNV")
local module25 = require("@luauforge/bundled/fOQ")
local module26 = require("@luauforge/bundled/fOR")

local extended = module.PureComponent:extend("LuobuLandingPage")

extended.validateProps = t.strictInterface({
	loginInProgress = t.boolean,
	MSDKLoginErrMessageKey = t.optional(t.string),
	tokenAuthErrMessageKey = t.optional(t.string),
	requestMSDKLogin = t.callback,
	requestTokenAuthentication = t.callback,
	launchLuobuApp = t.callback,
	setMSDKLoginInProgress = t.callback,
	setMSDKLoginOpenId = t.callback,
	setSignUpInfo = t.callback,
	resetMSDKLoginErrMessageKey = t.callback,
	resetTokenAuthErrMessageKey = t.callback,
	resetSignUpInfo = t.callback,
	navigateToSignUpPage = t.callback,
	navigateBack = t.callback,
	showUserAgreementsPrompt = t.callback,
	showAlert = t.callback,
	networking = t.callback,
	analytics = t.table,
	authAnalytics = t.table,
	appPolicy = t.table,
	guiService = t.table
})

function extended:init()
	function self.resetErrorMessages()
		self.props.resetMSDKLoginErrMessageKey()
		self.props.resetTokenAuthErrMessageKey()
	end

	function self.shutdownApp()
		self.props.guiService:BroadcastNotification("", module14.NATIVE_EXIT)
	end

	function self.onLogin(p2)
		local analytics = self.props.analytics
		local networking = self.props.networking
		local appPolicy = self.props.appPolicy
		local setMSDKLoginInProgress = self.props.setMSDKLoginInProgress
		local setMSDKLoginOpenId = self.props.setMSDKLoginOpenId
		local setSignUpInfo = self.props.setSignUpInfo
		local launchLuobuApp = self.props.launchLuobuApp
		local requestMSDKLogin = self.props.requestMSDKLogin
		local requestTokenAuthentication = self.props.requestTokenAuthentication
		local navigateToSignUpPage = self.props.navigateToSignUpPage
		local navigateBack = self.props.navigateBack

		self:resetErrorMessages()
		setMSDKLoginInProgress(true)

		local v5, v6 = requestMSDKLogin(analytics, p2, networking, appPolicy):await()

		if not v5 then
			setMSDKLoginInProgress(false)
			return
		end

		setMSDKLoginOpenId(v6.openId)

		local v7, v8 = requestTokenAuthentication(networking, analytics, p2, v6):await()

		if v7 then
			if not v8.voucher then
				launchLuobuApp(networking, analytics, appPolicy)
				return
			end

			setSignUpInfo(v8.displayName, v8.voucher, p2, v6.channelId)
			navigateToSignUpPage()
		else
			setMSDKLoginInProgress(false)

			if appPolicy.useMSDKWebAuthentication() then
				navigateBack()
			end
		end
	end

	function self.onWeChatButtonActivated()
		if self.props.loginInProgress then
			return
		end

		self.props.authAnalytics.reportQQButtonClicked(module7.Context.LuobuLandingPage)
		self.onLogin(authenticationProtocol.AuthMethods.WECHAT)
	end

	function self.onQQButtonActivated()
		if self.props.loginInProgress then
			return
		end

		self.props.authAnalytics.reportQQButtonClicked(module7.Context.LuobuLandingPage)
		self.onLogin(authenticationProtocol.AuthMethods.QQ)
	end
end

function extended.willUnmount(p2)
	p2.props.setMSDKLoginInProgress(false)
end

function extended.didMount(p2)
	p2.props.resetSignUpInfo()

	local v5, v6 = module21(p2.props.networking, p2.props.analytics):await()

	if v5 and type(v6) == "table" and next(v6) ~= nil then
		p2.props.showUserAgreementsPrompt(v6)

		return
	end

	local shutdownApp = p2.shutdownApp
	p2.props.showAlert(
		"CommonUI.Messages.Label.Alert",
		"Luobu.Authentication.Message.UnknownErrorTryAgain",
		"Application.ConnectionError.Action.Ok",
		shutdownApp
	)
end

function extended.render(data)
	local v5 = data.props.MSDKLoginErrMessageKey ~= "" and data.props.MSDKLoginErrMessageKey

	if not v5 then
		v5 = not (data.props.tokenAuthErrMessageKey == "") and data.props.tokenAuthErrMessageKey
	end

	return withStyle(function(data2)
		local v8 = if v5 ~= "" then v5 or nil else nil
		return module6({
			logInTextWeChat = "Authentication.Login.Action.WeChatLogin",
			logInTextQQ = "Authentication.Login.Action.QQLogin",
			antiAddictionText = "Luobu.Authentication.Login.Label.AntiAddictionText",
			networkLicense = "Luobu.Authentication.Login.Label.NetworkLicense",
			tokenAuthFailure = "Authentication.Login.Response.TencentLoginFailurePleaseTryAgain",
			localizedError = v8
		})(function(props)
			local loginInProgress = data.props.loginInProgress
			local createElement = module.createElement
			local v10 = { ContentAlign = alignment.Top, LuobuLogoEnabled = true }

			local createElement2 = module.createElement
			local v13 = {
				Size = UDim2.new(1, -40, 0, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}
			local children = {
				UIListLayout = module.createElement("UIListLayout", {
					Padding = UDim.new(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Bottom
				}),
				UIPadding = module.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 36)
				}),
				UISizeConstraint = module.createElement("UISizeConstraint", {
					MinSize = Vector2.new(0, 0),
					MaxSize = Vector2.new(360, 1e999)
				}),
				AntiAddictionText = module.createElement("TextLabel", {
					LayoutOrder = 1,
					TextColor3 = data2.Theme.SystemPrimaryDefault.Color,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					Text = props.antiAddictionText,
					TextTransparency = 0.5,
					TextSize = data2.Font.BaseSize * data2.Font.Footer.RelativeMinSize,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextWrapped = true
				}),
				ErrorText = 0,
				WeChatButton = 0,
				QQButton = 0,
				NetworkLicense = 0
			}

			local createElement3 = module.createElement
			local v15 = {
				LayoutOrder = 2,
				TextColor3 = Colors.Red,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				Text = props.localizedError or "",
				Font = 0,
				FontFace = 0,
				TextSize = 0,
				TextXAlignment = 0,
				TextYAlignment = 0,
				TextWrapped = true
			}
			local v16 = if not foundationFontFaceMigration then data2.Font.Footer.Font else nil
			v15.Font = v16

			local v17 = if foundationFontFaceMigration then normalizeFontFace(data2.Tokens.Typography.CaptionSmall.Font) else nil
			v15.FontFace = v17

			v15.TextSize = data2.Font.BaseSize * data2.Font.Footer.RelativeSize
			v15.TextXAlignment = Enum.TextXAlignment.Left
			v15.TextYAlignment = Enum.TextYAlignment.Center
			children.ErrorText = createElement3("TextLabel", v15, {
				UISizeConstraint = module.createElement("UISizeConstraint", {
					MinSize = Vector2.new(0, 10)
				})
			})

			children.WeChatButton = module.createElement(module16, {
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, 48),
				Text = props.logInTextWeChat,
				TextSize = data2.Font.BaseSize * data2.Font.Header1.RelativeSize,
				Color = data2.Theme.ContextualPrimaryDefault.Color,
				Transparency = data2.Theme.ContextualPrimaryDefault.Transparency,
				isDisabled = loginInProgress,
				isLoading = loginInProgress,
				onActivated = data.onWeChatButtonActivated
			})

			children.QQButton = module.createElement(module17, {
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, 48),
				Text = props.logInTextQQ,
				TextSize = data2.Font.BaseSize * data2.Font.Header1.RelativeSize,
				Color = data2.Theme.TextLink.Color,
				Transparency = data2.Theme.TextLink.Transparency,
				isDisabled = loginInProgress,
				isLoading = loginInProgress,
				onActivated = data.onQQButtonActivated
			})

			children.NetworkLicense = module.createElement("TextLabel", {
				LayoutOrder = 5,
				TextColor3 = data2.Theme.SystemPrimaryDefault.Color,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				Text = props.networkLicense,
				TextTransparency = 0.5,
				TextSize = data2.Font.BaseSize * data2.Font.Footer.RelativeMinSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y
			})
			return createElement(module15, v10, {
				LandingPageContents = createElement2("Frame", v13, children)
			})
		end)
	end)
end

local v5 = useSheetNavigation.connect(function(p2, p3)
	return {
		loginInProgress = p2.Luobu.MSDKAuth.loginInProgress,
		MSDKLoginErrMessageKey = p2.Luobu.MSDKAuth.MSDKLoginErrMessageKey,
		tokenAuthErrMessageKey = p2.Luobu.MSDKAuth.tokenAuthErrMessageKey
	}
end, function(callback)
	return {
		requestMSDKLogin = function(p2, p3, p4, p5)
			return callback(module18(p2, p3, p4, p5))
		end,
		requestTokenAuthentication = function(p2, p3, p4, p5)
			return callback(module19(p2, p3, p4, p5))
		end,
		launchLuobuApp = function(p2, p3, p4)
			return callback(module20(p2, p3, p4))
		end,
		setMSDKLoginInProgress = function(p2)
			return callback(module22(p2))
		end,
		resetMSDKLoginErrMessageKey = function()
			return callback(module23(""))
		end,
		resetTokenAuthErrMessageKey = function()
			return callback(module24(""))
		end,
		setMSDKLoginOpenId = function(p2)
			return callback(module25(p2))
		end,
		setSignUpInfo = function(p2, p3, p4, p5)
			return callback(module26(p2, p3, p4, p5))
		end,
		resetSignUpInfo = function()
			return callback(module26("", "", "", ""))
		end,
		navigateToSignUpPage = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage({
					name = module9.LuobuSignUpPage
				}))
			end

			return callback(module10({ name = module9.LuobuSignUpPage }))
		end,
		showUserAgreementsPrompt = function(p2)
			callback(module13(module12.UserAgreementsPrompt, { agreements = p2 }))
		end,
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.back()
			else
				callback(RobloxAppToastsRodux())
			end
		end,
		showAlert = function(p2, p3, p4, p5)
			callback(module13(module12.SimpleTextAlertPrompt, {
				titleKey = p2,
				bodyTextKey = p3,
				confirmButtonTextKey = p4,
				confirmButtonCallback = p5
			}))
		end
	}
end)(extended)

local v6 = roactServices.connect({
	networking = module3,
	analytics = module4,
	authAnalytics = module5,
	guiService = appGuiService
})(v5)

return (roactAppPolicy.connect(function(p2, p3)
	return { appPolicy = p2 }
end)(v6))
