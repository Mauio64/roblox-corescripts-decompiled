local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local useTopBarHeight = require(ProfilePlatformParent.RobloxAppHooks).useTopBarHeight
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local ProfileScrollContext = require(script.Parent.ProfileScrollContext)

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: useProfileFormFactor (copy), React (copy), Enums (copy), useTopBarHeight (copy), ProfileScrollContext (copy)
	local v9 = useProfileFormFactor()
	local v10, v11 = React.useState(v9.formFactor ~= Enums.ProfileFormFactor.PeekView and 1 or 0)
	local v12, v13 = React.useState(0)
	local v14 = useTopBarHeight()
	local v15 = React.useMemo(function() -- line: 22
		-- upvalues: v9 (copy), v14 (copy), Enums (copy), v12 (copy)
		local v17 = if not v9.isFullView then v14 else 0

		if v9.formFactor == Enums.ProfileFormFactor.PeekView and not v9.isFullView then
			v17 += 25
		end

		return (math.max(v17 - v12, 0))
	end, {
		v14,
		v12,
		v9
	})
	local v16 = React.useMemo(function() -- line: 34
		-- upvalues: v15 (copy), v13 (copy), v10 (copy), v11 (copy)
		return {
			scrollY = v15,
			setAbsoluteYPosition = v13,
			peekViewOpenPercent = v10,
			setPeekViewOpenPercent = v11
		}
	end, {
		v15,
		v13,
		v10,
		v11
	})

	return React.createElement(ProfileScrollContext.Provider, {
		value = v16
	}, t1.children)
end
