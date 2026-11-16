local module = require("@luauforge/deferred/ega")
require("@luauforge/deferred/eeO")
local module2 = require("@luauforge/deferred/ejl")
local getFStringSocialAddFriendsPageLayer = require("@luauforge/deferred/efc").getFStringSocialAddFriendsPageLayer

local extended = module.PureComponent:extend("AddFriendsLayerExposure")

function extended:init()
	self.state = { layerExposedOnMount = false }
end

function extended.didMount(object)
	object:setState({ layerExposedOnMount = true })
end

function extended.render(p2)
	if p2.state.layerExposedOnMount then
		return (p2.props.renderChild({}))
	end

	return nil
end

return module2.connectUserLayer({ getFStringSocialAddFriendsPageLayer() }, function(p2, p3)
	local v5 = p2[getFStringSocialAddFriendsPageLayer()]

	return {}
end)(extended)
