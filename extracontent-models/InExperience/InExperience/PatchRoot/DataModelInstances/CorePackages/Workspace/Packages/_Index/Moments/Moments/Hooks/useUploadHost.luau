local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Players = game:GetService("Players")
local Localization = require(MomentsParent.Localization)
local MomentsTypes = require(MomentsParent.MomentsTypes)
local React = require(MomentsParent.React)
local useLocalization = Localization.Hooks.useLocalization
local MomentsCreation = require(MomentsParent.MomentsCreation)
local publishMomentWithUpload = MomentsCreation.publishMomentWithUpload
local GetFFlagMomentsRefreshFromTopAfterUpload = require(Moments.Flags.GetFFlagMomentsRefreshFromTopAfterUpload)
local GetUploadStore = require(Moments.Stores.GetUploadStore)
local GetToastStore = require(Moments.Stores.GetToastStore)
local isStudio = require(MomentsParent.MomentsCommon.isStudio)
local t1 = {
	publishingTitle = "Feature.Moments.Label.RodeoPublishingTitle",
	publishingBody = "Feature.Moments.Label.PublishingRodeoBody",
	publishedTitle = "Feature.Moments.Label.MomentPublishedTitle",
	publishedBody = "Feature.Moments.Label.MomentPublishedBody",
	failedTitle = "Feature.Moments.Label.MomentFailedToPostTitle",
	failedBody = "Feature.Moments.Label.MomentFailedToPostBody",
	removedTitle = "Feature.Moments.Title.MomentRemoved",
	removedBody = "Feature.Moments.Label.PostRemovedBody",
	uploadQuotaReachedBody = "Feature.Moments.Description.TooManyUploads"
}
local v15 = isStudio()
local MomentStatus = MomentsTypes.Enums.MomentStatus

local function makeUploadedMomentItem(n1: number, p1, p2, s1: string) -- line: 56
	-- upvalues: Players (copy), MomentStatus (copy)
	local str = tostring(n1)
	local LocalPlayer = Players.LocalPlayer

	return {
		assetId = n1,
		creatorId = LocalPlayer == nil and 0 or LocalPlayer.UserId,
		metadata = {
			assetTotalDuration = if p1.CaptureType ~= Enum.CaptureType.Screenshot then p1.TimeLength else 7,
			captureType = p1.CaptureType,
			description = s1,
			edits = p2,
			placeId = p1.SourcePlaceId,
			universeId = p1.SourceUniverseId
		},
		momentId = str,
		recommendationMetadata = {
			itemId = str
		},
		status = MomentStatus.Public
	}
end
local function makeUploadStore(p3, p4, p5, s2: string) -- line: 80
	-- upvalues: GetFFlagMomentsRefreshFromTopAfterUpload (copy), makeUploadedMomentItem (copy)
	if not GetFFlagMomentsRefreshFromTopAfterUpload() then
		return p3
	end

	return {
		setUploading = p3.setUploading,
		setFailed = p3.setFailed,
		setSuccess = function(p6) -- line: 88
			-- upvalues: p3 (copy), makeUploadedMomentItem (copy), p4 (copy), p5 (copy), s2 (copy)
			if type(p6) ~= "number" then
				p3.setSuccess(p6)

				return
			end

			p3.setSuccess((makeUploadedMomentItem(p6, p4, p5, s2)))
		end
	}
end
local function useUploadHost(t2: {[any]: any}) -- line: 99
	-- upvalues: useLocalization (copy), t1 (copy), React (copy), GetUploadStore (copy), GetToastStore (copy), MomentsCreation (copy), v15 (copy), publishMomentWithUpload (copy), makeUploadStore (copy)
	local onExit = t2.onExit
	local captureSource = t2.captureSource
	local v33 = useLocalization(t1)

	return (React.useMemo(function() -- line: 105
		-- upvalues: GetUploadStore (copy), GetToastStore (copy), onExit (copy), captureSource (copy), MomentsCreation (copy), v15 (copy), publishMomentWithUpload (copy), v33 (copy), makeUploadStore (copy)
		local v35 = GetUploadStore(false)
		local v36 = GetToastStore(false)

		return {
			exitCreationFlow = onExit,
			captureSource = captureSource,
			isTextFiltered = MomentsCreation.isTextFiltered,
			createMoment = not v15 and function(p7, p8, s3: string, s4: string?) -- line: 117
				-- upvalues: publishMomentWithUpload (copy), v33 (copy), makeUploadStore (copy), v35 (copy), v36 (copy)
				publishMomentWithUpload(p7, p8, s3, {
					localizations = v33,
					uploadStore = makeUploadStore(v35, p7, p8, s3),
					toastStore = v36,
					creationSessionId = s4
				})
			end or function(_, _, s5: string, _: string?) -- line: 114
				print(`[moments-creation] dev publish (not uploaded): "{ s5 }"`)
			end
		}
	end, {
		onExit,
		captureSource,
		v33
	}))
end

return useUploadHost
