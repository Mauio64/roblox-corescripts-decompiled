local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")
local useTokens = Foundation.Hooks.useTokens
local icon = Foundation.Icon
local enums = Foundation.Enums

local fFlagAXCategoryPillPositionAnimation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags").FFlagAXCategoryPillPositionAnimation

local function CategoryPillCloseButton(props)
	local actionStandard = useTokens().Color.ActionStandard

	local ref = React.useRef(nil)

	React.useEffect(function()
		if ref.current then
			props.categoryButtonRefs["X-Button"] = ref
			props.navButtonRefs[props.pillIndex] = ref
		end
	end, {})

	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		tag = "auto-xy radius-circle padding-small align-x-center align-y-center",
		backgroundStyle = actionStandard.Background,
		onActivated = props.onActivated,
		LayoutOrder = 0,
		ref = 0
	}
	local v6 = if not fFlagAXCategoryPillPositionAnimation then props.layoutOrder else nil
	v5.LayoutOrder = v6
	v5.ref = ref
	return createElement(view, v5, {
		CloseIcon = React.createElement(icon, {
			name = "x-small",
			size = enums.IconSize.Medium,
			style = actionStandard.Foreground
		})
	})
end

return CategoryPillCloseButton
