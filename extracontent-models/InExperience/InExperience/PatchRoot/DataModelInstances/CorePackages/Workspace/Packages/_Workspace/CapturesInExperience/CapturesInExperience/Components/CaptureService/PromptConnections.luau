local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local CaptureService = require(ParentParent.Services.CaptureService)
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local ReactUtils = require(ParentParentParent.ReactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEventConnection = ReactUtils.useEventConnection
local CapturesPolicy = require(ParentParent.App.CapturesPolicy)
local PromptTriggered = require(ParentParent.Actions.PromptTriggered)
local PromptType = require(ParentParent.Enums.PromptType)

require(ParentParent.Types)

local ToastTriggered = require(ParentParent.Actions.ToastTriggered)
local CapturesToastType = require(ParentParent.Enums.CapturesToastType)
local CaptureType = require(ParentParent.Enums.CaptureType)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)
local FFlagCapturesEnableDownloadPromptForU13 = require(ParentParent.Flags.FFlagCapturesEnableDownloadPromptForU13)

return (CapturesPolicy.connect(function(p1) -- line: 105
	return {
		enableShareCaptureCTA = p1.enableShareCaptureCTA()
	}
end)(function(t1: {[any]: any}) -- line: 30
	-- upvalues: useDispatch (copy), React (copy), PromptTriggered (copy), PromptType (copy), useEventConnection (copy), CaptureService (copy), FFlagCapturesEnableDownloadPromptForU13 (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), ToastTriggered (copy), CapturesToastType (copy)
	local v18 = useDispatch()
	local v19 = React.useCallback(function(n1: number, t2: {[any]: any}) -- line: 33
		-- upvalues: v18 (copy), PromptTriggered (copy), PromptType (copy)
		local t3 = {
			contents = t2
		}

		v18(PromptTriggered(n1, PromptType.SaveCaptures, t3))
	end, {})

	useEventConnection(CaptureService.OpenSaveCapturesPrompt, v19)

	local v20 = React.useCallback(function(n2: number, p2, s1: string) -- line: 43
		-- upvalues: FFlagCapturesEnableDownloadPromptForU13 (copy), t1 (copy), v18 (copy), PromptTriggered (copy), PromptType (copy), CaptureService (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), ToastTriggered (copy), CapturesToastType (copy)
		local v29 = FFlagCapturesEnableDownloadPromptForU13 and not t1.enableShareCaptureCTA
		local t4 = {
			content = p2,
			isU13LocalSavePrompt = v29,
			launchData = s1
		}
		local connection = nil

		if FFlagCapturesEnableDownloadPromptForU13 or t1.enableShareCaptureCTA then
			v18(PromptTriggered(n2, PromptType.ShareCapture, t4))
		else
			connection = CaptureService.CaptureSavedInternal:Connect(function(p3) -- line: 55
				-- upvalues: p2 (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), connection (ref), CaptureService (copy), v18 (copy), ToastTriggered (copy), CapturesToastType (copy)
				if p2.Object ~= nil then
					if FFlagEnableCapturesGalleryRetrievalCoreScript then
						if p3.CaptureTime ~= p2.Object.CaptureTime then
							return
						end
					elseif p3.type == CaptureType.Video and p3.videoCapture.CaptureTime ~= p2.Object.CaptureTime then
						return
					end
				end

				local v35 = if not FFlagEnableCapturesGalleryRetrievalCoreScript then if p3.type ~= CaptureType.Video then p3.filePath else p3.videoCapture else p3

				if connection then
					connection:Disconnect()
				end

				CaptureService:SaveCapturesToExternalStorageAsync({ v35 })
				v18(ToastTriggered(CapturesToastType.CaptureSavedToDevice, {
					captureInfo = v35
				}))
			end)
			CaptureService:GetCaptureFilePathAsync(p2)
		end
	end, { t1.enableShareCaptureCTA })

	useEventConnection(CaptureService.OpenShareCapturePrompt, v20)

	local v21 = React.useCallback(function(p4, _) -- line: 93
		-- upvalues: v18 (copy), PromptTriggered (copy), PromptType (copy)
		v18(PromptTriggered(p4, PromptType.CapturePermissions, {}))
	end, {})

	if game:GetEngineFeature("CaptureServiceGalleryPermissionPrompt") then
		useEventConnection(CaptureService.OpenCapturePermissionsPrompt, v21)
	end

	return React.createElement(React.Fragment, {}, {})
end))
