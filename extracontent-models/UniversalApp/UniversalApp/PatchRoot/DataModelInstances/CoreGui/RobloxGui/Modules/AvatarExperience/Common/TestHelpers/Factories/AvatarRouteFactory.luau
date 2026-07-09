local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)

local t2 = {
	makeMockRouteInfo = function(s1: string) -- line: 12
		return {
			name = s1,
			key = s1,
			params = {}
		}
	end,
	makeMockRoute = function(p1, p2, t1: {[any]: any}) -- line: 21
		return {
			isVisible = true,
			isOverlayVisible = false,
			current = p2,
			previousPages = t1,
			opaque = p1
		}
	end
}

function t2.makeMockRouteSimplified(s2: string) -- line: 44
	-- upvalues: t2 (copy)
	local v8 = t2.makeMockRouteInfo(s2)

	return {
		isVisible = true,
		isOverlayVisible = false,
		current = v8,
		previousPages = { v8 },
		opaque = v8
	}
end

return t2
