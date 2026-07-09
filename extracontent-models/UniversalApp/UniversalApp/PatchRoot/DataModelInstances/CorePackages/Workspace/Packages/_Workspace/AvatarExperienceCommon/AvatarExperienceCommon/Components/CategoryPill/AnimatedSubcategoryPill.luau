local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local React = require(AvatarExperienceCommonParent.React)
local Foundation = require(AvatarExperienceCommonParent.Foundation)
local ReactOtter = require(AvatarExperienceCommonParent.ReactOtter)
local AnimationConstants = require(AvatarExperienceCommon.AnimationConstants)
local FFlagAXDisableHiddenCatalogCategoryPills = require(AvatarExperienceCommonParent.AvatarExperienceFlags).FFlagAXDisableHiddenCatalogCategoryPills

local function AnimatedSubcategoryPill(t1: {[any]: any}) -- line: 22
	-- upvalues: ReactOtter (copy), React (copy), AnimationConstants (copy), FFlagAXDisableHiddenCatalogCategoryPills (copy), Foundation (copy)
	local subcategory = t1.subcategory
	local pillIndex = t1.pillIndex
	local renderCategoryPill = t1.renderCategoryPill
	local isFadingOut = t1.isFadingOut
	local v14, v15 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function() -- line: 32
		-- upvalues: v15 (copy), ReactOtter (copy), AnimationConstants (copy)
		v15(ReactOtter.spring(1, {
			frequency = AnimationConstants.FIntAXSubcategoryPillFadeAnimationFrequency,
			dampingRatio = AnimationConstants.FIntAXSubcategoryPillFadeAnimationDampingRatio
		}))
	end, {})
	React.useEffect(function() -- line: 41
		-- upvalues: isFadingOut (copy), v15 (copy), ReactOtter (copy)
		if isFadingOut then
			v15((ReactOtter.instant(0)))
		end
	end, { isFadingOut })

	local v16 = nil

	if FFlagAXDisableHiddenCatalogCategoryPills then
		v16 = not isFadingOut
	end

	local v17 = renderCategoryPill(subcategory, pillIndex, v16)
	local v18 = v14:map(function(p1) -- line: 56
		return 1 - p1
	end)

	return React.createElement(Foundation.View, {
		tag = "auto-xy anchor-center-left padding-x-xxsmall",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1, 0),
		GroupTransparency = v18,
		LayoutOrder = pillIndex
	}, {
		Pill = v17
	})
end

return AnimatedSubcategoryPill
