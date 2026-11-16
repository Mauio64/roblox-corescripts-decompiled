local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dwA")
local module2 = require("@luauforge/bundled/ecR")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module4 = require("@luauforge/bundled/eda")
local module5 = require("@luauforge/bundled/dYT")
local module6 = require("@luauforge/bundled/edB")
local module7 = require("@luauforge/bundled/edm")

local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module8 = require("@luauforge/bundled/edC")

local LoadingModal = require("@game/CoreGui/RobloxGui/Modules/Settings/Pages/ShareGame/Components/LoadingModal")
local module10 = require("@luauforge/deferred/gds")
local module11 = require("@luauforge/deferred/gdt")
local module12 = require("@luauforge/bundled/fAH")
local module13 = require("@luauforge/bundled/fBo")
local module14 = require("@luauforge/bundled/fNO")

local module15 = require("@luauforge/bundled/edD")

local extended = module2.PureComponent:extend("WeChatLoginWrapper")

function extended:init()
	self.state = { showingBrowser = true, hasAuthenticated = false }

	function self.openWWWLogin()
		BrowserService:OpenWeChatAuthWindow()
		self:setState({ showingBrowser = true })
	end
	function self.onBrowserWindowClosed()
		self:setState({ showingBrowser = false })
	end
	function self.onAuthTokenUpdated()
		local appPolicy = self.props.appPolicy
		self.props.launchApp(
			self.props.networking,
			self.props.omniRecommendationsRequest,
			self.props.analytics,
			appPolicy
		)
	end
	function self.onJavascriptCallback(json)
		local jsonDecode = HttpService:JSONDecode(json)

		if not (jsonDecode.moduleID == "Navigation" and jsonDecode.functionName == "navigateToFeature") then
			return
		end

		local feature = jsonDecode.params.params.feature

		if feature == "login" or feature == "signUp" then
			BrowserService:CopyAuthCookieFromBrowserToEngine()
			BrowserService:CloseBrowserWindow()
			spawn(function()
				self:setState({ hasAuthenticated = true })
			end)
		end
	end
end

function extended.didMount(p2)
	BrowserService:OpenWeChatAuthWindow()
end

function extended.render(props)
	local appTheme = props.props.appTheme
	local localization = props.props.localization

	local children = {
		BrowserWindowClosedConnection = module2.createElement(module7, {
			event = BrowserService.BrowserWindowClosed,
			callback = props.onBrowserWindowClosed
		}),
		AuthCookieCopiedToEngineConnection = module2.createElement(module7, {
			event = BrowserService.AuthCookieCopiedToEngine,
			callback = props.onAuthTokenUpdated
		}),
		JavaScriptCallbackConnection = module2.createElement(module7, {
			event = BrowserService.JavaScriptCallback,
			callback = props.onJavascriptCallback
		})
	}

	local function fn(p2)
		if props.state.showingBrowser or props.state.hasAuthenticated then
			children.LoadingBar = module2.createElement(LoadingModal)
		else
			children.LoginButton = module2.createElement(module10, {
				backgroundColor = appTheme.Authentication.WeChatButton.Background.Color,
				backgroundImage = "LuaApp/buttons/buttonFill",
				sliceCenter = Rect.new(8, 8, 9, 9),
				maxWidth = 200,
				minWidth = 50,
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.new(0.5, 0, 0.5, 0),
				horizontalPadding = 30,
				verticalPadding = 9,
				iconRightPadding = 5,
				text = p2.loginText,
				textColor = appTheme.Authentication.WeChatButton.Text.Color,
				textFont = appTheme.Authentication.WeChatButton.Text.Font,
				textSize = appTheme.Authentication.WeChatButton.Text.Size,
				onActivated = props.openWWWLogin
			})
		end

		return module2.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = module.Color.GRAY4,
				ZIndex = 1
			},
			children
		)
	end

	if module15() then
		return module8({ loginText = "Authentication.Login.Action.WeChatLogin" })(fn)
	end

	return fn({
		loginText = localization:Format("Authentication.Login.Action.WeChatLogin")
	})
end

local v5 = module14(extended)

local v6 = useSheetNavigation.connect(function(p2, p3)
	return {}
end, function(callback)
	return {
		fetchAccountSettings = function(p2, p3, p4)
			callback(module11(p2, p3, p4))
		end,
		launchApp = function(p2, p3, p4, p5)
			callback(module12(p2, p3, p4, p5, module13.Login))
		end
	}
end)(v5)

local v7 = roactServices.connect({
	networking = module4,
	analytics = module5,
	localization = module6
})(v6)

return (roactAppPolicy.connect(function(p2, p3)
	return { appPolicy = p2 }
end)(v7))
