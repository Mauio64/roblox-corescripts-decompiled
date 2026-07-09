local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local AppUserGameSettings = require(CorePackages.Workspace.Packages.RoactServiceTags).AppUserGameSettings
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local ExternalEventConnection = require(Modules.Common.RoactUtilities.ExternalEventConnection)
local ExitFullscreenToast = require(Modules.LuaApp.Components.ExitFullscreenToast)
local v12 = Roact.PureComponent:extend("FullscreenEventReceiver")

function v12.init(p1) -- line: 17
	p1:setState({
		fullscreenEnabled = p1.props.appUserGameSettings:InFullScreen()
	})

	function p1.onFullscreenChanged(p2) -- line: 22
		-- upvalues: p1 (copy)
		p1:setState({
			fullscreenEnabled = p2
		})
	end
end
function v12.sendAnalytics(p3) -- line: 29
	p3.props.analytics.EventStream:setRBXEventStream("LuaApp", "FullscreenMode", {
		enabled = p3.state.fullscreenEnabled
	})
end
function v12.render(p4) -- line: 36
	-- upvalues: Responsive (copy), Roact (copy), ExternalEventConnection (copy), ExitFullscreenToast (copy)
	local v18 = p4.props.preferredInputRef and p4.props.preferredInputRef.current == Responsive.Input.Pointer

	return Roact.createFragment({
		EventConnector = Roact.createElement(ExternalEventConnection, {
			event = p4.props.appUserGameSettings.FullscreenChanged,
			callback = p4.onFullscreenChanged
		}),
		ExitFullscreenToast = v18 and (p4.state.fullscreenEnabled and Roact.createElement(ExitFullscreenToast))
	})
end
function v12.didMount(p5) -- line: 50
	p5:sendAnalytics()
end
function v12.didUpdate(p6, _, p8) -- line: 54
	if p8.fullscreenEnabled ~= p6.state.fullscreenEnabled then
		p6:sendAnalytics()
	end
end

local u13 = RoactServices.connect({
	analytics = RoactAnalytics,
	appUserGameSettings = AppUserGameSettings
})(v12)

local function FullscreenEventReceiverContainer(p9) -- line: 64
	-- upvalues: Responsive (copy), React (copy), Roact (copy), u13 (ref), Cryo (copy)
	local v24 = Responsive.usePreferredInput()
	local v25 = React.useRef(nil)

	v25.current = v24

	return Roact.createElement(u13, Cryo.Dictionary.join(p9, {
		preferredInputRef = v25
	}))
end

return FullscreenEventReceiverContainer
