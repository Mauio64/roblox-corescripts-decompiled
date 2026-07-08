local Parent = script:FindFirstAncestor("Moments").Parent
local React = require(Parent.React)
local AppTabBarRodux = require(Parent.AppTabBarRodux)
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local SetTabBarVisible = AppTabBarRodux.Actions.SetTabBarVisible

local function useHideTabBarWhileOpen(b1: boolean) -- line: 20
	-- upvalues: useDispatch (copy), React (copy), SetTabBarVisible (copy)
	local v8 = useDispatch()

	React.useEffect(function() -- line: 25
		-- upvalues: b1 (copy), v8 (copy), SetTabBarVisible (copy)
		if b1 then
			v8(SetTabBarVisible(false))
		end

		return function() -- line: 30
			-- upvalues: b1 (copy), v8 (copy), SetTabBarVisible (copy)
			if b1 then
				v8(SetTabBarVisible(true))
			end
		end
	end, {
		b1,
		v8
	})
end

return useHideTabBarWhileOpen
