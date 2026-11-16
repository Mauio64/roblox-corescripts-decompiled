local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/Promise")
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/Http").Enum.RetrievalStatus

local eventTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums").EventTypes

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/LuauPolyfill")

local Timers = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Timing/Timers")

local function reportPromiseLoadingTimeWrapper(callback, callback2, p2)
	local function reportPromiseLoadingTime(...)
		local v5 = { ... }

		local v6 = Timers()
		local v7 = v6.start()

		local function fn(p3, p4)
			if p2 and p2.fireEvent then
				local v8 = v6.stop(v7)
				local v9 = callback2(unpack(v5)) or {}

				p2.fireEvent(
					eventTypes.LoadingTime,
					{
						fetch = v9.fetch,
						nextPage = v9.nextPage,
						status = p3,
						result = p4
					},
					v8
				)
			end
		end

		return callback(...):andThen(function(p3)
			pcall(function()
				fn(retrievalStatus.Done, p3)
			end)
			return p3
		end):catch(function(p3)
			pcall(function()
				fn(retrievalStatus.Failed)
			end)
			return Promise.reject(p3)
		end)
	end

	return reportPromiseLoadingTime
end

return reportPromiseLoadingTimeWrapper
