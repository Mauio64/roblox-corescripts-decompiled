local RobloxAppUpdate = script:FindFirstAncestor("RobloxAppUpdate")
local RobloxAppUpdateParent = RobloxAppUpdate.Parent

require(RobloxAppUpdate.Types)

local Thunks = require(RobloxAppUpdate.Thunks)
local GetUpdateMessageType = Thunks.GetUpdateMessageType
local OpenCentralOverlayForUpdateRequiredPrompt = Thunks.OpenCentralOverlayForUpdateRequiredPrompt
local SetNetworkingErrorToast = require(RobloxAppUpdateParent.RobloxAppToastsRodux).Thunks.SetNetworkingErrorToast

return function(p1, p2, b1: boolean, p3, s1: string, p4) -- line: 9
	-- upvalues: GetUpdateMessageType (copy), OpenCentralOverlayForUpdateRequiredPrompt (copy), SetNetworkingErrorToast (copy)
	p1(GetUpdateMessageType(p2, b1, p3, s1)):andThen(function(p5) -- line: 18
		-- upvalues: p1 (copy), OpenCentralOverlayForUpdateRequiredPrompt (copy), p2 (copy), p4 (copy)
		if p5 then
			p1(OpenCentralOverlayForUpdateRequiredPrompt(p2:canPerformBinaryUpdate(), false, p5))

			return
		end

		p4()
	end):catch(function(p6) -- line: 31
		-- upvalues: p1 (copy), SetNetworkingErrorToast (copy)
		warn(p6)
		p1(SetNetworkingErrorToast({
			HttpError = Enum.HttpError.OK
		}))
	end)
end
