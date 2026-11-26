local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/AppCommonLib").Logging
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Promise")

local AgeRecommendationDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/AgeRecommendations/AgeRecommendationDetails")

local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Http").PerformFetch
local setNetworkingErrorToast = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/RobloxAppToastsRodux").Thunks.SetNetworkingErrorToast
local SetAgeRecommendation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/AgeRecommendations/SetAgeRecommendation")
local SetAgeRecommendationHeaders = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/AgeRecommendations/SetAgeRecommendationHeaders")
local GetAgeRecommendation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/AgeRecommendations/GetAgeRecommendation")

local function fetchKeymapper(p2)
	return "luaapp.experience_guidelines.get-age-guidelines" .. p2
end

return {
	Fetch = function(p2, p3)
		return performFetch.Single("luaapp.experience_guidelines.get-age-guidelines" .. p3, function(object)
			return GetAgeRecommendation(p2, p3):andThen(function(p4)
				local responseBody = p4.responseBody

				if responseBody == nil then
					logging.warn("Response from GetAgeRecommendation is malformed!")
					return Promise.reject({ HttpError = Enum.HttpError.OK })
				end

				local unwrapped, v6 = AgeRecommendationDetails.fromJsonData(responseBody.ageRecommendationDetails):unwrap()

				if unwrapped == false then
					logging.warn("Failed to parse AgeRecommendationDetails for `" .. p3 .. "`")
					return Promise.reject(p4)
				end

				object:dispatch(SetAgeRecommendation(p3, v6))

				object:dispatch(SetAgeRecommendationHeaders(responseBody.headerDisplayName, responseBody.headerDisplayNameShort))

				return Promise.resolve(p4)
			end, function(p4)
				object:dispatch(setNetworkingErrorToast(p4))
				return Promise.reject(p4)
			end)
		end)
	end,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.experience_guidelines.get-age-guidelines" .. p3)
	end
}
