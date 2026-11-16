local GameDetailRodux = script:FindFirstAncestor("GameDetailRodux")
local parent = GameDetailRodux.Parent

local AppCommonLib = require(parent.AppCommonLib)
local Logging = AppCommonLib.Logging
local Promise = require(parent.Promise)

local AgeRecommendationDetails = require(GameDetailRodux.AgeRecommendations.AgeRecommendationDetails)

local Http = require(parent.Http)
local PerformFetch = Http.PerformFetch
local RobloxAppToastsRodux = require(parent.RobloxAppToastsRodux)
local SetNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast
local SetAgeRecommendation = require(GameDetailRodux.AgeRecommendations.SetAgeRecommendation)
local SetAgeRecommendationHeaders = require(GameDetailRodux.AgeRecommendations.SetAgeRecommendationHeaders)
local GetAgeRecommendation = require(GameDetailRodux.AgeRecommendations.GetAgeRecommendation)

local function fetchKeymapper(p) -- 2 equivalent calls inferred from this helper
	return "luaapp.experience_guidelines.get-age-guidelines" .. p
end

local ApiFetchAgeRecommendations = {}

function ApiFetchAgeRecommendations.Fetch(p, p2: string)
	return PerformFetch.Single(fetchKeymapper(p2), function(object) -- inferred equivalent call
		return GetAgeRecommendation(p, p2):andThen(function(p3)
			local responseBody = p3.responseBody

			if responseBody == nil then
				Logging.warn("Response from GetAgeRecommendation is malformed!")
				return Promise.reject({ HttpError = Enum.HttpError.OK })
			end

			local unwrapped, v = AgeRecommendationDetails.fromJsonData(responseBody.ageRecommendationDetails):unwrap()

			if unwrapped == false then
				Logging.warn("Failed to parse AgeRecommendationDetails for `" .. p2 .. "`")
				return Promise.reject(p3)
			end

			object:dispatch(SetAgeRecommendation(p2, v))

			object:dispatch(SetAgeRecommendationHeaders(
				responseBody.headerDisplayName,
				responseBody.headerDisplayNameShort
			))

			return Promise.resolve(p3)
		end, function(p3)
			object:dispatch(SetNetworkingErrorToast(p3))
			return Promise.reject(p3)
		end)
	end)
end

function ApiFetchAgeRecommendations.GetFetchingStatus(p, p2)
	return PerformFetch.GetStatus(p, fetchKeymapper(p2)) -- inferred equivalent call
end

return ApiFetchAgeRecommendations
