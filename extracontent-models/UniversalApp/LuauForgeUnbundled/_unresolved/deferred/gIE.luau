local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local withStyle = UIBlox.Style.withStyle
local loadingAlert = UIBlox.App.Dialog.Alert.LoadingAlert

local module = require("@luauforge/bundled/dzD")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local appRunService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppRunService
local appNotificationService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppNotificationService
local module2 = require("@luauforge/bundled/fvR")
local module3 = require("@luauforge/bundled/gIF")

local module4 = require("@luauforge/bundled/egJ")
local StateTable = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/StateTable/StateTable")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger:new("CoreGui.RobloxGui.Modules.LuaApp.Components._NativeHandshakeWrapper")

local androidTVExitButtonManager = require("@luauforge/bundled/dFB").AndroidTVExitButtonManager
local fFlagAndroidTVExitWithB = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAndroidTVExitWithB

local extended = Roact.PureComponent:extend("NativeHandshakeWrapper")

extended.validateProps = t.strictInterface({
	errorMessage = t.string,
	notificationData = t.string,
	notificationType = t.any,
	responseType = t.string,
	title = t.string,
	navigation = t.table,
	isVisible = t.optional(t.boolean),
	cancelTimeout = t.optional(t.number),
	dispatchTimeout = t.optional(t.number),
	DisplayOrder = t.optional(t.number),
	errorSubMessage = t.optional(t.string),
	responseNamespace = t.optional(t.string),
	responseCancelled = t.optional(t.string),
	responseFailure = t.optional(t.string),
	responseSuccess = t.optional(t.string),
	showBackButton = t.optional(t.boolean),
	navigateBack = t.callback,
	onError = t.callback,
	guiService = t.table,
	runService = t.table,
	appNotificationService = t.table
})

extended.defaultProps = {
	cancelTimeout = 1,
	dispatchTimeout = 5,
	DisplayOrder = 0,
	responseNamespace = "AppShellNotifications",
	responseCancelled = "cancelled",
	responseFailure = "failure",
	responseSuccess = "success",
	showBackButton = false
}

local v6 = {
	Theme = {
		Overlay = { Color = module.Color.GRAY1, Transparency = 0.5 }
	}
}

function extended:init()
	self.state = { screenSize = Vector2.new() }

	self.waitingTimeoutRunning = false
	self.cancelTimeoutRunning = false

	function self.stopTimers()
		self.waitingTimeoutRunning = false
		self.cancelTimeoutRunning = false
	end

	function self.closeSelf()
		self.stopTimers()
		self:close()
	end

	function self.closeWithError()
		if self.props.onError then
			self.props.onError(self.props.errorMessage, self.props.errorSubMessage)
		end

		self.closeSelf()
	end

	function self.broadcastNotification()
		v5:debug("Broadcasting NativeHandshakeWrapper notification")
		self.startTime = tick()
		self.waitingTimeoutRunning = true
		self:_broadcast(false)
	end

	function self.broadcastCancel()
		v5:debug("Broadcasting NativeHandshakeWrapper cancellation")
		self.waitingTimeoutRunning = false
		self.cancelTime = tick()
		self.cancelTimeoutRunning = true
		self:_broadcast(true)
	end

	self.stateTable = StateTable.new("NativeHandshakeWrapper", "waiting", {}, {
		waiting = {
			successReceived = { nextState = "success", action = self.stopTimers },
			failureReceived = { nextState = "halt", action = self.closeWithError },
			cancelReceived = { nextState = "halt", action = self.closeWithError },
			onTimeout = { nextState = "timed_out", action = self.broadcastCancel },
			onCancel = { nextState = "cancelled", action = self.broadcastCancel }
		},
		cancelled = {
			successReceived = { nextState = "success" },
			failureReceived = { nextState = "halt", action = self.closeWithError },
			cancelReceived = { nextState = "halt", action = self.closeSelf },
			onTimeout = { nextState = "halt", action = self.closeWithError }
		},
		timed_out = {
			successReceived = { nextState = "success" },
			failureReceived = { nextState = "halt", action = self.closeWithError },
			cancelReceived = { nextState = "halt", action = self.closeWithError },
			onTimeout = { nextState = "halt", action = self.closeWithError }
		},
		success = {
			focusReceived = { nextState = "halt", action = self.closeSelf }
		},
		halt = {}
	})

	function self.back()
		self.stateTable.events.onCancel()
	end

	self.backButton = module2.makeBackButton(self.back, true)

	function self.checkEvent(data)
		if
			data.namespace == self.props.responseNamespace
			and data.detailType == self.props.responseType
		then
			v5:debug("Received message {}: {}", tostring(data.detailType), (tostring(data.detail)))

			if data.detail == self.props.responseSuccess then
				self.stateTable.events.successReceived()
			elseif data.detail == self.props.responseFailure then
				self.stateTable.events.failureReceived()
			elseif data.detail == self.props.responseCancelled then
				self.stateTable.events.cancelReceived()
			end
		end

		if data.namespace == "AppInput" and data.detailType == "Focused" then
			v5:debug("Received app focused message")
			self.stateTable.events.focusReceived()
		end
	end

	function self.heartbeat()
		if self.waitingTimeoutRunning and tick() - self.startTime > self.props.dispatchTimeout then
			v5:info("Timed out waiting for native response")
			self.stateTable.events.onTimeout()
		elseif self.cancelTimeoutRunning and tick() - self.cancelTime > self.props.cancelTimeout then
			v5:warning("Timed out waiting for cancellation acknowledgement")
			self.stateTable.events.onTimeout()
		end
	end

	function self.onResize(p2)
		self:setState({ screenSize = p2.AbsoluteSize })
	end

	if fFlagAndroidTVExitWithB then
		self.tvExitDisconnect = androidTVExitButtonManager.register(self.stateTable.events.onCancel)
	end
