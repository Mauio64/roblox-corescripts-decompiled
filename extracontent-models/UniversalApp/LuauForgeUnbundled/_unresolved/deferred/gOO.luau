local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local navigateDownToAvatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateDownToAvatarScreen

local extended = Roact.Component:extend("RedirectToAppRouterScreen")

function extended.didMount(p2)
	local navigation = p2.props.navigation
	local routeName = navigation.state.routeName
	local key = navigation.state.key
	local params = navigation.state.params
	p2.props.navigateDownToAvatarScreen(routeName, key, params)
	navigation.pop()
end

function extended.render(p2): nil
	return nil
end

local function mapDispatchToProps(callback)
	return {
		navigateDownToAvatarScreen = function(p2, p3, p4)
			return callback(navigateDownToAvatarScreen(p2, p3, p4))
		end
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(extended)
