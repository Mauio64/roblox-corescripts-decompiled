local module = require("@luauforge/deferred/gbt")

local roact = module.Roact
local roactNavigation = module.RoactNavigation
local roactRodux = module.RoactRodux
local dash = module.Dash
local t = module.t

local module2 = require("@luauforge/deferred/gbD")

local extended = roact.Component:extend("ShareLinkInvalidModalContainer")

extended.validateProps = t.interface({
	navigation = t.table,
	closeModal = t.optional(t.callback)
})

function extended:init()
	function self.closeModal()
		local props = self.props

		if props.closeModal then
			props.closeModal()
		end

		props.navigation.pop()
	end
end

function extended.render(p2)
	return roact.createElement(module2, dash.join(p2.props, {
		closeModal = p2.closeModal
	}))
end

local v5 = roactRodux.connect(function(p2)
	return { screenSize = p2.ScreenSize }
end)(extended)

return roactNavigation.withNavigation(v5)
