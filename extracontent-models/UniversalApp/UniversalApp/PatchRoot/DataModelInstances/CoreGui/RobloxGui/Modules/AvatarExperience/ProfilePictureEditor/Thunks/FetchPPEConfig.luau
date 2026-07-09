local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Constants = require(Modules.AvatarExperience.ProfilePictureEditor.Constants)
local PPEThumbnailType = require(Modules.AvatarExperience.ProfilePictureEditor.PPEThumbnailType)
local Utils = require(Modules.AvatarExperience.ProfilePictureEditor.Utils)
local WebApi = require(Modules.AvatarExperience.ProfilePictureEditor.Http.WebApi)
local SetEmoteAssetId = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetEmoteAssetId)
local SetCameraSliderZoom = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetCameraSliderZoom)
local SetCameraSliderRotate = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetCameraSliderRotate)

local function parseFetchPPEConfigResult(p1, p2) -- line: 19
	-- upvalues: Utils (copy)
	local str = nil
	local n1 = 1
	local n2 = 0
	local v19 = Utils.ConvertThumbnailTypeToInt(p2)
	local avatarThumbnailCustomizations = p1.avatarThumbnailCustomizations

	if avatarThumbnailCustomizations then
		for _, v22 in avatarThumbnailCustomizations do
			if v19 == v22.thumbnailType then
				if v22.emoteAssetId and v22.emoteAssetId ~= 0 then
					str = tostring(v22.emoteAssetId)
				end

				if v22.camera then
					n1 = v22.camera.distanceScale

					if n1 == -1 then
						n1 = 1
					end

					n2 = v22.camera.yRotDeg
				end
			end
		end
	end

	local v23 = Utils.getSliderValueFromYRotDeg(n2)

	return str, Utils.getSliderValueFromCameraDistanceScale(n1), v23
end

return function(p3) -- line: 52
	-- upvalues: Constants (copy), PerformFetch (copy), WebApi (copy), parseFetchPPEConfigResult (copy), PPEThumbnailType (copy), SetEmoteAssetId (copy), SetCameraSliderZoom (copy), SetCameraSliderRotate (copy), Promise (copy), Logging (copy)
	local PPEConfigFetchStatusKey = Constants.PPEConfigFetchStatusKey

	return PerformFetch.Single(PPEConfigFetchStatusKey, function(p4) -- line: 65
		-- upvalues: WebApi (copy), p3 (copy), parseFetchPPEConfigResult (copy), PPEThumbnailType (copy), SetEmoteAssetId (copy), SetCameraSliderZoom (copy), SetCameraSliderRotate (copy), Promise (copy), Logging (copy)
		return WebApi.FetchPPEConfig(p3):andThen(function(p5) -- line: 66
			-- upvalues: parseFetchPPEConfigResult (copy), PPEThumbnailType (copy), p4 (copy), SetEmoteAssetId (copy), SetCameraSliderZoom (copy), SetCameraSliderRotate (copy), Promise (copy)
			local v28 = p5 and p5.responseBody

			if v28 then
				local v29, v30, v31 = parseFetchPPEConfigResult(v28, PPEThumbnailType.Closeup)

				p4:dispatch(SetEmoteAssetId(v29))

				if v30 then
					p4:dispatch(SetCameraSliderZoom(v30))
				end

				if v31 then
					p4:dispatch(SetCameraSliderRotate(v31))
				end

				return Promise.resolve()
			end

			return Promise.reject()
		end, function(p6) -- line: 88
			-- upvalues: Logging (copy), Promise (copy)
			Logging.warn("WebApi failure in FetchPPEConfig")

			return Promise.reject(p6)
		end)
	end)
end
