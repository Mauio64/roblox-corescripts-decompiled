local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local Colors = require(Modules.LuaApp.Themes.Colors)
local Alignment = require(Modules.LuaApp.Enum.Alignment)
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v22 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local AuthenticationProtocol = require(CorePackages.Workspace.Packages.AuthenticationProtocol).AuthenticationProtocol
local LogoWithContentsLayout = require(Modules.LuaApp.Components.Authentication.LogoWithContentsLayout)
local WeChatButton = require(Modules.LuaApp.Components.WeChatButton)
local QQButton = require(Modules.LuaApp.Components.QQButton)
local RequestMSDKLogin = require(Modules.Luobu.Thunks.RequestMSDKLogin)
local RequestTokenAuthentication = require(Modules.Luobu.Thunks.RequestTokenAuthentication)
local LaunchLuobuApp = require(Modules.Luobu.Thunks.LaunchLuobuApp)
local FetchUpdatedUserAgreements = require(Modules.LuaApp.Http.Requests.FetchUpdatedUserAgreements)
local SetMSDKLoginInProgress = require(Modules.Luobu.Actions.SetMSDKLoginInProgress)
local SetMSDKLoginErrMessageKey = require(Modules.Luobu.Actions.SetMSDKLoginErrMessageKey)
local SetTokenAuthErrMessageKey = require(Modules.Luobu.Actions.SetTokenAuthErrMessageKey)
local SetMSDKLoginOpenId = require(Modules.Luobu.Actions.SetMSDKLoginOpenId)
local SetSignUpInfo = require(Modules.Luobu.Actions.SetSignUpInfo)
local v39 = Roact.PureComponent:extend("LuobuLandingPage")

