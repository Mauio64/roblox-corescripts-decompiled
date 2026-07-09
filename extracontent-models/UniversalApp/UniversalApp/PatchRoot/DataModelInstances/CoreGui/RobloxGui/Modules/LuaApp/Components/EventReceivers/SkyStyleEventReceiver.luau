local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useLocalUserId = require(CorePackages.Workspace.Packages.RobloxAppHooks).useLocalUserId
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local SkyStyleUtils = require(Modules.LuaApp.Components.More.SkyStyleUtils)

local function buildOptions(t1: {[any]: any}) -- line: 19
	return {
		appStorageJsonCacheUtils = t1.AppStorageJsonCacheUtils,
		appStorageService = t1.AppStorageService,
		httpService = t1.HttpService,
		lighting = t1.Lighting
	}
end
local function SkyStyleEventReceiver(t2: {[any]: any}) -- line: 28
	-- upvalues: useLocalUserId (copy), useIsSpatial (copy), React (copy), SkyStyleUtils (copy), Logger (copy)
	local v12 = useLocalUserId()
	local v13 = useIsSpatial()
	local v14 = React.useMemo(function() -- line: 33
		-- upvalues: t2 (copy)
		local v15 = t2

		return {
			appStorageJsonCacheUtils = v15.AppStorageJsonCacheUtils,
			appStorageService = v15.AppStorageService,
			httpService = v15.HttpService,
			lighting = v15.Lighting
		}
	end, {
		t2.AppStorageJsonCacheUtils,
		t2.AppStorageService,
		t2.HttpService,
		t2.Lighting
	})

	React.useEffect(function() -- line: 44
		-- upvalues: v13 (copy), SkyStyleUtils (copy), v14 (copy)
		if not v13 then
			return
		end

		pcall(function() -- line: 49
			-- upvalues: SkyStyleUtils (copy), v14 (copy)
			SkyStyleUtils.createSimpleSky(v14)
		end)
	end, {
		v13,
		v14
	})
	React.useEffect(function() -- line: 55
		-- upvalues: v13 (copy), Logger (copy), v12 (copy), SkyStyleUtils (copy), v14 (copy)
		if not v13 then
			return
		end

		Logger:info("[SkyStyleEventReceiver] Applying cached sky style for userId: " .. tostring(v12))
		SkyStyleUtils.applyCachedSkyStyle(v12, v14)
	end, {
		v13,
		v12,
		v14
	})

	return nil
end

return SkyStyleEventReceiver