end

function extended:willUnmount()
	if fFlagAndroidTVExitWithB and self.tvExitDisconnect then
		self.tvExitDisconnect()
		self.tvExitDisconnect = nil
	end
end

function extended.didMount(object)
	v5:info("NativeHandshakeWrapper mounted")
	object:broadcastNotification()
end

function extended.render(data)
	v5:trace("Rendering NativeHandshakeWrapper")
	return withStyle(function(p2)
		local v7 = p2 or v6
		local createElement = Roact.createElement
		local onResizesByAbsoluteSize = {
			Enabled = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = data.props.DisplayOrder,
			[Roact.Change.AbsoluteSize] = data.onResize
		}
		local children = {
			Background = Roact.createElement("Frame", {
				BackgroundColor3 = v7.Theme.Overlay.Color,
				BackgroundTransparency = v7.Theme.Overlay.Transparency,
				ZIndex = 0,
				Size = UDim2.fromScale(1, 1),
				Active = true,
				BorderSizePixel = 0
			}),
			TopBar = 0,
			Loading = 0,
			EventConnection = 0,
			HeartbeatConnection = 0,
			BackButtonConnection = 0
		}

		local v9 = if data.props.showBackButton then Roact.createElement(module2.Container, {
			titleText = "",
			leftItem = data.backButton,
			ZIndex = 2
		}) else nil
		children.TopBar = v9

		children.Loading = Roact.createElement(loadingAlert, {
			title = data.props.title,
			screenSize = data.state.screenSize
		})

		children.EventConnection = Roact.createElement(module4, {
			event = data.props.appNotificationService.RobloxEventReceived,
			callback = data.checkEvent
		})

		children.HeartbeatConnection = Roact.createElement(module4, {
			event = data.props.runService.Heartbeat,
			callback = data.heartbeat
		})

		children.BackButtonConnection = Roact.createElement(module4, {
			event = data.props.guiService.ShowLeaveConfirmation,
			callback = data.stateTable.events.onCancel
		})
		return createElement(module3, onResizesByAbsoluteSize, children)
	end)
end

function extended:_broadcast(p3)
	local isVisible = self.props.isVisible
	local notificationType = self.props.notificationType
	local guiService = self.props.guiService
	local v7 = self.props.notificationData

	if p3 then
		v7 = HttpService:JSONEncode({ cancel = true })
	end

	if isVisible and v7 ~= nil and notificationType ~= nil then
		v5:trace("Broadcasting {}: {}", notificationType, v7)
		guiService:BroadcastNotification(v7, notificationType)
	end
end

function extended.close(p2)
	v5:debug("Closing NativeHandshakerapper")
	p2.props.navigation.goBack()
end

return (roactServices.connect({
	guiService = appGuiService,
	runService = appRunService,
	appNotificationService = appNotificationService
})(extended))
