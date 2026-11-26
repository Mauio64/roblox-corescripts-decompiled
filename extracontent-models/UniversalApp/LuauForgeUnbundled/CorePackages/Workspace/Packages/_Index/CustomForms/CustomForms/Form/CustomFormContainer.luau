local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/React")

local CustomFormView = require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Form/CustomFormView")
local CustomFormSelection = require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Form/CustomFormSelection")
local useCustomFormViewModel = require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Form/useCustomFormViewModel")

local function CustomFormBody(p2)
	local v5 = useCustomFormViewModel(p2)
	return React.createElement(CustomFormView, v5)
end

local function CustomFormContainer(p2)
	local clone = table.clone(p2)

	clone.key = `{module3.draftKey(p2.definition)}:{p2.response ~= nil}`
	return React.createElement(CustomFormBody, clone)
end

return React.memo(CustomFormContainer)
