local parent = script:FindFirstAncestor("SplashScreenManager").Parent
local React = require(parent.React)
local SplashScreenManager = require(script.Parent.SplashScreenManager)

local function useIsFPSAtTarget()
	local state, setState = React.useState(SplashScreenManager.isFPSAtTarget())
	local v = React.useCallback(function(p)
		setState(p)
	end, { setState })

	React.useEffect(function()
		SplashScreenManager.addStatusChangeListener(v)
		return function()
			SplashScreenManager.removeStatusChangeListener(v)
		end
	end, {})

	return state
end

return useIsFPSAtTarget
