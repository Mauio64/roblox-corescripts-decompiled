local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local module = require("@luauforge/bundled/fvv")
local module2 = require("@luauforge/bundled/dTh")
local module3 = require("@luauforge/bundled/fvu")
local module4 = require("@luauforge/deferred/gUT")

local module5 = require("@luauforge/bundled/dTb")
local module6 = require("@luauforge/bundled/dTl")
local module7 = require("@luauforge/bundled/dTm")

local function parseFetchPPEConfigResult(responseBody, closeup)
	local emoteAssetId = nil
	local v5 = 1
	local v6 = 0

	local convertThumbnailTypeToInt = module3.ConvertThumbnailTypeToInt(closeup)

	local avatarThumbnailCustomizations = responseBody.avatarThumbnailCustomizations

	if avatarThumbnailCustomizations then
		for k, avatarThumbnailCustomization in avatarThumbnailCustomizations do
			if avatarThumbnailCustomization.thumbnailType ~= convertThumbnailTypeToInt then
				continue
			end

			if
				avatarThumbnailCustomization.emoteAssetId
				and avatarThumbnailCustomization.emoteAssetId ~= 0
			then
				emoteAssetId = tostring(avatarThumbnailCustomization.emoteAssetId)
			end

			if not avatarThumbnailCustomization.camera then
				continue
			end

			local distanceScale = avatarThumbnailCustomization.camera.distanceScale
			v5 = distanceScale == -1 and 1 or distanceScale

			v6 = avatarThumbnailCustomization.camera.yRotDeg
		end
	end

	local sliderValueFromYRotDeg = module3.getSliderValueFromYRotDeg(v6)
	return emoteAssetId, module3.getSliderValueFromCameraDistanceScale(v5), sliderValueFromYRotDeg
end

return function(p2)
	local ppeConfigFetchStatusKey = module.PPEConfigFetchStatusKey

	return performFetch.Single(ppeConfigFetchStatusKey, function(object)
		return module4.FetchPPEConfig(p2):andThen(function(p3)
			local responseBody = p3 and p3.responseBody

			if not responseBody then
				return Promise.reject()
			end

			local v5, v6, v7 = parseFetchPPEConfigResult(responseBody, module2.Closeup)

			object:dispatch(module5(v5))

			if v6 then
				object:dispatch(module6(v6))
			end

			if v7 then
				object:dispatch(module7(v7))
			end

			return Promise.resolve()
		end, function(p3)
			logging.warn("WebApi failure in FetchPPEConfig")

			return Promise.reject(p3)
		end)
	end)
end
