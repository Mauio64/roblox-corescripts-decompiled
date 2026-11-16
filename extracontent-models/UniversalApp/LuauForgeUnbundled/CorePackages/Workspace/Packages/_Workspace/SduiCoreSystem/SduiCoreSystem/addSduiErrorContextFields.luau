require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")

local function addSduiErrorContextFields(p2, data)
	if data then
		p2.fullName = data.fullName
		p2.rctPath = data.rctPath
		p2.templateId = data.templateId
	end
end

return addSduiErrorContextFields
