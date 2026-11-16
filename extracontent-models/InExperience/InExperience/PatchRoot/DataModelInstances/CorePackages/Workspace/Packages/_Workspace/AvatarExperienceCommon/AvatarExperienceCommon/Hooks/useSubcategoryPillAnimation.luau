local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local React = require(parent.React)

local AnimationConstants = require(AvatarExperienceCommon.AnimationConstants)

local function useSubcategoryPillAnimation(p)
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
		local v = not (p and p.Subcategories) and {} or p.Subcategories

		if ref.current then
			task.cancel(ref.current)
		end

		if next(v) then
			setState(v)
			setState2(false)
		else
			setState2(true)
		end

		ref.current = task.delay(AnimationConstants.FIntAXSubcategoryPillFadeAnimationDurationMs / 1000, function()
			if not next(v) then
				setState({})
			end

			setState2(false)
			ref.current = nil
		end)
	end, { p })

	return { subcategoriesState = state, isFadingOut = state2 }
end

return useSubcategoryPillAnimation