v39.validateProps = t.strictInterface({
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

function v39.init(p1) -- line: 78
	-- upvalues: NotificationType (copy), EventStreamConstants (copy), AuthenticationProtocol (copy)
	function p1.resetErrorMessages() -- line: 79
		-- upvalues: p1 (copy)
		p1.props.resetMSDKLoginErrMessageKey()
		p1.props.resetTokenAuthErrMessageKey()
	end
	function p1.shutdownApp() -- line: 84
		-- upvalues: p1 (copy), NotificationType (copy)
		p1.props.guiService:BroadcastNotification("", NotificationType.NATIVE_EXIT)
	end
	function p1.onLogin(p2) -- line: 89
		-- upvalues: p1 (copy)
		local analytics = p1.props.analytics
		local networking = p1.props.networking
		local appPolicy = p1.props.appPolicy
		local setMSDKLoginInProgress = p1.props.setMSDKLoginInProgress
		local setMSDKLoginOpenId = p1.props.setMSDKLoginOpenId
		local setSignUpInfo = p1.props.setSignUpInfo
		local launchLuobuApp = p1.props.launchLuobuApp
		local requestMSDKLogin = p1.props.requestMSDKLogin
		local requestTokenAuthentication = p1.props.requestTokenAuthentication
		local navigateToSignUpPage = p1.props.navigateToSignUpPage
		local navigateBack = p1.props.navigateBack

		p1:resetErrorMessages()
		setMSDKLoginInProgress(true)

		local v67, v68 = requestMSDKLogin(analytics, p2, networking, appPolicy):await()

		if not v67 then
			setMSDKLoginInProgress(false)

			return
		end

		setMSDKLoginOpenId(v68.openId)

		local v69, v70 = requestTokenAuthentication(networking, analytics, p2, v68):await()

		if not v69 then
			setMSDKLoginInProgress(false)

			if appPolicy.useMSDKWebAuthentication() then
				navigateBack()
			end

			return
		end

		if not v70.voucher then
			launchLuobuApp(networking, analytics, appPolicy)

			return
		end

		setSignUpInfo(v70.displayName, v70.voucher, p2, v68.channelId)
		navigateToSignUpPage()
	end
	function p1.onWeChatButtonActivated() -- line: 132
		-- upvalues: p1 (copy), EventStreamConstants (copy), AuthenticationProtocol (copy)
		if p1.props.loginInProgress then
			return
		end

		p1.props.authAnalytics.reportQQButtonClicked(EventStreamConstants.Context.LuobuLandingPage)
		p1.onLogin(AuthenticationProtocol.AuthMethods.WECHAT)
	end
	function p1.onQQButtonActivated() -- line: 141
		-- upvalues: p1 (copy), EventStreamConstants (copy), AuthenticationProtocol (copy)
		if p1.props.loginInProgress then
			return
		end

		p1.props.authAnalytics.reportQQButtonClicked(EventStreamConstants.Context.LuobuLandingPage)
		p1.onLogin(AuthenticationProtocol.AuthMethods.QQ)
	end
end
function v39.willUnmount(p3) -- line: 151
	p3.props.setMSDKLoginInProgress(false)
end
function v39.didMount(p4) -- line: 155
	-- upvalues: FetchUpdatedUserAgreements (copy)
	p4.props.resetSignUpInfo()

	local v45, v46 = FetchUpdatedUserAgreements(p4.props.networking, p4.props.analytics):await()

	if not v45 or (type(v46) ~= "table" or next(v46) == nil) then
		local shutdownApp = p4.shutdownApp

		p4.props.showAlert("CommonUI.Messages.Label.Alert", "Luobu.Authentication.Message.UnknownErrorTryAgain", "Application.ConnectionError.Action.Ok", shutdownApp)

		return
	end

	p4.props.showUserAgreementsPrompt(v46)
end
function v39.render(p5) -- line: 171
	-- upvalues: withStyle (copy), withLocalization (copy), Roact (copy), LogoWithContentsLayout (copy), Alignment (copy), Colors (copy), WeChatButton (copy), QQButton (copy)
	local v49 = p5.props.MSDKLoginErrMessageKey ~= "" and p5.props.MSDKLoginErrMessageKey or p5.props.tokenAuthErrMessageKey ~= "" and p5.props.tokenAuthErrMessageKey

	return withStyle(function(t1: {[any]: any}) -- line: 175
		-- upvalues: withLocalization (copy), v49 (copy), p5 (copy), Roact (copy), LogoWithContentsLayout (copy), Alignment (copy), Colors (copy), WeChatButton (copy), QQButton (copy)
		return withLocalization({
			logInTextWeChat = "Authentication.Login.Action.WeChatLogin",
			logInTextQQ = "Authentication.Login.Action.QQLogin",
			antiAddictionText = "Luobu.Authentication.Login.Label.AntiAddictionText",
			networkLicense = "Luobu.Authentication.Login.Label.NetworkLicense",
			tokenAuthFailure = "Authentication.Login.Response.TencentLoginFailurePleaseTryAgain",
			localizedError = v49 ~= "" and v49 or nil
		})(function(p6) -- line: 183
			-- upvalues: p5 (copy), Roact (copy), LogoWithContentsLayout (copy), Alignment (copy), t1 (copy), Colors (copy), WeChatButton (copy), QQButton (copy)
			local loginInProgress = p5.props.loginInProgress

			return Roact.createElement(LogoWithContentsLayout, {
				LuobuLogoEnabled = true,
				ContentAlign = Alignment.Top
			}, {
				LandingPageContents = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -40, 0, 0),
					Position = UDim2.new(0.5, 0, 0, 0),
					AnchorPoint = Vector2.new(0.5, 0),
					AutomaticSize = Enum.AutomaticSize.XY
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						Padding = UDim.new(0, 10),
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Bottom
					}),
					UIPadding = Roact.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, 36)
					}),
					UISizeConstraint = Roact.createElement("UISizeConstraint", {
						MinSize = Vector2.new(0, 0),
						MaxSize = Vector2.new(360, 1e999)
					}),
					AntiAddictionText = Roact.createElement("TextLabel", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						TextTransparency = 0.5,
						TextWrapped = true,
						TextColor3 = t1.Theme.SystemPrimaryDefault.Color,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0),
						Text = p6.antiAddictionText,
						TextSize = t1.Font.BaseSize * t1.Font.Footer.RelativeMinSize,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
					}),
					ErrorText = Roact.createElement("TextLabel", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						TextWrapped = true,
						TextColor3 = Colors.Red,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0),
						Text = p6.localizedError or "",
						Font = t1.Font.Footer.Font,
						TextSize = t1.Font.BaseSize * t1.Font.Footer.RelativeSize,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
					}, {
						UISizeConstraint = Roact.createElement("UISizeConstraint", {
							MinSize = Vector2.new(0, 10)
						})
					}),
					WeChatButton = Roact.createElement(WeChatButton, {
						LayoutOrder = 3,
						Size = UDim2.new(1, 0, 0, 48),
						Text = p6.logInTextWeChat,
						TextSize = t1.Font.BaseSize * t1.Font.Header1.RelativeSize,
						Color = t1.Theme.ContextualPrimaryDefault.Color,
						Transparency = t1.Theme.ContextualPrimaryDefault.Transparency,
						isDisabled = loginInProgress,
						isLoading = loginInProgress,
						onActivated = p5.onWeChatButtonActivated
					}),
					QQButton = Roact.createElement(QQButton, {
						LayoutOrder = 4,
						Size = UDim2.new(1, 0, 0, 48),
						Text = p6.logInTextQQ,
						TextSize = t1.Font.BaseSize * t1.Font.Header1.RelativeSize,
						Color = t1.Theme.TextLink.Color,
						Transparency = t1.Theme.TextLink.Transparency,
						isDisabled = loginInProgress,
						isLoading = loginInProgress,
						onActivated = p5.onQQButtonActivated
					}),
					NetworkLicense = Roact.createElement("TextLabel", {
						LayoutOrder = 5,
						BackgroundTransparency = 1,
						TextTransparency = 0.5,
						TextWrapped = true,
						TextColor3 = t1.Theme.SystemPrimaryDefault.Color,
						Size = UDim2.new(1, 0, 0, 0),
						Text = p6.networkLicense,
						TextSize = t1.Font.BaseSize * t1.Font.Footer.RelativeMinSize,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						AutomaticSize = Enum.AutomaticSize.Y
					})
				})
			})
		end)
	end)
