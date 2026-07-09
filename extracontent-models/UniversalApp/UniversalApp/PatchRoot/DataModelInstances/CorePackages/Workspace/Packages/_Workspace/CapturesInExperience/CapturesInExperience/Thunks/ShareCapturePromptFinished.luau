local ParentParent = script.Parent.Parent
local CaptureService = require(ParentParent.Services.CaptureService)
local ExternalShareSourceType = require(ParentParent.Enums.ExternalShareSourceType)
local PromptDismissed = require(ParentParent.Actions.PromptDismissed)
local ShareCapture = require(ParentParent.Thunks.ShareCapture)
local ToastTriggered = require(ParentParent.Actions.ToastTriggered)
local CapturesToastType = require(ParentParent.Enums.CapturesToastType)
local CaptureType = require(ParentParent.Enums.CaptureType)

require(ParentParent.Types)

local v9 = game:DefineFastFlag("CapturesPromptShareImageFixEnabled", false)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

return function(p1, p2, b1: boolean) -- line: 20
	-- upvalues: PromptDismissed (copy), CaptureService (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), ToastTriggered (copy), CapturesToastType (copy), v9 (copy), ShareCapture (copy), ExternalShareSourceType (copy)
	return function(p3) -- line: 21
		-- upvalues: PromptDismissed (copy), p1 (copy), b1 (copy), p2 (copy), CaptureService (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), ToastTriggered (copy), CapturesToastType (copy), v9 (copy), ShareCapture (copy), ExternalShareSourceType (copy)
		p3:dispatch(PromptDismissed(p1))

		if b1 then
			if p2.isU13LocalSavePrompt then
				task.spawn(function() -- line: 26
					-- upvalues: p2 (copy), CaptureService (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), p3 (copy), ToastTriggered (copy), CapturesToastType (copy)
					local content = p2.content
					local connection = nil

					connection = CaptureService.CaptureSavedInternal:Connect(function(p4) -- line: 30
						-- upvalues: content (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), connection (ref), CaptureService (copy), p3 (copy), ToastTriggered (copy), CapturesToastType (copy)
						if content.Object ~= nil then
							if FFlagEnableCapturesGalleryRetrievalCoreScript then
								if p4.CaptureTime ~= content.Object.CaptureTime then
									return
								end
							elseif p4.type == CaptureType.Video and p4.videoCapture.CaptureTime ~= content.Object.CaptureTime then
								return
							end
						end

						local v22 = if not FFlagEnableCapturesGalleryRetrievalCoreScript then if p4.type ~= CaptureType.Video then p4.filePath else p4.videoCapture else p4

						if connection then
							connection:Disconnect()
						end

						CaptureService:SaveCapturesToExternalStorageAsync({ v22 })
						p3:dispatch(ToastTriggered(CapturesToastType.CaptureSavedToDevice, {
							captureInfo = v22
						}))
					end)
					CaptureService:GetCaptureFilePathAsync(p2.content)
				end)
			else
				task.spawn(function() -- line: 67
					-- upvalues: CaptureService (copy), p2 (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), v9 (copy), CaptureType (copy), p3 (copy), ShareCapture (copy), ExternalShareSourceType (copy)
					local CaptureFilePathAsync = CaptureService:GetCaptureFilePathAsync(p2.content)
					local content = p2.content
					local v19 = content.Object ~= nil and content.Object:IsA("VideoCapture")
					local v20 = if not FFlagEnableCapturesGalleryRetrievalCoreScript or not (not v9 or content.Object ~= nil) then {
						contentId = content.Uri or "rbxtemp://0",
						filePath = if not v19 then CaptureFilePathAsync else "",
						type = if not v19 then CaptureType.Screenshot else CaptureType.Video,
						videoCapture = if not v19 then nil else content.Object
					} else content.Object

					p3:dispatch(ShareCapture(v20, ExternalShareSourceType.Prompt, p2.launchData))
				end)
			end
		end

		CaptureService:OnSharePromptFinished(p1, b1)
	end
end
