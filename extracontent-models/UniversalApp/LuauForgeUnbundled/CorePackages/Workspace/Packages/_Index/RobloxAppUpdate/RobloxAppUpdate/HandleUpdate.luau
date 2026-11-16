require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppUpdate/RobloxAppUpdate/Types")
local Thunks = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppUpdate/RobloxAppUpdate/Thunks")
local getUpdateMessageType = Thunks.GetUpdateMessageType
local openCentralOverlayForUpdateRequiredPrompt = Thunks.OpenCentralOverlayForUpdateRequiredPrompt
local setNetworkingErrorToast = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppUpdate/RobloxAppToastsRodux").Thunks.SetNetworkingErrorToast

return function(callback, object, p2, p3, p4, callback2)
	callback(getUpdateMessageType(object, p2, p3, p4)):andThen(function(p5)
		if p5 then
			callback(openCentralOverlayForUpdateRequiredPrompt(object:canPerformBinaryUpdate(), false, p5))
		else
			callback2()
		end
	end):catch(function(p5)
		warn(p5)
		callback(setNetworkingErrorToast({ HttpError = Enum.HttpError.OK }))
	end)
end
