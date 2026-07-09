local GameDetailRodux = script:FindFirstAncestor("GameDetailRodux")
local GameDetailRoduxParent = GameDetailRodux.Parent
local Logging = require(GameDetailRoduxParent.AppCommonLib).Logging
local Promise = require(GameDetailRoduxParent.Promise)
local AgeRecommendationDetails = require(GameDetailRodux.AgeRecommendations.AgeRecommendationDetails)
local PerformFetch = require(GameDetailRoduxParent.Http).PerformFetch
local SetNetworkingErrorToast = require(GameDetailRoduxParent.RobloxAppToastsRodux).Thunks.SetNetworkingErrorToast
local SetAgeRecommendation = require(GameDetailRodux.AgeRecommendations.SetAgeRecommendation)
local SetAgeRecommendationHeaders = require(GameDetailRodux.AgeRecommendations.SetAgeRecommendationHeaders)
local GetAgeRecommendation = require(GameDetailRodux.AgeRecommendations.GetAgeRecommendation)
local t1 = {}

local function fetchKeymapper(p1) -- line: 17
	return "luaapp.experience_guidelines.get-age-guidelines" .. p1
end

function t1.Fetch(p2, s1: string) -- line: 21
	-- upvalues: PerformFetch (copy), GetAgeRecommendation (copy), AgeRecommendationDetails (copy), Logging (copy), Promise (copy), SetAgeRecommendation (copy), SetAgeRecommendationHeaders (copy), SetNetworkingErrorToast (copy)
	return PerformFetch.Single("luaapp.experience_guidelines.get-age-guidelines" .. s1, function(p3) -- line: 22
		-- upvalues: GetAgeRecommendation (copy), p2 (copy), s1 (copy), AgeRecommendationDetails (copy), Logging (copy), Promise (copy), SetAgeRecommendation (copy), SetAgeRecommendationHeaders (copy), SetNetworkingErrorToast (copy)
		return GetAgeRecommendation(p2, s1):andThen(function(p4) -- line: 23
			-- upvalues: AgeRecommendationDetails (copy), Logging (copy), s1 (copy), Promise (copy), p3 (copy), SetAgeRecommendation (copy), SetAgeRecommendationHeaders (copy)
			local responseBody = p4.responseBody

			if responseBody ~= nil then
				local v21, v22 = AgeRecommendationDetails.fromJsonData(responseBody.ageRecommendationDetails):unwrap()

				if v21 == false then
					Logging.warn("Failed to parse AgeRecommendationDetails for `" .. s1 .. "`")

					return Promise.reject(p4)
				end

				p3:dispatch(SetAgeRecommendation(s1, v22))

				local headerDisplayName = responseBody.headerDisplayName
				local headerDisplayNameShort = responseBody.headerDisplayNameShort

				p3:dispatch(SetAgeRecommendationHeaders(headerDisplayName, headerDisplayNameShort))

				return Promise.resolve(p4)
			end

			Logging.warn("Response from GetAgeRecommendation is malformed!")

			return Promise.reject({
				HttpError = Enum.HttpError.OK
			})
		end, function(p5) -- line: 46
			-- upvalues: p3 (copy), SetNetworkingErrorToast (copy), Promise (copy)
			p3:dispatch(SetNetworkingErrorToast(p5))

			return Promise.reject(p5)
		end)
	end)
end
function t1.GetFetchingStatus(p6, p7) -- line: 53
	-- upvalues: PerformFetch (copy)
	return PerformFetch.GetStatus(p6, "luaapp.experience_guidelines.get-age-guidelines" .. p7)
end

return t1
