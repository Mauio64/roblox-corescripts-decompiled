local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")

local getAppStorageService = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/getAppStorageService")

local function useProfileFramesNewLabel()
	local v5 = getAppStorageService()
	local state, setState = React.useState(function()
		local success, result = pcall(function()
			return v5:GetItem("ProfileFramesNewLabelSeen")
		end)

		return success and result ~= "true"
	end)

	return state, (React.useCallback(function()
		setState(false)
		pcall(function()
			v5:SetItem("ProfileFramesNewLabelSeen", "true")
			v5:Flush()
		end)
	end, { v5 }))
end

return useProfileFramesNewLabel
