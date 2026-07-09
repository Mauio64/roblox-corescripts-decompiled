local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local AvatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local SetAvatarSceneRoute = AvatarExperienceRodux.Actions.SetAvatarSceneRoute
local v9 = Roact.PureComponent:extend("AvatarRouteUpdater")

v9.validateProps = t.strictInterface({
	avatarRoute = AvatarRoute.Interface,
	setAvatarSceneRoute = t.callback
})

function v9.render(_) -- line: 32
	return nil
end
function v9.didMount(p2) -- line: 36
	local avatarRoute = p2.props.avatarRoute

	p2.props.setAvatarSceneRoute(avatarRoute)
end
function v9.didUpdate(p3, p4) -- line: 42
	local avatarRoute = p3.props.avatarRoute

	if avatarRoute ~= p4.avatarRoute then
		p3.props.setAvatarSceneRoute(avatarRoute)
	end
end

return (RoactRodux.connect(nil, function(p5) -- line: 51
	-- upvalues: SetAvatarSceneRoute (copy)
	return {
		setAvatarSceneRoute = function(p6) -- line: 53
			-- upvalues: p5 (copy), SetAvatarSceneRoute (copy)
			p5(SetAvatarSceneRoute(p6))
		end
	}
end)(v9))
