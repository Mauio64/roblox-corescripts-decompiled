local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.LuaApp.Constants)
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local ExternalEventConnection = require(Modules.Common.RoactUtilities.ExternalEventConnection)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local withLocalization = require(Modules.LuaApp.withLocalization)
local LoadingBar = require(Modules.LuaApp.Components.LoadingBar)
local FitImageTextButton = require(Modules.LuaApp.Components.FitImageTextButton)
local FetchAccountSettings = require(Modules.LuaApp.Thunks.Authentication.FetchAccountSettings)
local LaunchApp = require(Modules.LuaApp.Thunks.Authentication.LaunchApp)
local LaunchContext = require(Modules.LuaApp.Enum.LaunchContext)
local withTheme_DEPRECATED = require(Modules.LuaApp.withTheme_DEPRECATED)
local GetFFlagLuaAppUseWithLocalization = require(Modules.LuaApp.Flags.GetFFlagLuaAppUseWithLocalization)
local v22 = Roact.PureComponent:extend("WeChatLoginWrapper")

function v22.init(p1) -- line: 32
	-- upvalues: BrowserService (copy), HttpService (copy)
	p1.state = {
		showingBrowser = true,
		hasAuthenticated = false
	}

	function p1.openWWWLogin() -- line: 37
		-- upvalues: BrowserService (copy), p1 (copy)
		BrowserService:OpenWeChatAuthWindow()
		p1:setState({
			showingBrowser = true
		})
	end
	function p1.onBrowserWindowClosed() -- line: 43
		-- upvalues: p1 (copy)
		p1:setState({
			showingBrowser = false
		})
	end
	function p1.onAuthTokenUpdated() -- line: 48
		-- upvalues: p1 (copy)
		local appPolicy = p1.props.appPolicy

		p1.props.launchApp(p1.props.networking, p1.props.omniRecommendationsRequest, p1.props.analytics, appPolicy)
	end
	function p1.onJavascriptCallback(p2) -- line: 58
		-- upvalues: HttpService (copy), BrowserService (copy), p1 (copy)
		local data = HttpService:JSONDecode(p2)

		if data.moduleID ~= "Navigation" then
			return
		end

		if data.functionName ~= "navigateToFeature" then
			return
		end

		local feature = data.params.params.feature

		if feature == "login" or feature == "signUp" then
			BrowserService:CopyAuthCookieFromBrowserToEngine()
			BrowserService:CloseBrowserWindow()
			spawn(function() -- line: 70
				-- upvalues: p1 (copy)
				p1:setState({
					hasAuthenticated = true
				})
			end)
		end
	end
end
function v22.didMount(_) -- line: 79
	-- upvalues: BrowserService (copy)
	BrowserService:OpenWeChatAuthWindow()
end
function v22.render(p4) -- line: 83
	-- upvalues: Roact (copy), ExternalEventConnection (copy), BrowserService (copy), LoadingBar (copy), FitImageTextButton (copy), Constants (copy), GetFFlagLuaAppUseWithLocalization (copy), withLocalization (copy)
	local appTheme = p4.props.appTheme
	local localization = p4.props.localization
	local t1 = {
		BrowserWindowClosedConnection = Roact.createElement(ExternalEventConnection, {
			event = BrowserService.BrowserWindowClosed,
			callback = p4.onBrowserWindowClosed
		}),
		AuthCookieCopiedToEngineConnection = Roact.createElement(ExternalEventConnection, {
			event = BrowserService.AuthCookieCopiedToEngine,
			callback = p4.onAuthTokenUpdated
		}),
		JavaScriptCallbackConnection = Roact.createElement(ExternalEventConnection, {
			event = BrowserService.JavaScriptCallback,
			callback = p4.onJavascriptCallback
		})
	}

	local function v32(p5) -- line: 102
		-- upvalues: p4 (copy), t1 (copy), Roact (copy), LoadingBar (copy), FitImageTextButton (copy), appTheme (copy), Constants (copy)
		if p4.state.showingBrowser or p4.state.hasAuthenticated then
			t1.LoadingBar = Roact.createElement(LoadingBar)
		else
			t1.LoginButton = Roact.createElement(FitImageTextButton, {
				backgroundImage = "LuaApp/buttons/buttonFill",
				maxWidth = 200,
				minWidth = 50,
				horizontalPadding = 30,
				verticalPadding = 9,
				iconRightPadding = 5,
				backgroundColor = appTheme.Authentication.WeChatButton.Background.Color,
				sliceCenter = Rect.new(8, 8, 9, 9),
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.new(0.5, 0, 0.5, 0),
				text = p5.loginText,
				textColor = appTheme.Authentication.WeChatButton.Text.Color,
				textFont = appTheme.Authentication.WeChatButton.Text.Font,
				textSize = appTheme.Authentication.WeChatButton.Text.Size,
				onActivated = p4.openWWWLogin
			})
		end

		return Roact.createElement("Frame", {
			ZIndex = 1,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Constants.Color.GRAY4
		}, t1)
	end

	if GetFFlagLuaAppUseWithLocalization() then
		return withLocalization({
			loginText = "Authentication.Login.Action.WeChatLogin"
		})(v32)
	end

	return v32({
		loginText = localization:Format("Authentication.Login.Action.WeChatLogin")
	})
end

local v23 = withTheme_DEPRECATED(v22)
local v24 = RoactRodux.connect(function(_, _) -- line: 144
	return {}
end, function(p8) -- line: 146
	-- upvalues: FetchAccountSettings (copy), LaunchApp (copy), LaunchContext (copy)
	return {
		fetchAccountSettings = function(p9, p10, p11) -- line: 148
			-- upvalues: p8 (copy), FetchAccountSettings (copy)
			p8(FetchAccountSettings(p9, p10, p11))
		end,
		launchApp = function(p12, p13, p14, p15) -- line: 151
			-- upvalues: p8 (copy), LaunchApp (copy), LaunchContext (copy)
			p8(LaunchApp(p12, p13, p14, p15, LaunchContext.Login))
		end
	}
end)(v23)
local v25 = RoactServices.connect({
	networking = RoactNetworking,
	analytics = RoactAnalytics,
	localization = RoactLocalization
})(v24)

return (RoactAppPolicy.connect(function(p16, _) -- line: 163
	return {
		appPolicy = p16
	}
end)(v25))
