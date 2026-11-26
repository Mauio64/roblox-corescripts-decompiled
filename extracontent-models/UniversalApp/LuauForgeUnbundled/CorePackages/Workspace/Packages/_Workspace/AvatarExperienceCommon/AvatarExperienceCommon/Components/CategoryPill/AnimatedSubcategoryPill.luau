local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/ReactOtter")
local AnimationConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/AnimationConstants")

local fFlagAXDisableHiddenCatalogCategoryPills = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags").FFlagAXDisableHiddenCatalogCategoryPills

local function AnimatedSubcategoryPill(props)
	local subcategory = props.subcategory
	local pillIndex = props.pillIndex
	local renderCategoryPill = props.renderCategoryPill
	local isFadingOut = props.isFadingOut

	local v5, v6 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function()
		v6(ReactOtter.spring(1, {
			frequency = AnimationConstants.FIntAXSubcategoryPillFadeAnimationFrequency,
			dampingRatio = AnimationConstants.FIntAXSubcategoryPillFadeAnimationDampingRatio
		}))
	end, {})

	React.useEffect(function()
		if isFadingOut then
			v6(ReactOtter.instant(0))
		end
	end, { isFadingOut })
	local v7 = if fFlagAXDisableHiddenCatalogCategoryPills then not isFadingOut else nil
	local v8 = renderCategoryPill(subcategory, pillIndex, v7)

	local mapped = v5:map(function(p2)
		return 1 - p2
	end)

	return React.createElement(Foundation.View, {
		tag = "auto-xy anchor-center-left padding-x-xxsmall",
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundTransparency = 1,
		GroupTransparency = mapped,
		LayoutOrder = pillIndex
	}, { Pill = v8 })
end

return AnimatedSubcategoryPill
