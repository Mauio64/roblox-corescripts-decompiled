local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplashScreenManager/React")
local SplashScreenManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SplashScreenManager/SplashScreenManager/SplashScreenManager")

local function useIsFPSAtTarget()
	local state, setState = React.useState(SplashScreenManager.isFPSAtTarget())
	local v5 = React.useCallback(function(p2)
		setState(p2)
	end, { setState })

	React.useEffect(function()
		SplashScreenManager.addStatusChangeListener(v5)
		return function()
			SplashScreenManager.removeStatusChangeListener(v5)
		end
	end, {})

	return state
end

return useIsFPSAtTarget
