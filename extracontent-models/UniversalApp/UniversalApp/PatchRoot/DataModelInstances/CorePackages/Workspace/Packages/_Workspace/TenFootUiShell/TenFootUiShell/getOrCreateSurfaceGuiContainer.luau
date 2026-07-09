local CoreGui = game:GetService("CoreGui")
local TenFootUiShell = script:FindFirstAncestor("TenFootUiShell")
local Constants = require(TenFootUiShell.Constants)

local function getOrCreateSurfaceGuiContainer() -- line: 5
	-- upvalues: CoreGui (copy), Constants (copy)
	local ConstantsSURFACE_GUI_FOLDER_NAME = CoreGui:FindFirstChild(Constants.SURFACE_GUI_FOLDER_NAME)

	if not ConstantsSURFACE_GUI_FOLDER_NAME then
		ConstantsSURFACE_GUI_FOLDER_NAME = Instance.new("Folder")
		ConstantsSURFACE_GUI_FOLDER_NAME.Name = Constants.SURFACE_GUI_FOLDER_NAME
		ConstantsSURFACE_GUI_FOLDER_NAME.Parent = CoreGui
	end

	return ConstantsSURFACE_GUI_FOLDER_NAME
end

return getOrCreateSurfaceGuiContainer
