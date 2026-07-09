local SocialLuaAnalytics = script:FindFirstAncestor("SocialLuaAnalytics")
local SocialLuaAnalyticsParent = SocialLuaAnalytics.Parent
local Promise = require(SocialLuaAnalyticsParent.Promise)
local RetrievalStatus = require(SocialLuaAnalyticsParent.Http).Enum.RetrievalStatus
local EventTypes = require(SocialLuaAnalytics.Analytics.Enums).EventTypes

require(SocialLuaAnalyticsParent.LuauPolyfill)

local Timers = require(script.Parent.Timers)

local function reportPromiseLoadingTimeWrapper(p1, p2: ((...any) -> ...any), t1: {[any]: any}) -- line: 54
	-- upvalues: Timers (copy), EventTypes (copy), RetrievalStatus (copy), Promise (copy)
	local function reportPromiseLoadingTime(...) -- line: 59
		-- upvalues: Timers (copy), t1 (copy), p2 (copy), EventTypes (copy), p1 (copy), RetrievalStatus (copy), Promise (copy)
		local t2 = { ... }
		local v13 = Timers()
		local v14 = v13.start()

		local function v15(s1: string, p3) -- line: 65
			-- upvalues: t1 (copy), v13 (copy), v14 (copy), p2 (copy), t2 (copy), EventTypes (copy)
			if t1 and t1.fireEvent then
				local v18 = v13.stop(v14)
				local v19 = p2(unpack(t2)) or {}

				t1.fireEvent(EventTypes.LoadingTime, {
					fetch = v19.fetch,
					nextPage = v19.nextPage,
					status = s1,
					result = p3
				}, v18)
			end
		end

		return p1(...):andThen(function(p4) -- line: 80
			-- upvalues: v15 (copy), RetrievalStatus (copy)
			pcall(function() -- line: 81
				-- upvalues: v15 (copy), RetrievalStatus (copy), p4 (copy)
				v15(RetrievalStatus.Done, p4)
			end)

			return p4
		end):catch(function(p5) -- line: 86
			-- upvalues: v15 (copy), RetrievalStatus (copy), Promise (copy)
			pcall(function() -- line: 87
				-- upvalues: v15 (copy), RetrievalStatus (copy)
				v15(RetrievalStatus.Failed)
			end)

			return Promise.reject(p5)
		end)
	end

	return reportPromiseLoadingTime
end

return reportPromiseLoadingTimeWrapper
