local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Icon = Foundation.Icon
local Enums = Foundation.Enums
local FFlagAXCategoryPillPositionAnimation = require(Parent.AvatarExperienceFlags).FFlagAXCategoryPillPositionAnimation

local function CategoryPillCloseButton(t1: {[any]: any}) -- line: 28
	-- upvalues: useTokens (copy), React (copy), Foundation (copy), FFlagAXCategoryPillPositionAnimation (copy), Icon (copy), Enums (copy)
	local ActionStandard = useTokens().Color.ActionStandard
	local v11 = React.useRef(nil)

	React.useEffect(function() -- line: 35
		-- upvalues: v11 (copy), t1 (copy)
		if v11.current then
			t1.categoryButtonRefs["X-Button"] = v11
			t1.navButtonRefs[t1.pillIndex] = v11
		end
	end, {})

	return React.createElement(Foundation.View, {
		tag = "auto-xy radius-circle padding-small align-x-center align-y-center",
		backgroundStyle = ActionStandard.Background,
		onActivated = t1.onActivated,
		LayoutOrder = if not FFlagAXCategoryPillPositionAnimation then t1.layoutOrder else nil,
		ref = v11
	}, {
		CloseIcon = React.createElement(Icon, {
			name = "x-small",
			size = Enums.IconSize.Medium,
			style = ActionStandard.Foreground
		})
	})
end

return CategoryPillCloseButton
