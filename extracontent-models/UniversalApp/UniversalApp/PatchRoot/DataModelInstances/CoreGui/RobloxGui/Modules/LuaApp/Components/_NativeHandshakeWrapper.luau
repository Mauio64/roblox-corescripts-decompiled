local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local withStyle = UIBlox.Style.withStyle
local LoadingAlert = UIBlox.App.Dialog.Alert.LoadingAlert
local Constants = require(Modules.LuaApp.Constants)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local AppRunService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppRunService
local AppNotificationService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppNotificationService
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local ScreenGuiWithBlurControl = require(Modules.LuaApp.Components.ScreenGuiWithBlurControl)
local ExternalEventConnection = require(Modules.Common.RoactUtilities.ExternalEventConnection)
local StateTable = require(Modules.LuaApp.StateTable)
local v18 = require(CorePackages.Workspace.Packages.Loggers).Logger:new(script:GetFullName())
local AndroidTVExitButtonManager = require(CorePackages.Workspace.Packages.RobloxAppNavigationCore).AndroidTVExitButtonManager
local FFlagAndroidTVExitWithB = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAndroidTVExitWithB
local v21 = Roact.PureComponent:extend("NativeHandshakeWrapper")

v21.validateProps = t.strictInterface({
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
v21.defaultProps = {
	cancelTimeout = 1,
	dispatchTimeout = 5,
	DisplayOrder = 0,
	responseNamespace = "AppShellNotifications",
	responseCancelled = "cancelled",
	responseFailure = "failure",
	responseSuccess = "success",
	showBackButton = false
}

local t1 = {
	Theme = {
		Overlay = {
			Transparency = 0.5,
			Color = Constants.Color.GRAY1
		}
	}
}

function v21.init(p1) -- line: 89
	-- upvalues: v18 (copy), StateTable (copy), TopBar (copy), FFlagAndroidTVExitWithB (copy), AndroidTVExitButtonManager (copy)
	p1.state = {
		screenSize = Vector2.new()
	}
	p1.waitingTimeoutRunning = false
	p1.cancelTimeoutRunning = false

	function p1.stopTimers() -- line: 97
		-- upvalues: p1 (copy)
		p1.waitingTimeoutRunning = false
		p1.cancelTimeoutRunning = false
	end
	function p1.closeSelf() -- line: 102
		-- upvalues: p1 (copy)
		p1.stopTimers()
		p1:close()
	end
	function p1.closeWithError() -- line: 107
		-- upvalues: p1 (copy)
		if p1.props.onError then
			p1.props.onError(p1.props.errorMessage, p1.props.errorSubMessage)
		end

		p1.closeSelf()
	end
	function p1.broadcastNotification() -- line: 114
		-- upvalues: v18 (copy), p1 (copy)
		v18:debug("Broadcasting NativeHandshakeWrapper notification")
		p1.startTime = tick()
		p1.waitingTimeoutRunning = true
		p1:_broadcast(false)
	end
	function p1.broadcastCancel() -- line: 121
		-- upvalues: v18 (copy), p1 (copy)
		v18:debug("Broadcasting NativeHandshakeWrapper cancellation")
		p1.waitingTimeoutRunning = false
		p1.cancelTime = tick()
		p1.cancelTimeoutRunning = true
		p1:_broadcast(true)
	end

	p1.stateTable = StateTable.new("NativeHandshakeWrapper", "waiting", {}, {
		waiting = {
			successReceived = {
				nextState = "success",
				action = p1.stopTimers
			},
			failureReceived = {
				nextState = "halt",
				action = p1.closeWithError
			},
			cancelReceived = {
				nextState = "halt",
				action = p1.closeWithError
			},
			onTimeout = {
				nextState = "timed_out",
				action = p1.broadcastCancel
			},
			onCancel = {
				nextState = "cancelled",
				action = p1.broadcastCancel
			}
		},
		cancelled = {
			successReceived = {
				nextState = "success"
			},
			failureReceived = {
				nextState = "halt",
				action = p1.closeWithError
			},
			cancelReceived = {
				nextState = "halt",
				action = p1.closeSelf
			},
			onTimeout = {
				nextState = "halt",
				action = p1.closeWithError
			}
		},
		timed_out = {
			successReceived = {
				nextState = "success"
			},
			failureReceived = {
				nextState = "halt",
				action = p1.closeWithError
			},
			cancelReceived = {
				nextState = "halt",
				action = p1.closeWithError
			},
			onTimeout = {
				nextState = "halt",
				action = p1.closeWithError
			}
		},
		success = {
			focusReceived = {
				nextState = "halt",
				action = p1.closeSelf
			}
		},
		halt = {}
	})

	function p1.back() -- line: 155
		-- upvalues: p1 (copy)
		p1.stateTable.events.onCancel()
	end

	p1.backButton = TopBar.makeBackButton(p1.back, true)

	function p1.checkEvent(p2) -- line: 161
		-- upvalues: p1 (copy), v18 (copy)
		if p2.namespace == p1.props.responseNamespace and p2.detailType == p1.props.responseType then
			v18:debug("Received message {}: {}", tostring(p2.detailType), (tostring(p2.detail)))

			if p2.detail == p1.props.responseSuccess then
				p1.stateTable.events.successReceived()
			elseif p2.detail == p1.props.responseFailure then
				p1.stateTable.events.failureReceived()
			elseif p2.detail == p1.props.responseCancelled then
				p1.stateTable.events.cancelReceived()
			end
		end

		if p2.namespace == "AppInput" and p2.detailType == "Focused" then
			v18:debug("Received app focused message")
			p1.stateTable.events.focusReceived()
		end
	end
	function p1.heartbeat() -- line: 179
		-- upvalues: p1 (copy), v18 (copy)
		if p1.waitingTimeoutRunning and tick() - p1.startTime > p1.props.dispatchTimeout then
			v18:info("Timed out waiting for native response")
			p1.stateTable.events.onTimeout()

			return
		end

		if p1.cancelTimeoutRunning and tick() - p1.cancelTime > p1.props.cancelTimeout then
			v18:warning("Timed out waiting for cancellation acknowledgement")
			p1.stateTable.events.onTimeout()
		end
	end
	function p1.onResize(p3) -- line: 189
		-- upvalues: p1 (copy)
		p1:setState({
			screenSize = p3.AbsoluteSize
		})
	end

	if FFlagAndroidTVExitWithB then
		p1.tvExitDisconnect = AndroidTVExitButtonManager.register(p1.stateTable.events.onCancel)
	end
end
function v21.willUnmount(p4) -- line: 200
	-- upvalues: FFlagAndroidTVExitWithB (copy)
	if FFlagAndroidTVExitWithB and p4.tvExitDisconnect then
		p4.tvExitDisconnect()
		p4.tvExitDisconnect = nil
	end
end
function v21.didMount(p5) -- line: 207
	-- upvalues: v18 (copy)
	v18:info("NativeHandshakeWrapper mounted")
	p5:broadcastNotification()
end
function v21.render(p6) -- line: 212
	-- upvalues: v18 (copy), withStyle (copy), t1 (copy), Roact (copy), ScreenGuiWithBlurControl (copy), TopBar (copy), LoadingAlert (copy), ExternalEventConnection (copy)
	v18:trace("Rendering NativeHandshakeWrapper")

	return withStyle(function(p7) -- line: 214
		-- upvalues: t1 (copy), Roact (copy), ScreenGuiWithBlurControl (copy), p6 (copy), TopBar (copy), LoadingAlert (copy), ExternalEventConnection (copy)
		if not p7 then
			p7 = t1
		end

		return Roact.createElement(ScreenGuiWithBlurControl, {
			Enabled = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = p6.props.DisplayOrder,
			[Roact.Change.AbsoluteSize] = p6.onResize
		}, {
			Background = Roact.createElement("Frame", {
				ZIndex = 0,
				Active = true,
				BorderSizePixel = 0,
				BackgroundColor3 = p7.Theme.Overlay.Color,
				BackgroundTransparency = p7.Theme.Overlay.Transparency,
				Size = UDim2.fromScale(1, 1)
			}),
			TopBar = if not p6.props.showBackButton then nil else Roact.createElement(TopBar.Container, {
				titleText = "",
				ZIndex = 2,
				leftItem = p6.backButton
			}),
			Loading = Roact.createElement(LoadingAlert, {
				title = p6.props.title,
				screenSize = p6.state.screenSize
			}),
			EventConnection = Roact.createElement(ExternalEventConnection, {
				event = p6.props.appNotificationService.RobloxEventReceived,
				callback = p6.checkEvent
			}),
			HeartbeatConnection = Roact.createElement(ExternalEventConnection, {
				event = p6.props.runService.Heartbeat,
				callback = p6.heartbeat
			}),
			BackButtonConnection = Roact.createElement(ExternalEventConnection, {
				event = p6.props.guiService.ShowLeaveConfirmation,
				callback = p6.stateTable.events.onCancel
			})
		})
	end)
end
function v21._broadcast(p8, p9) -- line: 260
	-- upvalues: HttpService (copy), v18 (copy)
	local isVisible = p8.props.isVisible
	local notificationType = p8.props.notificationType
	local guiService = p8.props.guiService
	local notificationData = p8.props.notificationData

	if p9 then
		notificationData = HttpService:JSONEncode({
			cancel = true
		})
	end

	if isVisible and notificationData ~= nil and notificationType ~= nil then
		v18:trace("Broadcasting {}: {}", notificationType, notificationData)
		guiService:BroadcastNotification(notificationData, notificationType)
	end
end
function v21.close(p10) -- line: 278
	-- upvalues: v18 (copy)
	v18:debug("Closing NativeHandshakerapper")
	p10.props.navigation.goBack()
end

return (RoactServices.connect({
	guiService = AppGuiService,
	runService = AppRunService,
	appNotificationService = AppNotificationService
})(v21))
