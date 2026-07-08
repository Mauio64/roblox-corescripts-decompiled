local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local React = require(AvatarExperienceCommonParent.React)
local Foundation = require(AvatarExperienceCommonParent.Foundation)
local ReactOtter = require(AvatarExperienceCommonParent.ReactOtter)
local AnimationConstants = require(AvatarExperienceCommon.AnimationConstants)

local function useCategoryPillAnimation(n1: number, b1: boolean, b2: boolean) -- line: 21
	-- upvalues: ReactOtter (copy), React (copy), AnimationConstants (copy)
	local v12 = b2 and not b1
	local v13 = not v12 and 0 or 1
	local v14, v15 = ReactOtter.useAnimatedBinding(n1)
	local v16, v17 = ReactOtter.useAnimatedBinding(v13)

	React.useEffect(function() -- line: 31
		-- upvalues: v15 (copy), ReactOtter (copy), n1 (copy), AnimationConstants (copy)
		v15(ReactOtter.spring(n1, {
			frequency = AnimationConstants.FIntAXCategoryPillPositionAnimationFrequency,
			dampingRatio = AnimationConstants.FIntAXCategoryPillPositionAnimationDampingRatio
		}))
	end, {
		n1,
		v15
	})
	React.useEffect(function() -- line: 38
		-- upvalues: v13 (copy), v17 (copy), ReactOtter (copy), AnimationConstants (copy)
		if v13 == 1 then
			v17(ReactOtter.instant(v13))

			return
		end

		v17((ReactOtter.spring(v13, {
			frequency = AnimationConstants.FIntAXCategoryPillTransparencyAnimationFrequency,
			dampingRatio = AnimationConstants.FIntAXCategoryPillTransparencyAnimationDampingRatio
		})))
	end, { v13 })

	return v14, v16, v12
end
local function AnimatedCategoryPill(t1: {[any]: any}) -- line: 52
	-- upvalues: useCategoryPillAnimation (copy), React (copy), Foundation (copy)
	local catInfo = t1.catInfo
	local pillIndex = t1.pillIndex
	local isSelected = t1.isSelected
	local shouldShowSubcategories = t1.shouldShowSubcategories
	local targetX = t1.targetX
	local renderCategoryPill = t1.renderCategoryPill
	local onRef = t1.onRef
	local v26, v27, v28 = useCategoryPillAnimation(targetX, isSelected, shouldShowSubcategories)
	local v29 = renderCategoryPill(catInfo, pillIndex, not v28)
	local v30 = v26:map(function(p1) -- line: 68
		return UDim2.new(0, p1, 0.5, 0)
	end)

	return React.createElement(Foundation.View, {
		tag = "auto-xy anchor-center-left padding-x-xxsmall",
		BackgroundTransparency = 1,
		Position = v30,
		GroupTransparency = v27,
		Size = UDim2.new(0, 0, 1, 0),
		ref = onRef
	}, {
		Pill = v29
	})
end

return AnimatedCategoryPill
