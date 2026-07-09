local Parent = script:FindFirstAncestor("RobloxAppNavigationCore").Parent

require(Parent.AppCommonLib)

local React = require(Parent.React)
local useLazyRef = require(Parent.ReactUtils).useLazyRef
local useNavigation = require(Parent.Navigation).useNavigation
local useProcessNavigationStateChange = require(script.Parent.useProcessNavigationStateChange)

local function RnBypassAdapter(t1: {[any]: any}) -- line: 23
	-- upvalues: useNavigation (copy), useLazyRef (copy), React (copy), useProcessNavigationStateChange (copy)
	local rnBypassActionSignal = t1.rnBypassActionSignal
	local v9 = useNavigation()
	local v10 = useLazyRef(function() -- line: 27
		-- upvalues: rnBypassActionSignal (copy), v9 (copy)
		return rnBypassActionSignal:connect(function(p1) -- line: 28
			-- upvalues: v9 (copy)
			v9.dispatch(p1)
		end)
	end)

	React.useEffect(function() -- line: 33
		-- upvalues: v10 (copy)
		v10.current:disconnect()
	end, {})
	React.useEffect(function() -- line: 37
		-- upvalues: rnBypassActionSignal (copy), v9 (copy)
		local v12 = rnBypassActionSignal:connect(function(p2) -- line: 39
			-- upvalues: v9 (copy)
			v9.dispatch(p2)
		end)

		return function() -- line: 43
			-- upvalues: v12 (copy)
			v12:disconnect()
		end
	end, {
		v9,
		rnBypassActionSignal
	})

	local v11 = useProcessNavigationStateChange(t1.ApplyRoactNavigationHistory, t1.updateRoute)

	React.useEffect(function() -- line: 51
		-- upvalues: v11 (copy), v9 (copy)
		v11(nil, v9.state, nil)
	end, { v9.state })

	return nil
end

return RnBypassAdapter
