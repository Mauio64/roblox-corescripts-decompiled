local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local NavigateDownToAvatarScreen = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AppRouterWrapper.NavigateDownToAvatarScreen)
local v6 = Roact.Component:extend("RedirectToAppRouterScreen")

function v6.didMount(p1) -- line: 16
	local navigation = p1.props.navigation
	local routeName = navigation.state.routeName
	local key = navigation.state.key
	local params = navigation.state.params

	p1.props.navigateDownToAvatarScreen(routeName, key, params)
	navigation.pop()
end
function v6.render(_) -- line: 25
	return nil
end

local function mapDispatchToProps(p3) -- line: 29
	-- upvalues: NavigateDownToAvatarScreen (copy)
	return {
		navigateDownToAvatarScreen = function(p4, p5, p6) -- line: 31
			-- upvalues: p3 (copy), NavigateDownToAvatarScreen (copy)
			return p3(NavigateDownToAvatarScreen(p4, p5, p6))
		end
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(v6)
