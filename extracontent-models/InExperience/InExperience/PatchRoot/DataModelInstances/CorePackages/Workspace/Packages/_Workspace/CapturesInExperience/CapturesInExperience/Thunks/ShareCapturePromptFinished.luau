local parent = script.Parent.Parent

local CaptureService = require(parent.Services.CaptureService)

local ExternalShareSourceType = require(parent.Enums.ExternalShareSourceType)
local PromptDismissed = require(parent.Actions.PromptDismissed)
local ShareCapture = require(parent.Thunks.ShareCapture)
local ToastTriggered = require(parent.Actions.ToastTriggered)

local CapturesToastType = require(parent.Enums.CapturesToastType)
local CaptureType = require(parent.Enums.CaptureType)
require(parent.Types)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

return function(p, data, flag: boolean)
	return function(object)
		object:dispatch(PromptDismissed(p))

		if flag then
			if data.isU13LocalSavePrompt then
				task.spawn(function()
					local content = data.content
					local captureSavedInternalConnection = nil

					captureSavedInternalConnection = CaptureService.CaptureSavedInternal:Connect(function(data2)
						if content.Object ~= nil then
							if FFlagEnableCapturesGalleryRetrievalCoreScript then
								if data2.CaptureTime ~= content.Object.CaptureTime then
									return
								end
							elseif
								data2.type == CaptureType.Video
								and data2.videoCapture.CaptureTime ~= content.Object.CaptureTime
							then
								return
							end
						end

						if not FFlagEnableCapturesGalleryRetrievalCoreScript then
							if data2.type == CaptureType.Video then
								data2 = data2.videoCapture
							else
								data2 = data2.filePath
							end
						end

						if captureSavedInternalConnection then
							captureSavedInternalConnection:Disconnect()
						end

						CaptureService:SaveCapturesToExternalStorageAsync({ data2 })
						object:dispatch(ToastTriggered(CapturesToastType.CaptureSavedToDevice, {
							captureInfo = data2
						}))
					end)

					CaptureService:GetCaptureFilePathAsync(data.content)
				end)
			else
				task.spawn(function()
					local captureFilePathAsync = CaptureService:GetCaptureFilePathAsync(data.content)

					local content = data.content
					local v

					if content.Object == nil then
						v = false
					else
						v = content.Object:IsA("VideoCapture")
					end

					local v2

					if FFlagEnableCapturesGalleryRetrievalCoreScript and content.Object ~= nil then
						v2 = content.Object
					else
						v2 = {
							contentId = content.Uri or "rbxtemp://0",
							filePath = v and "" or captureFilePathAsync,
							type = 0,
							videoCapture = 0
						}
						local v3

						if v then
							v3 = CaptureType.Video
						else
							v3 = CaptureType.Screenshot
						end

						v2.type = v3
						local videoCapture

						if v then
							videoCapture = content.Object
						end

						v2.videoCapture = videoCapture
					end

					object:dispatch(ShareCapture(v2, ExternalShareSourceType.Prompt, data.launchData))
				end)
			end
		end

		CaptureService:OnSharePromptFinished(p, flag)
	end
end
