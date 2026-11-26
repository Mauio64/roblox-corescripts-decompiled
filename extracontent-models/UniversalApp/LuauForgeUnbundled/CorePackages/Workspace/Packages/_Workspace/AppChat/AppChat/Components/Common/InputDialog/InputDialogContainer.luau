local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local InputDialogView = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Common/InputDialog/InputDialogView")
local useInputDialogViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Common/InputDialog/useInputDialogViewModel")

local function InputDialogContainer(p2)
	local v5 = useInputDialogViewModel(p2)
	return React.createElement(InputDialogView, v5)
end

return InputDialogContainer
