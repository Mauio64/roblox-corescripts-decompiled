require(script.Parent.SduiErrors)

local function addSduiErrorContextFields(p, data)
	if data then
		p.fullName = data.fullName
		p.rctPath = data.rctPath
		p.templateId = data.templateId
	end
end

return addSduiErrorContextFields
