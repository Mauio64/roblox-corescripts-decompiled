local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Icon = Foundation.Icon
local Enums = Foundation.Enums

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCategoryPillPositionAnimation = AvatarExperienceFlags.FFlagAXCategoryPillPositionAnimation

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
	local v = {
		tag = "auto-xy radius-circle padding-small align-x-center align-y-center",
		backgroundStyle = actionStandard.Background,
		onActivated = props.onActivated,
		LayoutOrder = 0,
		ref = 0
	}
	local layoutOrder

	if not FFlagAXCategoryPillPositionAnimation then
		layoutOrder = props.layoutOrder
	end

	v.LayoutOrder = layoutOrder
	v.ref = ref
	return createElement(view, v, {
		CloseIcon = React.createElement(Icon, {
			name = "x-small",
			size = Enums.IconSize.Medium,
			style = actionStandard.Foreground
		})
	})
end

return CategoryPillCloseButton
