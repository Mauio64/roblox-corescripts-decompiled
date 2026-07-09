local TenFootUiShell = script:FindFirstAncestor("TenFootUiShell")
local Constants = require(TenFootUiShell.Constants)

local function getOrCreateWorkSpaceContainer() -- line: 4
	-- upvalues: Constants (copy)
	local ConstantsWORKSPACE_FOLDER_NAME = workspace:FindFirstChild(Constants.WORKSPACE_FOLDER_NAME)

	if not ConstantsWORKSPACE_FOLDER_NAME then
		ConstantsWORKSPACE_FOLDER_NAME = Instance.new("Folder")
		ConstantsWORKSPACE_FOLDER_NAME.Name = Constants.WORKSPACE_FOLDER_NAME
		ConstantsWORKSPACE_FOLDER_NAME.Parent = workspace
	end

	return ConstantsWORKSPACE_FOLDER_NAME
end

return getOrCreateWorkSpaceContainer
