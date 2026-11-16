local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent

local React = require(parent.React)

local getAppStorageService = require(EditProfile.Common.getAppStorageService)

local function useProfileFramesNewLabel()
	local appStorageService = getAppStorageService()
	local state, setState = React.useState(function()
		local success, result = pcall(function()
			return appStorageService:GetItem("ProfileFramesNewLabelSeen")
		end)

		return success and result ~= "true"
	end)

	return state, (React.useCallback(function()
		setState(false)
		pcall(function()
			appStorageService:SetItem("ProfileFramesNewLabelSeen", "true")
			appStorageService:Flush()
		end)
	end, { appStorageService }))
end

return useProfileFramesNewLabel
