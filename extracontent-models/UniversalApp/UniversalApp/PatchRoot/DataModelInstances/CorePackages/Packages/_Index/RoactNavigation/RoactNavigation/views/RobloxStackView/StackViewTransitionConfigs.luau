local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object
local StackViewInterpolator = require(parent.StackViewInterpolator)
local StackPresentationStyle = require(parent.StackPresentationStyle)

local transitionSpec = { frequency = 3, dampingRatio = 1 }

local slideFromRight = {
	transitionSpec = transitionSpec,
	screenInterpolator = StackViewInterpolator.forHorizontal
}

local modalSlideFromBottom = {
	transitionSpec = transitionSpec,
	screenInterpolator = StackViewInterpolator.forVertical
}

local fadeInPlace = {
	transitionSpec = transitionSpec,
	screenInterpolator = StackViewInterpolator.forFade
}

local function getDefaultTransitionConfig(_, _, p) -- 1 equivalent call inferred from this helper
	if p == StackPresentationStyle.Modal then
		return modalSlideFromBottom
	end

	if p == StackPresentationStyle.Overlay then
		return fadeInPlace
	end

	return slideFromRight
end

return {
	getDefaultTransitionConfig = getDefaultTransitionConfig,
	getTransitionConfig = function(callback, p, p2, p3)
		local defaultTransitionConfig = getDefaultTransitionConfig(nil, nil, p3) -- inferred equivalent call

		if callback then
			return Object.assign(table.clone(defaultTransitionConfig), callback(p, p2, p3))
		end

		return defaultTransitionConfig
	end,
	SlideFromRight = slideFromRight,
	ModalSlideFromBottom = modalSlideFromBottom,
	FadeInPlace = fadeInPlace
}
