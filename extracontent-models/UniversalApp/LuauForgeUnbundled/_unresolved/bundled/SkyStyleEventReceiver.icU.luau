local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useLocalUserId
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger

local module = require("@luauforge/bundled/fzj")

local function buildOptions(data)
	return {
		appStorageJsonCacheUtils = data.AppStorageJsonCacheUtils,
		appStorageService = data.AppStorageService,
		httpService = data.HttpService,
		lighting = data.Lighting
	}
end

local function SkyStyleEventReceiver(data): nil
	local v5 = useLocalUserId()
	local v6 = useIsSpatial()

	local v7 = React.useMemo(function()
		local v8 = data
		return {
			appStorageJsonCacheUtils = v8.AppStorageJsonCacheUtils,
			appStorageService = v8.AppStorageService,
			httpService = v8.HttpService,
			lighting = v8.Lighting
		}
	end, {
		data.AppStorageJsonCacheUtils,
		data.AppStorageService,
		data.HttpService,
		data.Lighting
	})

	React.useEffect(function()
		if not v6 then
			return
		end

		pcall(function()
			module.createSimpleSky(v7)
		end)
	end, { v6, v7 })

	React.useEffect(function()
		if not v6 then
			return
		end

		logger:info("[SkyStyleEventReceiver] Applying cached sky style for userId: " .. tostring(v5))
		module.applyCachedSkyStyle(v5, v7)
	end, { v6, v5, v7 })

	return nil
end

return SkyStyleEventReceiver
