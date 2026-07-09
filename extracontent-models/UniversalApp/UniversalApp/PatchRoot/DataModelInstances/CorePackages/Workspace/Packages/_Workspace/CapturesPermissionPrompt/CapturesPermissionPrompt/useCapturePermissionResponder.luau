local CaptureService = game:GetService("CaptureService")
local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)

local function useCapturePermissionResponder() -- line: 33
	-- upvalues: React (copy), CaptureService (copy)
	local v5, v6 = React.useState(nil)
	local v7, v8 = React.useState(nil)

	React.useEffect(function() -- line: 37
		-- upvalues: CaptureService (copy), v6 (copy), v8 (copy)
		if not game:GetEngineFeature("CaptureServiceGalleryPermissionPrompt") then
			return
		end

		local connection = CaptureService.OpenCapturePermissionsPrompt:Connect(function(n1: number, p1) -- line: 42
			-- upvalues: v6 (copy), v8 (copy)
			v6(n1)
			v8(p1)
		end)

		return function() -- line: 47
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	local v9 = React.useCallback(function(b1: boolean) -- line: 52
		-- upvalues: v5 (copy), CaptureService (copy), v6 (copy), v8 (copy)
		if v5 == nil then
			return
		end

		CaptureService:OnCapturePermissionsPromptFinished(v5, b1)
		v6(nil)
		v8(nil)
	end, { v5 })

	return {
		promptId = v5,
		permission = v7,
		respond = v9
	}
end

return useCapturePermissionResponder
