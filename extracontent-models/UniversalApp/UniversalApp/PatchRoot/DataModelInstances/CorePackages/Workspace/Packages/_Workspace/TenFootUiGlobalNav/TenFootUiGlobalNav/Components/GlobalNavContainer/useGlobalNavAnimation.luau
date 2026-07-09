local Parent = script:FindFirstAncestor("TenFootUiGlobalNav").Parent
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)
local FocusNavigationContext = require(Parent.ReactFocusNavigation).FocusNavigationContext
local useDescendantHasFocus = require(Parent.FocusNavigationUtils).useDescendantHasFocus
local t1 = {
	stiffness = 711.1,
	damping = 40,
	mass = 1
}

local function useGlobalNavAnimation(b1: boolean) -- line: 15
	-- upvalues: React (copy), FocusNavigationContext (copy), useDescendantHasFocus (copy), ReactOtter (copy), t1 (copy)
	local v9, v10 = React.useState(b1)
	local v11 = React.useContext(FocusNavigationContext)
	local v12 = React.useRef(nil)
	local v13 = useDescendantHasFocus(v12.current)
	local v14, v15 = ReactOtter.useAnimatedBinding(not v9 and 1 or 0, function(p1) -- line: 22
		-- upvalues: v10 (copy)
		if p1 == 1 then
			v10(false)
		end
	end)

	React.useEffect(function() -- line: 29
		-- upvalues: b1 (copy), v10 (copy), v15 (copy), ReactOtter (copy), t1 (copy)
		if b1 then
			v10(true)
			v15(ReactOtter.spring(0, t1))

			return
		end

		v15(ReactOtter.spring(1, t1))
	end, { b1 })
	React.useEffect(function() -- line: 38
		-- upvalues: v11 (copy), b1 (copy), v13 (copy)
		if v11 and (not b1 and v13) then
			v11:focusGuiObject(nil, true)
		end
	end, {
		b1,
		v13
	})

	return {
		isVisible = v9,
		transparency = v14,
		ref = v12
	}
end

return useGlobalNavAnimation
