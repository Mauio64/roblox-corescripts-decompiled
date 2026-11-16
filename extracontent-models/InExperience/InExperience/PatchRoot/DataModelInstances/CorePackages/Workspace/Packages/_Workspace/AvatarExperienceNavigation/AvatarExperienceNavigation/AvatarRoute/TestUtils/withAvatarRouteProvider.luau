local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")
local parent = AvatarExperienceNavigation.Parent
local React = require(parent.React)
require(AvatarExperienceNavigation.AvatarRoute.Types)
local AvatarScreen = require(AvatarExperienceNavigation.Enums.AvatarScreen)
local AvatarRouteContext = require(AvatarExperienceNavigation.AvatarRoute.Context.AvatarRouteContext)
local AvatarRoute = require(AvatarExperienceNavigation.AvatarRoute.AvatarRoute)

local function avatarRouteFromString(name: string)
	local v = { name = name, key = name, params = {} }

	return AvatarRoute.new({
		current = v,
		previousPages = { v },
		opaque = v,
		isVisible = true,
		isOverlayVisible = false
	})
end

local function avatarRouteFromTable(options)
	local v = options or {}
	local current = v.current or {}
	local previous = v.previous or {}
	local opaque = v.opaque or {}
	local name = current.name or AvatarScreen.None
	local name2 = previous.name or AvatarScreen.None
	local name3 = opaque.name or AvatarScreen.None
	return AvatarRoute.new({
		current = {
			name = name,
			key = current.key or name,
			params = current.params or {}
		},
		previousPages = {
			{
				name = name2,
				key = previous.key or name2,
				params = previous.params or {}
			}
		},
		opaque = {
			name = name3,
			key = opaque.key or name3,
			params = opaque.params or {}
		},
		isVisible = v.isVisible ~= false,
		isOverlayVisible = v.isOverlayVisible == true
	})
end

return function(p, name)
	local v

	if type(name) == "string" then
		v = avatarRouteFromString(name)
	else
		v = avatarRouteFromTable(name)
	end

	return React.forwardRef(function(p2, ref)
		local clone = table.clone(p2)
		clone.ref = ref
		return React.createElement(AvatarRouteContext.Provider, { value = v }, {
			component = React.createElement(p, clone)
		})
	end)
end
