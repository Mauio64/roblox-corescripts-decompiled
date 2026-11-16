local sduiInputDataUpdates = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/SduiSharedUtilities").SduiInputDataUpdates

local function isForm(p2, p3): boolean
	local custom_form = p2.custom_form
	local form_definition = if type(custom_form) == "table" then custom_form.form_definition else nil
	return type(form_definition) == "table" and form_definition.form_id == p3
end

return {
	isFormData = function(p2, p3): boolean
		local form_definition = if type(p2) == "table" then p2.form_definition else nil
		return type(form_definition) == "table" and form_definition.form_id == p3
	end,
	findForm = function(p2, p3)
		local inputData = sduiInputDataUpdates.findInputData(p2, function(p4): boolean
			local custom_form = p4.custom_form
			local form_definition = if type(custom_form) == "table" then custom_form.form_definition else nil
			return type(form_definition) == "table" and form_definition.form_id == p3
		end)

		if inputData then
			return inputData.custom_form
		end

		return nil
	end,
	updateForm = function(p2, p3, callback)
		return sduiInputDataUpdates.updateInputDataField(p2, function(p4): boolean
			local custom_form = p4.custom_form
			local form_definition = if type(custom_form) == "table" then custom_form.form_definition else nil
			return type(form_definition) == "table" and form_definition.form_id == p3
		end, "custom_form", function(p4)
			local v5 = callback(p4)
			local v6 = p3
			local form_definition = if type(v5) == "table" then v5.form_definition else nil
			local v7 = type(form_definition) == "table" and form_definition.form_id == v6

			if v7 then
				return v5
			end

			return nil
		end)
	end
}
