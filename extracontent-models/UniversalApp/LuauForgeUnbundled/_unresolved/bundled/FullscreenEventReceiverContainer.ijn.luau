local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/ecq")
local appUserGameSettings = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppUserGameSettings
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")

local module3 = require("@luauforge/bundled/egJ")
local module4 = require("@luauforge/bundled/ijo")

local extended = Roact.PureComponent:extend("FullscreenEventReceiver")

function extended:init()
	self:setState({
		fullscreenEnabled = self.props.appUserGameSettings:InFullScreen()
	})

	function self.onFullscreenChanged(p2)
		self:setState({ fullscreenEnabled = p2 })
	end
end

function extended:sendAnalytics()
	self.props.analytics.EventStream:setRBXEventStream("LuaApp", "FullscreenMode", {
		enabled = self.state.fullscreenEnabled
	})
end

function extended.render(props)
	local v5 = props.props.preferredInputRef
		and props.props.preferredInputRef.current == Responsive.Input.Pointer
	return Roact.createFragment({
		EventConnector = Roact.createElement(module3, {
			event = props.props.appUserGameSettings.FullscreenChanged,
			callback = props.onFullscreenChanged
		}),
		ExitFullscreenToast = v5 and props.state.fullscreenEnabled and Roact.createElement(module4)
	})
end

function extended:didMount()
	self:sendAnalytics()
end

function extended:didUpdate(p2, p3)
	if p3.fullscreenEnabled ~= self.state.fullscreenEnabled then
		self:sendAnalytics()
	end
end

local v5 = roactServices.connect({
	analytics = module,
	appUserGameSettings = appUserGameSettings
})(extended)
local function FullscreenEventReceiverContainer(p2)
	local v6 = Responsive.usePreferredInput()
	local ref = React.useRef(nil)
	ref.current = v6
	return Roact.createElement(v5, Cryo.Dictionary.join(p2, { preferredInputRef = ref }))
end

return FullscreenEventReceiverContainer
