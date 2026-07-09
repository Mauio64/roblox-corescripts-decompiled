local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local NavigateIntoAvatarExperience = require(Modules.AvatarExperience.Common.Thunks.NavigateIntoAvatarExperience)
local v6 = Roact.Component:extend("RedirectToAvatarScreen")

function v6.didMount(p1) -- line: 19
	local navigation = p1.props.navigation

	p1.props.navigateIntoAvatarExperience(navigation.state.routeName, navigation.state.params)
	navigation.pop()
end
function v6.render(_) -- line: 25
	return nil
end

local function mapDispatchToProps(p3) -- line: 29
	-- upvalues: NavigateIntoAvatarExperience (copy)
	return {
		navigateIntoAvatarExperience = function(p4, p5) -- line: 31
			-- upvalues: p3 (copy), NavigateIntoAvatarExperience (copy)
			return p3(NavigateIntoAvatarExperience(p4, p5, true))
		end
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(v6)
