local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local GetBuildPillMenuPortalStore = require(BuildExperience.Stores.GetBuildPillMenuPortalStore)

local View = Foundation.View

local function BuildPillMenuPortalHost(props)
	local buildPillMenuPortalStore = GetBuildPillMenuPortalStore()

	local ref = React.useCallback(function(p)
		buildPillMenuPortalStore.setPortalTarget(p)
	end, { buildPillMenuPortalStore })

	React.useEffect(function()
		return function()
			buildPillMenuPortalStore.setPortalTarget(nil)
		end
	end, { buildPillMenuPortalStore })

	return React.createElement(View, {
		AnchorPoint = props.anchorPoint,
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		ref = ref,
		tag = "auto-xy",
		testId = props.testId or "build-pill-menu-portal-host"
	})
end

return React.memo(BuildPillMenuPortalHost)
