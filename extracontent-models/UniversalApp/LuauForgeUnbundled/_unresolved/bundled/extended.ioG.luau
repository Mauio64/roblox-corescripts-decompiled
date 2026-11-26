local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ioH")
local Roact = require(CorePackages.Packages.Roact)

local module2 = require("@luauforge/bundled/gTl")
local module3 = require("@luauforge/bundled/ioI")

local extended = Roact.PureComponent:extend("SceneInteractionProvider")

function extended:init()
	local v5, v6, v7 = module({
		"panByDistance",
		"panByPixels",
		"rotateByRadians",
		"rotateByPixels",
		"setAngularVelocityByPixels",
		"zoomStraight",
		"zoomToPoint"
	})
	self.events = v5
	self.callbacks = v6
	self.cleanups = v7
end

function extended.render(props)
	return Roact.createElement(module2.Provider, { value = props.callbacks }, {
		SceneInteractionEventsProvider = Roact.createElement(
			module3.Provider,
			{ value = props.events },
			props.props[Roact.Children]
		)
	})
end

function extended.willUnmount(p2)
	for k, cleanup in p2.cleanups do
		cleanup()
	end
end

return extended
