local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local GetBuildPillMenuPortalStore = require(BuildExperience.Stores.GetBuildPillMenuPortalStore)
local View = Foundation.View

local function BuildPillMenuPortalHost(t1: {[any]: any}) -- line: 18
	-- upvalues: GetBuildPillMenuPortalStore (copy), React (copy), View (copy)
	local v9 = GetBuildPillMenuPortalStore()
	local v10 = React.useCallback(function(p1) -- line: 21
		-- upvalues: v9 (copy)
		v9.setPortalTarget(p1)
	end, { v9 })

	React.useEffect(function() -- line: 25
		-- upvalues: v9 (copy)
		return function() -- line: 26
			-- upvalues: v9 (copy)
			v9.setPortalTarget(nil)
		end
	end, { v9 })

	return React.createElement(View, {
		tag = "auto-xy",
		AnchorPoint = t1.anchorPoint,
		LayoutOrder = t1.layoutOrder,
		Position = t1.position,
		ref = v10,
		testId = t1.testId or "build-pill-menu-portal-host"
	})
end

return React.memo(BuildPillMenuPortalHost)
