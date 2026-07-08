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
local ParentParent = script.Parent.Parent.Parent
local EventConnection = require(ParentParent.Parent.Common.EventConnection)
local isSubjectToDesktopPolicies = require(CorePackages.Workspace.Packages.SharedFlags).isSubjectToDesktopPolicies
local FFlagTopBarSignalizeScreenSize = require(CorePackages.Workspace.Packages.CoreGuiCommon).Flags.FFlagTopBarSignalizeScreenSize
local DisconnectedDialog = require(script.DisconnectedDialog)
local v15 = Roact.PureComponent:extend("HeadsetMenu")

v15.validateProps = t.strictInterface({
	screenSize = if not FFlagTopBarSignalizeScreenSize then t.Vector2 else nil,
	vrService = t.optional(t.union(t.instanceOf("VRService"), t.table)),
	guiService = t.optional(t.union(t.instanceOf("GuiService"), t.table))
})
v15.defaultProps = {
	vrService = VRService,
	guiService = GuiService
}

function v15.init(p1) -- line: 37
	-- upvalues: isSubjectToDesktopPolicies (copy), RunService (copy), FFlagTopBarSignalizeScreenSize (copy), Display (copy), Signals (copy)
	p1.state = {
		vrDeviceAvailable = false,
		shouldShowDisconnectDialog = false
	}

	function p1.restartApp() -- line: 43
		-- upvalues: p1 (copy), isSubjectToDesktopPolicies (copy), RunService (copy)
		local NotificationTypeList = p1.props.guiService:GetNotificationTypeList()

		if isSubjectToDesktopPolicies() then
			if game:GetEngineFeature("EnableLuaControlsRestartApp") then
				p1.props.guiService:BroadcastNotification("", NotificationTypeList.RESTART_APP)
			else
				p1.props.guiService:BroadcastNotification("", NotificationTypeList.NATIVE_EXIT)
			end
		else
			RunService.Heartbeat:Wait()
			game:Shutdown()
		end

		p1:setState({
			shouldShowDisconnectDialog = false
		})
	end

	if FFlagTopBarSignalizeScreenSize then
		local getViewportSize = Display.GetDisplayStore(false).getViewportSize

		p1.disposeScreenSize = Signals.createEffect(function(p2) -- line: 65
			-- upvalues: p1 (copy), getViewportSize (copy)
			p1:setState({
				screenSize = getViewportSize(p2)
			})
		end)
	end
end
function v15.render(p3) -- line: 73
	-- upvalues: Roact (copy), EventConnection (copy), DisconnectedDialog (copy), FFlagTopBarSignalizeScreenSize (copy)
	return Roact.createFragment({
		HeadsetConnection = Roact.createElement(EventConnection, {
			event = p3.props.vrService:GetPropertyChangedSignal("VRDeviceAvailable"),
			callback = function() -- line: 77
				-- upvalues: p3 (copy)
				p3:setState({
					vrDeviceAvailable = p3.props.vrService.VRDeviceAvailable
				})
			end
		}, {
			HeadsetDisconnectedDialog = Roact.createElement(DisconnectedDialog, {
				visible = p3.state.shouldShowDisconnectDialog,
				screenSize = if not FFlagTopBarSignalizeScreenSize then p3.props.screenSize else p3.state.screenSize,
				onConfirm = p3.restartApp,
				guiService = p3.props.guiService
			})
		})
	})
end
function v15.didMount(p4) -- line: 93
	p4:setState({
		vrDeviceAvailable = p4.props.vrService.VRDeviceAvailable
	})
end
function v15.willUnmount(p5) -- line: 99
	-- upvalues: FFlagTopBarSignalizeScreenSize (copy)
	if FFlagTopBarSignalizeScreenSize then
		p5.disposeScreenSize()
	end
end
function v15.didUpdate(p6, _, p8) -- line: 105
	if p6.state.vrDeviceAvailable ~= p8.vrDeviceAvailable and not p6.state.vrDeviceAvailable then
		p6:setState({
			shouldShowDisconnectDialog = true
		})
	end
end

if not FFlagTopBarSignalizeScreenSize then
	v15 = RoactRodux.connect(function(p9) -- line: 116
		return {
			screenSize = p9.displayOptions.screenSize
		}
	end)(v15)
end

return v15
