local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local Constants = require(Modules.LuaApp.Constants)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local AppNotificationService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppNotificationService
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local GetFFlagEnableLocalizedWebViewFallbackText = require(Modules.LuaApp.Flags.GetFFlagEnableLocalizedWebViewFallbackText)
local t1 = {
	canNativeWrapperParentHandleBackNavigation = require(Modules.LuaApp.Flags.GetFFlagLuaAppCanNativeWrapperParentHandleBackNavigation)
}
local v19 = Roact.PureComponent:extend("NativePageWrapper")

v19.defaultProps = {
	DisplayOrder = 0
}

function v19.init(p1) -- line: 37
	-- upvalues: t1 (copy)
	p1._appInputEventConnection = p1.props.appNotificationService.RobloxEventReceived:Connect(function(p2) -- line: 38
		-- upvalues: p1 (copy), t1 (copy)
		local navigation = p1.props.navigation

		if p1._isMounted and (navigation ~= nil and p2.namespace == "AppInput" and p2.detailType == "Focused") then
			if t1.canNativeWrapperParentHandleBackNavigation() and p1.props.backNavigationHandledByParent then
				return
			end

			navigation.goBack()
		end
	end)
end
function v19.render(p3) -- line: 61
	-- upvalues: ArgCheck (copy), GetFFlagEnableLocalizedWebViewFallbackText (copy), withLocalization (copy), withStyle (copy), Constants (copy), Roact (copy), HttpService (copy), TopBar (copy), IsVRAppBuild (copy)
	local notificationData = p3.props.notificationData

	ArgCheck.isNonNegativeNumber(p3.props.DisplayOrder, "NativePageWrapper:DisplayOrder")

	if GetFFlagEnableLocalizedWebViewFallbackText() then
		return withLocalization({
			warningText = "CommonUI.Messages.Label.ActionNotAvailableOnVRHeadsetDevice"
		})(function(p4) -- line: 68
			-- upvalues: withStyle (copy), Constants (copy), p3 (copy), Roact (copy), HttpService (copy), notificationData (copy), TopBar (copy), IsVRAppBuild (copy)
			return withStyle(function(p5) -- line: 69
				-- upvalues: Constants (copy), p3 (copy), Roact (copy), HttpService (copy), notificationData (copy), TopBar (copy), IsVRAppBuild (copy), p4 (copy)
				local GRAY1 = Constants.Color.GRAY1
				local n1 = 0.5

				if p5 then
					GRAY1 = p5.Theme.Overlay.Color
					n1 = p5.Theme.Overlay.Transparency
				end

				if p3.props.allowWebviews then
					return Roact.createElement("Frame", {
						BackgroundColor3 = GRAY1,
						BackgroundTransparency = n1
					}, {
						button = Roact.createElement("TextButton", {
							Text = "press",
							Size = UDim2.fromScale(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5),
							AnchorPoint = Vector2.new(0.5, 0.5)
						})
					})
				end

				local ok, result = pcall(function() -- line: 93
					-- upvalues: HttpService (copy), notificationData (copy)
					return HttpService:JSONDecode(notificationData)
				end)
				local v52 = ok and (typeof(result) == "table" and result.title) or p3.props.titleText
				local GRAY4 = Constants.Color.GRAY4
				local n2 = 0.5

				if p5 then
					GRAY4 = p5.Theme.BackgroundDefault.Color
					n2 = p5.Theme.BackgroundDefault.Transparency
				end

				p3.props.eventIngest:sendEventDeferred("open_disabled_web_view", "open_disabled_web_view_action", {
					pageName = v52
				})

				return Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = GRAY4,
					BackgroundTransparency = n2
				}, {
					TopBar = Roact.createElement(TopBar.Container, {
						titleText = v52,
						leftItem = if not IsVRAppBuild() then TopBar.BackButton else TopBar.makeBackButton(nil, true)
					}),
					WarningText = Roact.createElement("TextLabel", {
						TextWrapped = true,
						Text = p4.warningText,
						Size = UDim2.new(1, 0, 1, 0),
						TextColor3 = p5.Theme.TextDefault.Color,
						TextSize = p5.Font.BaseSize,
						BackgroundColor3 = p5.Theme.BackgroundUIDefault.Color
					})
				})
			end)
		end)
	end

	return withStyle(function(p6) -- line: 136
		-- upvalues: Constants (copy), p3 (copy), Roact (copy), HttpService (copy), notificationData (copy), TopBar (copy), IsVRAppBuild (copy)
		local GRAY1 = Constants.Color.GRAY1
		local n3 = 0.5

		if p6 then
			GRAY1 = p6.Theme.Overlay.Color
			n3 = p6.Theme.Overlay.Transparency
		end

		if p3.props.allowWebviews then
			return Roact.createElement("Frame", {
				BackgroundColor3 = GRAY1,
				BackgroundTransparency = n3
			}, {
				button = Roact.createElement("TextButton", {
					Text = "press",
					Size = UDim2.fromScale(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5)
				})
			})
		end

		local ok, result = pcall(function() -- line: 160
			-- upvalues: HttpService (copy), notificationData (copy)
			return HttpService:JSONDecode(notificationData)
		end)
		local v44 = ok and (typeof(result) == "table" and result.title) or p3.props.titleText
		local GRAY4 = Constants.Color.GRAY4
		local n4 = 0.5

		if p6 then
			GRAY4 = p6.Theme.BackgroundDefault.Color
			n4 = p6.Theme.BackgroundDefault.Transparency
		end

		p3.props.eventIngest:sendEventDeferred("open_disabled_web_view", "open_disabled_web_view_action", {
			pageName = v44
		})

		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = GRAY4,
			BackgroundTransparency = n4
		}, {
			TopBar = Roact.createElement(TopBar.Container, {
				titleText = v44,
				leftItem = if not IsVRAppBuild() then TopBar.BackButton else TopBar.makeBackButton(nil, true)
			}),
			WarningText = Roact.createElement("TextLabel", {
				Text = "Error: this functionality is currently unavailable on your device.",
				TextWrapped = true,
				Size = UDim2.new(1, 0, 1, 0),
				TextColor3 = p6.Theme.TextDefault.Color,
				TextSize = p6.Font.BaseSize,
				BackgroundColor3 = p6.Theme.BackgroundUIDefault.Color
			})
		})
	end)
