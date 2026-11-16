local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local module = require("@luauforge/bundled/dwL")
local module2 = require("@luauforge/bundled/dYU")

local module3 = require("@luauforge/bundled/dwA")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local module4 = require("@luauforge/bundled/fox")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local appNotificationService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppNotificationService
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local module5 = require("@luauforge/deferred/fua")

local v5 = { canNativeWrapperParentHandleBackNavigation = require("@luauforge/deferred/fub") }

local extended = Roact.PureComponent:extend("NativePageWrapper")

extended.defaultProps = { DisplayOrder = 0 }

function extended:init()
	self._appInputEventConnection = self.props.appNotificationService.RobloxEventReceived:Connect(function(p2)
		local navigation = self.props.navigation

		if
			self._isMounted
			and navigation ~= nil
			and p2.namespace == "AppInput"
			and p2.detailType == "Focused"
		then
			if
				v5.canNativeWrapperParentHandleBackNavigation()
				and self.props.backNavigationHandledByParent
			then
				return
			end

			navigation.goBack()
		end
	end)
end

function extended.render(p2)
	local notificationData = p2.props.notificationData
	module.isNonNegativeNumber(p2.props.DisplayOrder, "NativePageWrapper:DisplayOrder")

	if module5() then
		return withLocalization({
			warningText = "CommonUI.Messages.Label.ActionNotAvailableOnVRHeadsetDevice"
		})(function(p3)
			return withStyle(function(p4)
				local v6 = module3.Color.GRAY1
				local v7

				if p4 then
					v6 = p4.Theme.Overlay.Color
					v7 = p4.Theme.Overlay.Transparency
				else
					v7 = 0.5
				end

				if p2.props.allowWebviews then
					return Roact.createElement(
						"Frame",
						{ BackgroundColor3 = v6, BackgroundTransparency = v7 },
						{
							button = Roact.createElement("TextButton", {
								Text = "press",
								Size = UDim2.fromScale(0.5, 0.5),
								Position = UDim2.fromScale(0.5, 0.5),
								AnchorPoint = Vector2.new(0.5, 0.5)
							})
						}
					)
				end

				local success, result = pcall(function()
					return HttpService:JSONDecode(notificationData)
				end)

				local title = success and typeof(result) == "table" and result.title or p2.props.titleText

				local v8 = module3.Color.GRAY4
				local v9

				if p4 then
					v8 = p4.Theme.BackgroundDefault.Color
					v9 = p4.Theme.BackgroundDefault.Transparency
				else
					v9 = 0.5
				end

				p2.props.eventIngest:sendEventDeferred(
					"open_disabled_web_view",
					"open_disabled_web_view_action",
					{ pageName = title }
				)

				local createElement = Roact.createElement
				local v11 = {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = v8,
					BackgroundTransparency = v9
				}

				local createElement2 = Roact.createElement
				local container = module4.Container

				local v13 = if isVRAppBuild() then module4.makeBackButton(nil, true) else module4.BackButton
				return createElement("Frame", v11, {
					TopBar = createElement2(container, {
						titleText = title,
						leftItem = v13
					}),
					WarningText = Roact.createElement("TextLabel", {
						Text = p3.warningText,
						Size = UDim2.new(1, 0, 1, 0),
						TextColor3 = p4.Theme.TextDefault.Color,
						TextSize = p4.Font.BaseSize,
						BackgroundColor3 = p4.Theme.BackgroundUIDefault.Color,
						TextWrapped = true
					})
				})
			end)
		end)
	end

	return withStyle(function(p3)
		local v6 = module3.Color.GRAY1
		local v7

		if p3 then
			v6 = p3.Theme.Overlay.Color
			v7 = p3.Theme.Overlay.Transparency
		else
			v7 = 0.5
		end

		if p2.props.allowWebviews then
			return Roact.createElement("Frame", {
				BackgroundColor3 = v6,
				BackgroundTransparency = v7
			}, {
				button = Roact.createElement("TextButton", {
					Text = "press",
					Size = UDim2.fromScale(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5)
				})
			})
		end

		local success, result = pcall(function()
			return HttpService:JSONDecode(notificationData)
		end)

		local title = success and typeof(result) == "table" and result.title or p2.props.titleText

		local v8 = module3.Color.GRAY4
		local v9

		if p3 then
			v8 = p3.Theme.BackgroundDefault.Color
			v9 = p3.Theme.BackgroundDefault.Transparency
		else
			v9 = 0.5
		end

		p2.props.eventIngest:sendEventDeferred("open_disabled_web_view", "open_disabled_web_view_action", {
			pageName = title
		})

		local createElement = Roact.createElement
		local v11 = {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = v8,
			BackgroundTransparency = v9
		}

		local createElement2 = Roact.createElement
		local container = module4.Container

		local v13 = if isVRAppBuild() then module4.makeBackButton(nil, true) else module4.BackButton
		return createElement("Frame", v11, {
			TopBar = createElement2(container, { titleText = title, leftItem = v13 }),
			WarningText = Roact.createElement("TextLabel", {
				Text = "Error: this functionality is currently unavailable on your device.",
				Size = UDim2.new(1, 0, 1, 0),
				TextColor3 = p3.Theme.TextDefault.Color,
				TextSize = p3.Font.BaseSize,
				BackgroundColor3 = p3.Theme.BackgroundUIDefault.Color,
				TextWrapped = true
			})
		})
	end)
end

function extended:didUpdate(p2)
	if not p2.isVisible then
		self:broadcastNotification()
	end
end

function extended:didMount()
	self._isMounted = true

	self:broadcastNotification()
end

function extended:willUnmount()
	self._isMounted = false

	if self._appInputEventConnection then
		self._appInputEventConnection:disconnect()
		self._appInputEventConnection = nil
	end

	if self.props.onClose ~= nil then
		self.props.onClose()
	end
end

function extended:broadcastNotification()
	if not self.props.allowWebviews then
		return
	end

	local isVisible = self.props.isVisible
	local v6 = self.props.notificationData

	if game:GetEngineFeature("SetWebViewTitle") and v6 == nil then
		v6 = HttpService:JSONEncode({
			title = self.props.titleText,
			url = self.props.url,
			transitionAnimation = self.props.transitionAnimation,
			animated = self.props.animated
		})
	end

	local notificationType = self.props.notificationType
	local guiService = self.props.guiService

	if isVisible and v6 ~= nil and notificationType ~= nil then
		guiService:BroadcastNotification(v6, notificationType)
	end
end

local v6 = roactServices.connect({
	guiService = appGuiService,
	appNotificationService = appNotificationService,
	eventIngest = module2
})(extended)

local v7 = RoactNavigation.withNavigation(v6)

return roactAppPolicy.connect(function(p2, p3)
	return { allowWebviews = p2.getWebViewSupport() }
end)(v7)