end

local v40 = RoactRodux.connect(function(p7, _) -- line: 281
	return {
		loginInProgress = p7.Luobu.MSDKAuth.loginInProgress,
		MSDKLoginErrMessageKey = p7.Luobu.MSDKAuth.MSDKLoginErrMessageKey,
		tokenAuthErrMessageKey = p7.Luobu.MSDKAuth.tokenAuthErrMessageKey
	}
end, function(p9: ((...any) -> ...any)) -- line: 287
	-- upvalues: RequestMSDKLogin (copy), RequestTokenAuthentication (copy), LaunchLuobuApp (copy), SetMSDKLoginInProgress (copy), SetMSDKLoginErrMessageKey (copy), SetTokenAuthErrMessageKey (copy), SetMSDKLoginOpenId (copy), SetSignUpInfo (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), AppPage (copy), NavigateDown (copy), SetCentralOverlay (copy), OverlayType (copy), NavigateBack (copy)
	return {
		requestMSDKLogin = function(p10, p11, p12, p13) -- line: 289
			-- upvalues: p9 (copy), RequestMSDKLogin (copy)
			return p9(RequestMSDKLogin(p10, p11, p12, p13))
		end,
		requestTokenAuthentication = function(p14, p15, p16, p17) -- line: 292
			-- upvalues: p9 (copy), RequestTokenAuthentication (copy)
			return p9(RequestTokenAuthentication(p14, p15, p16, p17))
		end,
		launchLuobuApp = function(p18, p19, p20) -- line: 295
			-- upvalues: p9 (copy), LaunchLuobuApp (copy)
			return p9(LaunchLuobuApp(p18, p19, p20))
		end,
		setMSDKLoginInProgress = function(p21) -- line: 298
			-- upvalues: p9 (copy), SetMSDKLoginInProgress (copy)
			return p9(SetMSDKLoginInProgress(p21))
		end,
		resetMSDKLoginErrMessageKey = function() -- line: 301
			-- upvalues: p9 (copy), SetMSDKLoginErrMessageKey (copy)
			return p9(SetMSDKLoginErrMessageKey(""))
		end,
		resetTokenAuthErrMessageKey = function() -- line: 304
			-- upvalues: p9 (copy), SetTokenAuthErrMessageKey (copy)
			return p9(SetTokenAuthErrMessageKey(""))
		end,
		setMSDKLoginOpenId = function(p22) -- line: 307
			-- upvalues: p9 (copy), SetMSDKLoginOpenId (copy)
			return p9(SetMSDKLoginOpenId(p22))
		end,
		setSignUpInfo = function(p23, p24, p25, p26) -- line: 310
			-- upvalues: p9 (copy), SetSignUpInfo (copy)
			return p9(SetSignUpInfo(p23, p24, p25, p26))
		end,
		resetSignUpInfo = function() -- line: 313
			-- upvalues: p9 (copy), SetSignUpInfo (copy)
			return p9(SetSignUpInfo("", "", "", ""))
		end,
		navigateToSignUpPage = function() -- line: 316
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v22 (copy), AppPage (copy), p9 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				return v22.down(v22.fromLegacyPage({
					name = AppPage.LuobuSignUpPage
				}))
			end

			return p9(NavigateDown({
				name = AppPage.LuobuSignUpPage
			}))
		end,
		showUserAgreementsPrompt = function(p27) -- line: 323
			-- upvalues: p9 (copy), SetCentralOverlay (copy), OverlayType (copy)
			p9(SetCentralOverlay(OverlayType.UserAgreementsPrompt, {
				agreements = p27
			}))
		end,
		navigateBack = function() -- line: 328
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v22 (copy), p9 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				v22.back()

				return
			end

			p9(NavigateBack())
		end,
		showAlert = function(p28, p29, p30, p31) -- line: 335
			-- upvalues: p9 (copy), SetCentralOverlay (copy), OverlayType (copy)
			p9(SetCentralOverlay(OverlayType.SimpleTextAlertPrompt, {
				titleKey = p28,
				bodyTextKey = p29,
				confirmButtonTextKey = p30,
				confirmButtonCallback = p31
			}))
		end
	}
end)(v39)
local v41 = RoactServices.connect({
	networking = RoactNetworking,
	analytics = RoactAnalytics,
	authAnalytics = RoactAnalyticsAuthEvents,
	guiService = AppGuiService
})(v40)

return (RoactAppPolicy.connect(function(p32, _) -- line: 353
	return {
		appPolicy = p32
	}
end)(v41))
