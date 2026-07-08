local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")
local AvatarExperienceNavigationParent = AvatarExperienceNavigation.Parent
local React = require(AvatarExperienceNavigationParent.React)

require(AvatarExperienceNavigation.AvatarRoute.Types)

local AvatarScreen = require(AvatarExperienceNavigation.Enums.AvatarScreen)
local AvatarRouteContext = require(AvatarExperienceNavigation.AvatarRoute.Context.AvatarRouteContext)
local AvatarRoute = require(AvatarExperienceNavigation.AvatarRoute.AvatarRoute)

local function avatarRouteFromString(s1: string) -- line: 17
	-- upvalues: AvatarRoute (copy)
	local t1 = {
		name = s1,
		key = s1,
		params = {}
	}

	return AvatarRoute.new({
		isVisible = true,
		isOverlayVisible = false,
		current = t1,
		previousPages = { t1 },
		opaque = t1
	})
end
local function avatarRouteFromTable(p1) -- line: 32
	-- upvalues: AvatarScreen (copy), AvatarRoute (copy)
	local v12 = p1 or {}
	local v13 = v12.current or {}
	local v14 = v12.previous or {}
	local v15 = v12.opaque or {}
	local v16 = v13.name or AvatarScreen.None
	local v17 = v14.name or AvatarScreen.None
	local v18 = v15.name or AvatarScreen.None

	return AvatarRoute.new({
		current = {
			name = v16,
			key = v13.key or v16,
			params = v13.params or {}
		},
		previousPages = {{
			name = v17,
			key = v14.key or v17,
			params = v14.params or {}
		}},
		opaque = {
			name = v18,
			key = v15.key or v18,
			params = v15.params or {}
		},
		isVisible = v12.isVisible ~= false,
		isOverlayVisible = v12.isOverlayVisible == true
	})
end

return function(p2, p3) -- line: 72
	-- upvalues: avatarRouteFromString (copy), avatarRouteFromTable (copy), React (copy), AvatarRouteContext (copy)
	local v21 = if type(p3) ~= "string" then avatarRouteFromTable(p3) else avatarRouteFromString(p3)

	return React.forwardRef(function(p4, p5) -- line: 77
		-- upvalues: React (copy), AvatarRouteContext (copy), v21 (copy), p2 (copy)
		local v24 = table.clone(p4)

		v24.ref = p5

		return React.createElement(AvatarRouteContext.Provider, {
			value = v21
		}, {
			component = React.createElement(p2, v24)
		})
	end)
end
