local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Players = game:GetService("Players")
local Localization = require(MomentsParent.Localization)
local MomentsTypes = require(MomentsParent.MomentsTypes)
local React = require(MomentsParent.React)
local useLocalization = Localization.Hooks.useLocalization
local MomentsCreation = require(MomentsParent.MomentsCreation)
local publishMomentWithUpload = MomentsCreation.publishMomentWithUpload
local GetFFlagEnableMomentTextGeneration = require(Moments.Flags.GetFFlagEnableMomentTextGeneration)
local GetFFlagMomentsRefreshFromTopAfterUpload = require(Moments.Flags.GetFFlagMomentsRefreshFromTopAfterUpload)
local generateMomentText = require(Moments.generateMomentText)
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
	uploadQuotaReachedBody = "Feature.Moments.Description.TooManyUploads",
	generatedTitle = "Feature.Moments.Label.TextGeneratedTitle",
	generatedBody = "Feature.Moments.Label.TextGeneratedBody",
	generateFailedTitle = "Feature.Moments.Label.TextGenerationFailedTitle",
	generateFailedBody = "Feature.Moments.Label.TextGenerationFailedBody"
}
local v17 = isStudio()
local MomentStatus = MomentsTypes.Enums.MomentStatus

local function makeUploadedMomentItem(n1: number, p1, p2, s1: string, n2: number?) -- line: 61
	-- upvalues: Players (copy), MomentsCreation (copy), MomentStatus (copy)
	local str = tostring(n1)
	local LocalPlayer = Players.LocalPlayer

	return {
		assetId = n1,
		creatorId = LocalPlayer == nil and 0 or LocalPlayer.UserId,
		metadata = {
			assetTotalDuration = if p1.CaptureType ~= Enum.CaptureType.Screenshot then if n2 == nil or not (n2 > 0) then p1.TimeLength else n2 else MomentsCreation.Constants.ScreenshotMusicDuration,
			captureType = p1.CaptureType,
			description = s1,
			edits = p2,
			placeId = p1.SourcePlaceId,
			universeId = p1.SourceUniverseId
		},
		momentId = str,
		recommendationMetadata = {},
		status = MomentStatus.Public
	}
end
local function makeUploadStore(p3, p4, p5, s2: string, n3: number?) -- line: 91
	-- upvalues: GetFFlagMomentsRefreshFromTopAfterUpload (copy), makeUploadedMomentItem (copy)
	if not GetFFlagMomentsRefreshFromTopAfterUpload() then
		return p3
	end

	return {
		setUploading = p3.setUploading,
		setFailed = p3.setFailed,
		setSuccess = function(p6) -- line: 105
			-- upvalues: p3 (copy), makeUploadedMomentItem (copy), p4 (copy), p5 (copy), s2 (copy), n3 (copy)
			if type(p6) ~= "number" then
				p3.setSuccess(p6)

				return
			end

			p3.setSuccess((makeUploadedMomentItem(p6, p4, p5, s2, n3)))
		end
	}
end
local function useUploadHost(t2: {[any]: any}) -- line: 116
	-- upvalues: useLocalization (copy), t1 (copy), React (copy), GetUploadStore (copy), GetToastStore (copy), GetFFlagEnableMomentTextGeneration (copy), generateMomentText (copy), MomentsCreation (copy), v17 (copy), publishMomentWithUpload (copy), makeUploadStore (copy)
	local onExit = t2.onExit
	local captureSource = t2.captureSource
	local v37 = useLocalization(t1)

	return (React.useMemo(function() -- line: 122
		-- upvalues: GetUploadStore (copy), GetToastStore (copy), onExit (copy), captureSource (copy), GetFFlagEnableMomentTextGeneration (copy), generateMomentText (copy), v37 (copy), MomentsCreation (copy), v17 (copy), publishMomentWithUpload (copy), makeUploadStore (copy)
		local v39 = GetUploadStore(false)
		local v40 = GetToastStore(false)

		return {
			exitCreationFlow = onExit,
			captureSource = captureSource,
			generateMomentText = if not GetFFlagEnableMomentTextGeneration() then nil else generateMomentText,
			onGenerateTextSuccess = if not GetFFlagEnableMomentTextGeneration() then nil else function() -- line: 131
				-- upvalues: v40 (copy), v37 (copy)
				v40.triggerToast({
					title = v37.generatedTitle,
					text = v37.generatedBody
				})
			end,
			onGenerateTextFailure = if not GetFFlagEnableMomentTextGeneration() then nil else function() -- line: 136
				-- upvalues: v40 (copy), v37 (copy)
				v40.triggerToast({
					title = v37.generateFailedTitle,
					text = v37.generateFailedBody
				})
			end,
			isTextFiltered = MomentsCreation.isTextFiltered,
			createMoment = not v17 and function(p7, p8, s3: string, s4: string?, n4: number?) -- line: 154
				-- upvalues: publishMomentWithUpload (copy), v37 (copy), makeUploadStore (copy), v39 (copy), v40 (copy)
				publishMomentWithUpload(p7, p8, s3, {
					localizations = v37,
					uploadStore = makeUploadStore(v39, p7, p8, s3, n4),
					toastStore = v40,
					creationSessionId = s4,
					resolvedTimeLength = n4
				})
			end or function(_, _, s5: string, _: string?, _: number?) -- line: 145
				print(`[moments-creation] dev publish (not uploaded): "{ s5 }"`)
			end
		}
	end, {
		onExit,
		captureSource,
		v37
	}))
end

return useUploadHost
