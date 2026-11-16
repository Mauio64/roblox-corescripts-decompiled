local SocialLuaAnalytics = script:FindFirstAncestor("SocialLuaAnalytics")
local parent = SocialLuaAnalytics.Parent

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus

local Enums = require(SocialLuaAnalytics.Analytics.Enums)
local EventTypes = Enums.EventTypes

require(parent.LuauPolyfill)

local Timers = require(script.Parent.Timers)

local function reportPromiseLoadingTimeWrapper(callback, callback2, p)
	local function reportPromiseLoadingTime(...)
		local v = { ... }

		local timers = Timers()
		local v2 = timers.start()

		local function fn(status: string, p2)
			if p and p.fireEvent then
				local v3 = timers.stop(v2)
				local v4 = callback2(unpack(v)) or {}

				p.fireEvent(
					EventTypes.LoadingTime,
					{ fetch = v4.fetch, nextPage = v4.nextPage, status = status, result = p2 },
					v3
				)
			end
		end

		return callback(...):andThen(function(p2)
			pcall(function()
				fn(RetrievalStatus.Done, p2)
			end)
			return p2
		end):catch(function(p2)
			pcall(function()
				fn(RetrievalStatus.Failed)
			end)
			return Promise.reject(p2)
		end)
	end

	return reportPromiseLoadingTime
end

return reportPromiseLoadingTimeWrapper
