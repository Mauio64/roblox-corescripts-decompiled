local CorePackages = game:GetService("CorePackages")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local StackRouter = RoactNavigation.StackRouter
local AvatarRootNavigationAction = AvatarExperienceNavigation.Enums.AvatarRootNavigationAction
local CustomGetStateForAction = AvatarExperienceNavigation.Enums.CustomGetStateForAction

return function(p1, p2) -- line: 24
	-- upvalues: Cryo (copy), AvatarRootNavigationAction (copy), StackRouter (copy), CustomGetStateForAction (copy)
	local v10 = Cryo.Dictionary.join(p2 or {}, {
		getCustomActionCreators = function(_, _) -- line: 26
			-- upvalues: AvatarRootNavigationAction (copy)
			return table.clone(AvatarRootNavigationAction)
		end
	})
	local v11 = StackRouter(p1, v10)
	local t1 = {}

	setmetatable(t1, {
		__mode = "v"
	})

	local getStateForAction = v11.getStateForAction

	function v11.getStateForAction(p5, p6) -- line: 37
		-- upvalues: AvatarRootNavigationAction (copy), CustomGetStateForAction (copy), t1 (copy), getStateForAction (copy)
		if p5.type == AvatarRootNavigationAction.RegisterCustomGetStateForAction then
			if CustomGetStateForAction.HandlerId[p5.handlerId] then
				t1[p5.handlerId] = p5.handler
			else
				warn(`Invalid custom getStateForAction handler id: { p5.handlerId }`)
			end

			return getStateForAction(p5, p6)
		end

		if p5.type == AvatarRootNavigationAction.DeregisterCustomGetStateForAction then
			t1[p5.handlerId] = nil

			return getStateForAction(p5, p6)
		end

		for _, v19 in CustomGetStateForAction.Ordering do
			local v20 = t1[v19]

			if not v20 then
				continue
			end

			local v21, v22 = v20(p5, p6)

			if v21 then
				return v22
			end
		end

		return getStateForAction(p5, p6)
	end

	return v11
end