end
function v19.didUpdate(p7, p8) -- line: 204
	if not p8.isVisible then
		p7:broadcastNotification()
	end
end
function v19.didMount(p9) -- line: 210
	p9._isMounted = true
	p9:broadcastNotification()
end
function v19.willUnmount(p10) -- line: 216
	p10._isMounted = false

	if p10._appInputEventConnection then
		p10._appInputEventConnection:disconnect()
		p10._appInputEventConnection = nil
	end

	if p10.props.onClose ~= nil then
		p10.props.onClose()
	end
end
function v19.broadcastNotification(p11) -- line: 229
	-- upvalues: HttpService (copy)
	if not p11.props.allowWebviews then
		return
	end

	local isVisible = p11.props.isVisible
	local notificationData = p11.props.notificationData

	if game:GetEngineFeature("SetWebViewTitle") and notificationData == nil then
		notificationData = HttpService:JSONEncode({
			title = p11.props.titleText,
			url = p11.props.url,
			transitionAnimation = p11.props.transitionAnimation,
			animated = p11.props.animated
		})
	end

	local notificationType = p11.props.notificationType
	local guiService = p11.props.guiService

	if isVisible and notificationData ~= nil and notificationType ~= nil then
		guiService:BroadcastNotification(notificationData, notificationType)
	end
end

local v20 = RoactServices.connect({
	guiService = AppGuiService,
	appNotificationService = AppNotificationService,
	eventIngest = AppEventIngestService
})(v19)
local v21 = RoactNavigation.withNavigation(v20)

return RoactAppPolicy.connect(function(p12, _) -- line: 264
	return {
		allowWebviews = p12.getWebViewSupport()
	}
end)(v21)
