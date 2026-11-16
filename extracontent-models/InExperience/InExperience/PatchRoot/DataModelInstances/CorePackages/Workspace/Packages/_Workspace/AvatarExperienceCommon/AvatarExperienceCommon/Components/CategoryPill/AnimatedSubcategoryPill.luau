local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local parent = AvatarExperienceCommon.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ReactOtter = require(parent.ReactOtter)
local AnimationConstants = require(AvatarExperienceCommon.AnimationConstants)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXDisableHiddenCatalogCategoryPills = AvatarExperienceFlags.FFlagAXDisableHiddenCatalogCategoryPills

local function AnimatedSubcategoryPill(props)
	local subcategory = props.subcategory
	local pillIndex = props.pillIndex
	local renderCategoryPill = props.renderCategoryPill
	local isFadingOut = props.isFadingOut

	local v, v2 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function()
		v2(ReactOtter.spring(1, {
			frequency = AnimationConstants.FIntAXSubcategoryPillFadeAnimationFrequency,
			dampingRatio = AnimationConstants.FIntAXSubcategoryPillFadeAnimationDampingRatio
		}))
	end, {})

	React.useEffect(function()
		if isFadingOut then
			v2((ReactOtter.instant(0)))
		end
	end, { isFadingOut })
	local v3

	if FFlagAXDisableHiddenCatalogCategoryPills then
		v3 = not isFadingOut
	end

	local pill = renderCategoryPill(subcategory, pillIndex, v3)

	local mapped = v:map(function(p)
		return 1 - p
	end)

	return React.createElement(Foundation.View, {
		tag = "auto-xy anchor-center-left padding-x-xxsmall",
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundTransparency = 1,
		GroupTransparency = mapped,
		LayoutOrder = pillIndex
	}, { Pill = pill })
end

return AnimatedSubcategoryPill
