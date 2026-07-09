local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local React = require(AvatarExperienceCommonParent.React)
local AnimationConstants = require(AvatarExperienceCommon.AnimationConstants)

local function useSubcategoryPillAnimation(p1) -- line: 15
	-- upvalues: React (copy), AnimationConstants (copy)
	local v7, v8 = React.useState({})
	local v9 = React.useRef(nil)
	local v10, v11 = React.useState(false)

	React.useEffect(function() -- line: 22
		-- upvalues: v9 (copy)
		return function() -- line: 23
			-- upvalues: v9 (copy)
			if v9.current then
				task.cancel(v9.current)
			end
		end
	end, {})
	React.useEffect(function() -- line: 31
		-- upvalues: p1 (copy), v9 (copy), v8 (copy), v11 (copy), AnimationConstants (copy)
		local v12 = if not p1 or not p1.Subcategories then {} else p1.Subcategories

		if v9.current then
			task.cancel(v9.current)
		end

		if next(v12) then
			v8(v12)
			v11(false)
		else
			v11(true)
		end

		v9.current = task.delay(AnimationConstants.FIntAXSubcategoryPillFadeAnimationDurationMs / 1000, function() -- line: 54
			-- upvalues: v12 (copy), v8 (copy), v11 (copy), v9 (copy)
			if not next(v12) then
				v8({})
			end

			v11(false)
			v9.current = nil
		end)
	end, { p1 })

	return {
		subcategoriesState = v7,
		isFadingOut = v10
	}
end

return useSubcategoryPillAnimation
