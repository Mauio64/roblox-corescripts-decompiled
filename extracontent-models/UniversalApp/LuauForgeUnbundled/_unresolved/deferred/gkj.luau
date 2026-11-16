local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local module = require("@luauforge/bundled/gkk")

local extended = Roact.Component:extend("RedirectToAvatarScreen")

function extended.didMount(p2)
	local navigation = p2.props.navigation
	p2.props.navigateIntoAvatarExperience(navigation.state.routeName, navigation.state.params)
	navigation.pop()
end

function extended.render(p2): nil
	return nil
end

local function mapDispatchToProps(callback)
	return {
		navigateIntoAvatarExperience = function(p2, p3)
			return callback(module(p2, p3, true))
		end
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(extended)
