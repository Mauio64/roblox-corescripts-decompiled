local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local module2 = require("@luauforge/bundled/dKU")
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute

local setAvatarSceneRoute = module2.Actions.SetAvatarSceneRoute

local extended = Roact.PureComponent:extend("AvatarRouteUpdater")

extended.validateProps = t.strictInterface({
	avatarRoute = avatarRoute.Interface,
	setAvatarSceneRoute = t.callback
})

function extended.render(p2): nil
	return nil
end

function extended.didMount(p2)
	local avatarRoute2 = p2.props.avatarRoute

	p2.props.setAvatarSceneRoute(avatarRoute2)
end

function extended.didUpdate(p2, p3)
	local avatarRoute2 = p2.props.avatarRoute

	if avatarRoute2 ~= p3.avatarRoute then
		p2.props.setAvatarSceneRoute(avatarRoute2)
	end
end

return (RoactRodux.connect(nil, function(callback)
	return {
		setAvatarSceneRoute = function(p2)
			callback(setAvatarSceneRoute(p2))
		end
	}
end)(extended))
