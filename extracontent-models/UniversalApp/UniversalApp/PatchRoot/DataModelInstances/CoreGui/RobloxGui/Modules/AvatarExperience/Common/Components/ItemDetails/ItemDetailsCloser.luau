local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local v8 = Roact.PureComponent:extend("ItemDetailsCloser")

v8.validateProps = t.strictInterface({
	navigation = t.table,
	isAvatarExperienceRoute = t.boolean
})

function v8.render(_) -- line: 25
	return nil
end
function v8.didUpdate(p2, p3) -- line: 29
	-- upvalues: NavigationUtils (copy)
	local isAvatarExperienceRoute = p2.props.isAvatarExperienceRoute

	if p3.isAvatarExperienceRoute and not isAvatarExperienceRoute then
		NavigationUtils.closeFiltersAndItemDetails(p2.props.navigation)
	end
end

return (RoactRodux.connect(function(p4, _) -- line: 38
	-- upvalues: Utils (copy)
	return {
		isAvatarExperienceRoute = Utils.isAvatarExperienceRoute(p4)
	}
end, nil)(v8))
