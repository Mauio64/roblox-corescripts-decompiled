local CrossPlay = script:FindFirstAncestor("CrossPlay")
local CrossPlayParent = CrossPlay.Parent
local AppLifecycleObserverServiceOrStub = require(CrossPlay.ServiceWrappers.AppLifecycleObserverServiceOrStub)
local React = require(CrossPlayParent.React)
local useSelector = require(CrossPlayParent.RoactUtils).Hooks.RoactRodux.useSelector
local LoginStatus = require(CrossPlayParent.RobloxAppEnums).LoginStatus
local useCrossPlayApi = require(CrossPlay.Hooks.useCrossPlayApi)
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local useProperty = require(CrossPlayParent.GuiObjectUtils).useProperty

local function useInitializeCrossPlaySettings() -- line: 11
	-- upvalues: useCrossPlayApi (copy), useSelector (copy), React (copy), useProperty (copy), ThirdPartyUserService (copy), LoginStatus (copy), AppLifecycleObserverServiceOrStub (copy)
	local v11 = useCrossPlayApi()
	local v12 = useSelector(function(p1) -- line: 14
		return {
			authenticationStatus = p1.AuthenticationStatus.status,
			preloading = p1.Startup.Preloading
		}
	end)
	local v13, v14 = React.useState(false)
	local preloading = v12.preloading
	local v16 = useProperty(ThirdPartyUserService, "HasActiveUser") and v12.authenticationStatus == LoginStatus.LOGGED_IN

	React.useEffect(function() -- line: 26
		-- upvalues: v16 (copy), v13 (copy), preloading (copy), v11 (copy), v14 (copy)
		if v16 == v13 then
			return
		end

		if v16 and preloading then
			v11.fetch()
		elseif not v16 then
			v11.reset()
		end

		v14(v16)
	end, {
		v11,
		v16,
		v13,
		preloading
	})
	React.useEffect(function() -- line: 38
		-- upvalues: AppLifecycleObserverServiceOrStub (copy), v11 (copy)
		local v18 = AppLifecycleObserverServiceOrStub.OnBecomeActive:connect(function() -- line: 39
			-- upvalues: v11 (copy)
			v11.fetch()
		end)

		return function() -- line: 43
			-- upvalues: v18 (copy)
			v18:disconnect()
		end
	end, { v11 })
end

return useInitializeCrossPlaySettings
