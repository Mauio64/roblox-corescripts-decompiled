local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent
local Object = require(ParentParent.LuauPolyfill).Object
local StackViewInterpolator = require(scriptParent.StackViewInterpolator)
local StackPresentationStyle = require(scriptParent.StackPresentationStyle)
local t1 = {
	frequency = 3,
	dampingRatio = 1
}
local t2 = {
	transitionSpec = t1,
	screenInterpolator = StackViewInterpolator.forHorizontal
}
local t3 = {
	transitionSpec = t1,
	screenInterpolator = StackViewInterpolator.forVertical
}
local t4 = {
	transitionSpec = t1,
	screenInterpolator = StackViewInterpolator.forFade
}

return {
	getDefaultTransitionConfig = function(_, _, p3) -- line: 31
		-- upvalues: StackPresentationStyle (copy), t3 (copy), t4 (copy), t2 (copy)
		if p3 == StackPresentationStyle.Modal then
			return t3
		end

		if p3 == StackPresentationStyle.Overlay then
			return t4
		end

		return t2
	end,
	getTransitionConfig = function(p4, p5, p6, p7) -- line: 41
		-- upvalues: StackPresentationStyle (copy), t3 (copy), t4 (copy), t2 (copy), Object (copy)
		local v17 = if p7 ~= StackPresentationStyle.Modal then if p7 ~= StackPresentationStyle.Overlay then t2 else t4 else t3

		if p4 then
			return Object.assign(table.clone(v17), p4(p5, p6, p7))
		end

		return v17
	end,
	SlideFromRight = t2,
	ModalSlideFromBottom = t3,
	FadeInPlace = t4
}
