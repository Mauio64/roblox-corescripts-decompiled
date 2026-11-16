local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local parent = AvatarExperienceCommon.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ReactOtter = require(parent.ReactOtter)
local AnimationConstants = require(AvatarExperienceCommon.AnimationConstants)

local function useCategoryPillAnimation(targetX: number, isSelected: boolean, shouldShowSubcategories: boolean)
	local v = shouldShowSubcategories and not isSelected
	local v2 = v and 1 or 0
	local v3, v4 = ReactOtter.useAnimatedBinding(targetX)
	local v5, v6 = ReactOtter.useAnimatedBinding(v2)

	React.useEffect(function()
		v4(ReactOtter.spring(targetX, {
			frequency = AnimationConstants.FIntAXCategoryPillPositionAnimationFrequency,
			dampingRatio = AnimationConstants.FIntAXCategoryPillPositionAnimationDampingRatio
		}))
	end, { targetX, v4 })

	React.useEffect(function()
		if v2 == 1 then
			v6(ReactOtter.instant(v2))
		else
			v6((ReactOtter.spring(v2, {
				frequency = AnimationConstants.FIntAXCategoryPillTransparencyAnimationFrequency,
				dampingRatio = AnimationConstants.FIntAXCategoryPillTransparencyAnimationDampingRatio
			})))
		end
	end, { v2 })

	return v3, v5, v
end

local function AnimatedCategoryPill(props)
	local catInfo = props.catInfo
	local pillIndex = props.pillIndex
	local isSelected = props.isSelected
	local shouldShowSubcategories = props.shouldShowSubcategories
	local targetX = props.targetX
	local renderCategoryPill = props.renderCategoryPill
	local onRef = props.onRef

	local v, groupTransparency, v2 = useCategoryPillAnimation(targetX, isSelected, shouldShowSubcategories)

	local pill = renderCategoryPill(catInfo, pillIndex, not v2)

	local mapped = v:map(function(p)
		return UDim2.new(0, p, 0.5, 0)
	end)

	return React.createElement(Foundation.View, {
		tag = "auto-xy anchor-center-left padding-x-xxsmall",
		Position = mapped,
		BackgroundTransparency = 1,
		GroupTransparency = groupTransparency,
		Size = UDim2.new(0, 0, 1, 0),
		ref = onRef
	}, { Pill = pill })
end

return AnimatedCategoryPill
