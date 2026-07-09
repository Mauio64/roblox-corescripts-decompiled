local Parent = script:FindFirstAncestor("AddFriends").Parent
local Roact = require(Parent.Roact)

require(Parent.React)

local RoactAppExperiment = require(Parent.RoactAppExperiment)
local getFStringSocialAddFriendsPageLayer = require(Parent.SharedFlags).getFStringSocialAddFriendsPageLayer
local v5 = Roact.PureComponent:extend("AddFriendsLayerExposure")

function v5.init(p1) -- line: 19
	p1.state = {
		layerExposedOnMount = false
	}
end
function v5.didMount(p2) -- line: 25
	p2:setState({
		layerExposedOnMount = true
	})
end
function v5.render(p3) -- line: 31
	if p3.state.layerExposedOnMount then
		return (p3.props.renderChild({}))
	end

	return nil
end

return RoactAppExperiment.connectUserLayer({ getFStringSocialAddFriendsPageLayer() }, function(p4, _) -- line: 37
	-- upvalues: getFStringSocialAddFriendsPageLayer (copy)
	if not p4[getFStringSocialAddFriendsPageLayer()] then
	end

	return {}
end)(v5)
