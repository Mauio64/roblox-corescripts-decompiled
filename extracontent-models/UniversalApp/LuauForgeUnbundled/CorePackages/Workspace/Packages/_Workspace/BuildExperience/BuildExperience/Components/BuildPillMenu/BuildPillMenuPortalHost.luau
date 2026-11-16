local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local GetBuildPillMenuPortalStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildPillMenuPortalStore")

local view = Foundation.View

local function BuildPillMenuPortalHost(props)
	local v5 = GetBuildPillMenuPortalStore()

	local v6 = React.useCallback(function(p2)
		v5.setPortalTarget(p2)
	end, { v5 })

	React.useEffect(function()
		return function()
			v5.setPortalTarget(nil)
		end
	end, { v5 })

	return React.createElement(view, {
		AnchorPoint = props.anchorPoint,
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		ref = v6,
		tag = "auto-xy",
		testId = props.testId or "build-pill-menu-portal-host"
	})
end

return React.memo(BuildPillMenuPortalHost)
