local CaptureService = game:GetService("CaptureService")

local parent = script.Parent.Parent
local parent2 = parent.Parent

local ToastTriggered = require(parent.Actions.ToastTriggered)
local CapturesToastType = require(parent.Enums.CapturesToastType)
local FFlagCapturesInExpUseMomentsCreation = require(parent.Flags.FFlagCapturesInExpUseMomentsCreation)
local FFlagCapturesInExpMomentFailedToast = require(parent.Flags.FFlagCapturesInExpMomentFailedToast)

if FFlagCapturesInExpUseMomentsCreation then
	local MomentsCreation = require(parent2.MomentsCreation)
	require(parent2.MomentsTypes)
	local publishMomentWithTags = MomentsCreation.publishMomentWithTags

	return function(p, p2, p3, p4: string?, p5: number?, flag: boolean?)
		return function(object)
			if publishMomentWithTags(p, p2, p3, p4, p5, flag, FFlagCapturesInExpMomentFailedToast and function()
				object:dispatch(ToastTriggered(CapturesToastType.MomentFailed))
			end or nil) then
				object:dispatch(ToastTriggered(CapturesToastType.MomentProcessing))
			end
		end
	end
else
	require(parent2.MomentsCreationFlow)
	local MomentsCreation = require(parent2.MomentsCreation)
	local MomentsCommon = require(parent2.MomentsCommon)
	require(parent2.MomentsTypes)
	local normalizeMomentMetadata = require(parent.Utils.normalizeMomentMetadata)

	local getFFlagMomentsUseUploadPostAsync = MomentsCommon.Flags.GetFFlagMomentsUseUploadPostAsync
	local getFFlagMomentsUseMomentsServiceForUpload = MomentsCommon.Flags.GetFFlagMomentsUseMomentsServiceForUpload
	local makePostMetadata = MomentsCreation.makePostMetadata

	return function(p, p2, p3, p4)
		return function(object)
			local momentMetadata = normalizeMomentMetadata(p2)

			if getFFlagMomentsUseUploadPostAsync() then
				local v

				if getFFlagMomentsUseMomentsServiceForUpload() then
					v = p
				end

				local v2 = makePostMetadata(p2, v)
				pcall(function()
					if getFFlagMomentsUseMomentsServiceForUpload() then
						(p4 or game:GetService("MomentsService")):CreatePostAsync(v2)
					else
						CaptureService:UploadPostAsync(p, v2)
					end
				end)
			else
				pcall(function()
					CaptureService:UploadCaptureAndPostMoment(p, momentMetadata, p3)
				end)
			end

			object:dispatch(ToastTriggered(CapturesToastType.MomentProcessing))
		end
	end
end
