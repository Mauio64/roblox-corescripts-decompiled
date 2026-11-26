local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/Roact")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/Cryo")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/ArgCheck")
local ReactIs = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/ReactIs")

local function withMappedNavigationParams(p2, options)
	ArgCheck.assert(
		ReactIs.isValidElementType(p2),
		"withMappedNavigationParams must be called with a Roact component (stateful or functional)"
	)

	local v5 = options or {}

	if v5.forwardRef == nil then
		v5.forwardRef = true
	end

	return function(p3)
		local params = p3.navigation.state.params or {}
		return Roact.createElement(p2, Cryo.Dictionary.join(p3, params, {
			[Roact.Ref] = v5.forwardRef and p3[Roact.Ref] or Cryo.None
		}))
	end
end

return withMappedNavigationParams
