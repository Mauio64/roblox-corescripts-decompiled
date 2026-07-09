local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local withMappedProps = require(Modules.AvatarExperience.Common.withMappedProps)

local function filterAvatarRoute(p1) -- line: 10
	-- upvalues: Cryo (copy)
	return Cryo.Dictionary.join(p1, {
		avatarRoute = Cryo.None,
		opaqueRoute = p1.avatarRoute.opaque
	})
end

return function(p2) -- line: 25
	-- upvalues: withAvatarRoute (copy), withMappedProps (copy), filterAvatarRoute (copy)
	return withAvatarRoute(withMappedProps(p2, filterAvatarRoute))
end
