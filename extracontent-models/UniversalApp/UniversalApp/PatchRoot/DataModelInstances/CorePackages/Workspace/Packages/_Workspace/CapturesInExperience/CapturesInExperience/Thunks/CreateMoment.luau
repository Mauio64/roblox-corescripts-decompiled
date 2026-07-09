local CaptureService = game:GetService("CaptureService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParentParent.MomentsCreationFlow)
require(ParentParentParent.MomentsTypes)

local normalizeMomentMetadata = require(ParentParent.Utils.normalizeMomentMetadata)
local ToastTriggered = require(ParentParent.Actions.ToastTriggered)
local CapturesToastType = require(ParentParent.Enums.CapturesToastType)

return function(p1, p2, p3) -- line: 15
	-- upvalues: normalizeMomentMetadata (copy), CaptureService (copy), ToastTriggered (copy), CapturesToastType (copy)
	return function(p4) -- line: 20
		-- upvalues: normalizeMomentMetadata (copy), p2 (copy), CaptureService (copy), p1 (copy), p3 (copy), ToastTriggered (copy), CapturesToastType (copy)
		local v11 = normalizeMomentMetadata(p2)

		pcall(function() -- line: 23
			-- upvalues: CaptureService (copy), p1 (copy), v11 (copy), p3 (copy)
			CaptureService:UploadCaptureAndPostMoment(p1, v11, p3)
		end)
		p4:dispatch(ToastTriggered(CapturesToastType.MomentProcessing))
	end
end
