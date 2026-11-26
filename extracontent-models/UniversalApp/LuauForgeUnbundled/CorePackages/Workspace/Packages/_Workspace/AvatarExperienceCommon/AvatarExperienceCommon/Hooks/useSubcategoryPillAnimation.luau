local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")

local AnimationConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/AnimationConstants")

local function useSubcategoryPillAnimation(p2)
	local state, setState = React.useState({})
	local ref = React.useRef(nil)
	local state2, setState2 = React.useState(false)

	React.useEffect(function()
		return function()
			if ref.current then
				task.cancel(ref.current)
			end
		end
	end, {})

	React.useEffect(function()
		local v5 = not (p2 and p2.Subcategories) and {} or p2.Subcategories

		if ref.current then
			task.cancel(ref.current)
		end

		if next(v5) then
			setState(v5)
			setState2(false)
		else
			setState2(true)
		end

		ref.current = task.delay(AnimationConstants.FIntAXSubcategoryPillFadeAnimationDurationMs / 1000, function()
			if not next(v5) then
				setState({})
			end

			setState2(false)
			ref.current = nil
		end)
	end, { p2 })

	return { subcategoriesState = state, isFadingOut = state2 }
end

return useSubcategoryPillAnimation
