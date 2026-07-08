local Parent = script:FindFirstAncestor("SplashScreenManager").Parent
local React = require(Parent.React)
local SplashScreenManager = require(script.Parent.SplashScreenManager)

local function useIsFPSAtTarget() -- line: 9
	-- upvalues: React (copy), SplashScreenManager (copy)
	local v5, v6 = React.useState(SplashScreenManager.isFPSAtTarget())
	local v7 = React.useCallback(function(p1) -- line: 11
		-- upvalues: v6 (copy)
		v6(p1)
	end, { v6 })

	React.useEffect(function() -- line: 15
		-- upvalues: SplashScreenManager (copy), v7 (copy)
		SplashScreenManager.addStatusChangeListener(v7)

		return function() -- line: 17
			-- upvalues: SplashScreenManager (copy), v7 (copy)
			SplashScreenManager.removeStatusChangeListener(v7)
		end
	end, {})

	return v5
end

return useIsFPSAtTarget
