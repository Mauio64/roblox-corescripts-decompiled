local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local CaptureService = require(parent.Services.CaptureService)

local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local ReactUtils = require(parent2.ReactUtils)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEventConnection = ReactUtils.useEventConnection

local CapturesPolicy = require(parent.App.CapturesPolicy)
local PromptTriggered = require(parent.Actions.PromptTriggered)
local PromptType = require(parent.Enums.PromptType)
require(parent.Types)
local ToastTriggered = require(parent.Actions.ToastTriggered)
local CapturesToastType = require(parent.Enums.CapturesToastType)
local CaptureType = require(parent.Enums.CaptureType)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

local FFlagCapturesEnableDownloadPromptForU13 = require(parent.Flags.FFlagCapturesEnableDownloadPromptForU13)

return (CapturesPolicy.connect(function(p)
	return { enableShareCaptureCTA = p.enableShareCaptureCTA() }
end)(function(p)
	local v = useDispatch()

	local v2 = React.useCallback(function(p2: number, contents)
		v(PromptTriggered(p2, PromptType.SaveCaptures, { contents = contents }))
	end, {})

	useEventConnection(CaptureService.OpenSaveCapturesPrompt, v2)

	local v3 = React.useCallback(function(p2: number, content, launchData: string)
		local v3 = {
			content = content,
			isU13LocalSavePrompt = FFlagCapturesEnableDownloadPromptForU13 and not p.enableShareCaptureCTA,
			launchData = launchData
		}

		local captureSavedInternalConnection = nil

		if FFlagCapturesEnableDownloadPromptForU13 or p.enableShareCaptureCTA then
			v(PromptTriggered(p2, PromptType.ShareCapture, v3))
		else
			captureSavedInternalConnection = CaptureService.CaptureSavedInternal:Connect(function(captureInfo)
				if content.Object ~= nil then
					if FFlagEnableCapturesGalleryRetrievalCoreScript then
						if captureInfo.CaptureTime ~= content.Object.CaptureTime then
							return
						end
					elseif
						captureInfo.type == CaptureType.Video
						and captureInfo.videoCapture.CaptureTime ~= content.Object.CaptureTime
					then
						return
					end
				end

				if not FFlagEnableCapturesGalleryRetrievalCoreScript then
					if captureInfo.type == CaptureType.Video then
						captureInfo = captureInfo.videoCapture
					else
						captureInfo = captureInfo.filePath
					end
				end

				if captureSavedInternalConnection then
					captureSavedInternalConnection:Disconnect()
				end

				CaptureService:SaveCapturesToExternalStorageAsync({ captureInfo })
				v(ToastTriggered(CapturesToastType.CaptureSavedToDevice, {
					captureInfo = captureInfo
				}))
			end)
			CaptureService:GetCaptureFilePathAsync(content)
		end
	end, { p.enableShareCaptureCTA })

	useEventConnection(CaptureService.OpenShareCapturePrompt, v3)

	local v4 = React.useCallback(function(p2, _)
		v(PromptTriggered(p2, PromptType.CapturePermissions, {}))
	end, {})

	if game:GetEngineFeature("CaptureServiceGalleryPermissionPrompt") then
		useEventConnection(CaptureService.OpenCapturePermissionsPrompt, v4)
	end

	return React.createElement(React.Fragment, {}, {})
end))
