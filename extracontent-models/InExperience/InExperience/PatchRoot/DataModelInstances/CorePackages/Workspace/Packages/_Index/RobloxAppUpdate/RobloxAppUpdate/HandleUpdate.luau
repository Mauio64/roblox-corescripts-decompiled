local RobloxAppUpdate = script:FindFirstAncestor("RobloxAppUpdate")
local parent = RobloxAppUpdate.Parent
require(RobloxAppUpdate.Types)
local Thunks = require(RobloxAppUpdate.Thunks)
local GetUpdateMessageType = Thunks.GetUpdateMessageType
local OpenCentralOverlayForUpdateRequiredPrompt = Thunks.OpenCentralOverlayForUpdateRequiredPrompt
local RobloxAppToastsRodux = require(parent.RobloxAppToastsRodux)
local SetNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast

return function(callback, object, flag: boolean, p, p2: string, callback2)
	callback(GetUpdateMessageType(object, flag, p, p2)):andThen(function(p3)
		if p3 then
			callback(OpenCentralOverlayForUpdateRequiredPrompt(object:canPerformBinaryUpdate(), false, p3))
		else
			callback2()
		end
	end):catch(function(p3)
		warn(p3)
		callback(SetNetworkingErrorToast({ HttpError = Enum.HttpError.OK }))
	end)
end
