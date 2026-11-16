local CorePackages = game:GetService("CorePackages")
game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)

local parent = script.Parent.Parent.Parent
local EventConnection = require(parent.Parent.Common.EventConnection)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeScreenSize = CoreGuiCommon.Flags.FFlagTopBarSignalizeScreenSize

local DisconnectedDialog = require(script.DisconnectedDialog)

local extended = Roact.PureComponent:extend("HeadsetMenu")

local strictInterface = t.strictInterface
local screenSize

if not FFlagTopBarSignalizeScreenSize then
	screenSize = t.Vector2
end

extended.validateProps = strictInterface({
	screenSize = screenSize,
	vrService = t.optional(t.union(t.instanceOf("VRService"), t.table)),
	guiService = t.optional(t.union(t.instanceOf("GuiService"), t.table))
})

extended.defaultProps = { vrService = VRService, guiService = GuiService }

function extended:init()
	self.state = { vrDeviceAvailable = false, shouldShowDisconnectDialog = false }

	function self.restartApp()
		local notificationTypeList = self.props.guiService:GetNotificationTypeList()

		if isSubjectToDesktopPolicies() then
			if game:GetEngineFeature("EnableLuaControlsRestartApp") then
				self.props.guiService:BroadcastNotification("", notificationTypeList.RESTART_APP)
			else
				self.props.guiService:BroadcastNotification("", notificationTypeList.NATIVE_EXIT)
			end
		else
			RunService.Heartbeat:Wait()
			game:Shutdown()
		end

		self:setState({ shouldShowDisconnectDialog = false })
	end

	if FFlagTopBarSignalizeScreenSize then
		local getViewportSize = Display.GetDisplayStore(false).getViewportSize

		self.disposeScreenSize = Signals.createEffect(function(p)
			self:setState({ screenSize = getViewportSize(p) })
		end)
	end
end

function extended.render(props)
	local createFragment = Roact.createFragment
	local createElement = Roact.createElement
	local v = {
		event = props.props.vrService:GetPropertyChangedSignal("VRDeviceAvailable"),
		callback = function()
			props:setState({ vrDeviceAvailable = props.props.vrService.VRDeviceAvailable })
		end
	}

	local createElement2 = Roact.createElement
	local v2 = {
		visible = props.state.shouldShowDisconnectDialog,
		screenSize = 0,
		onConfirm = 0,
		guiService = 0
	}
	local screenSize2

	if FFlagTopBarSignalizeScreenSize then
		screenSize2 = props.state.screenSize
	else
		screenSize2 = props.props.screenSize
	end

	v2.screenSize = screenSize2
	v2.onConfirm = props.restartApp
	v2.guiService = props.props.guiService
	return createFragment({
		HeadsetConnection = createElement(EventConnection, v, {
			HeadsetDisconnectedDialog = createElement2(DisconnectedDialog, v2)
		})
	})
end

function extended.didMount(object)
	object:setState({ vrDeviceAvailable = object.props.vrService.VRDeviceAvailable })
end

function extended.willUnmount(p)
	if FFlagTopBarSignalizeScreenSize then
		p.disposeScreenSize()
	end
end

function extended.didUpdate(object, _, p)
	if object.state.vrDeviceAvailable ~= p.vrDeviceAvailable and not object.state.vrDeviceAvailable then
		object:setState({ shouldShowDisconnectDialog = true })
	end
end

if not FFlagTopBarSignalizeScreenSize then
	extended = RoactRodux.connect(function(p)
		return { screenSize = p.displayOptions.screenSize }
	end)(extended)
end

return extended
