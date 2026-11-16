local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/ReactOtter")
local AnimationConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/AnimationConstants")

local function useCategoryPillAnimation(targetX, isSelected, shouldShowSubcategories)
	local v5 = shouldShowSubcategories and not isSelected
	local v6 = v5 and 1 or 0
	local v7, v8 = ReactOtter.useAnimatedBinding(targetX)
	local v9, v10 = ReactOtter.useAnimatedBinding(v6)

	React.useEffect(function()
		v8(ReactOtter.spring(targetX, {
			frequency = AnimationConstants.FIntAXCategoryPillPositionAnimationFrequency,
			dampingRatio = AnimationConstants.FIntAXCategoryPillPositionAnimationDampingRatio
		}))
	end, { targetX, v8 })

	React.useEffect(function()
		if v6 == 1 then
			v10(ReactOtter.instant(v6))
		else
			v10(ReactOtter.spring(v6, {
				frequency = AnimationConstants.FIntAXCategoryPillTransparencyAnimationFrequency,
				dampingRatio = AnimationConstants.FIntAXCategoryPillTransparencyAnimationDampingRatio
			}))
		end
	end, { v6 })

	return v7, v9, v5
end

local function AnimatedCategoryPill(props)
	local catInfo = props.catInfo
	local pillIndex = props.pillIndex
	local isSelected = props.isSelected
	local shouldShowSubcategories = props.shouldShowSubcategories
	local targetX = props.targetX
	local renderCategoryPill = props.renderCategoryPill
	local onRef = props.onRef

	local v5, v6, v7 = useCategoryPillAnimation(targetX, isSelected, shouldShowSubcategories)

	local v8 = renderCategoryPill(catInfo, pillIndex, not v7)

	local mapped = v5:map(function(p2)
		return UDim2.new(0, p2, 0.5, 0)
	end)

	return React.createElement(Foundation.View, {
		tag = "auto-xy anchor-center-left padding-x-xxsmall",
		Position = mapped,
		BackgroundTransparency = 1,
		GroupTransparency = v6,
		Size = UDim2.new(0, 0, 1, 0),
		ref = onRef
	}, { Pill = v8 })
end

return AnimatedCategoryPill
