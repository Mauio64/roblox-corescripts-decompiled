local parent = script:FindFirstAncestor("CustomForms").Parent

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiInputDataUpdates = SduiSharedUtilities.SduiInputDataUpdates

local function isFormData(p, p2: string): boolean -- 2 equivalent calls inferred from this helper
	local form_definition

	if type(p) == "table" then
		form_definition = p.form_definition
	end

	return type(form_definition) == "table" and form_definition.form_id == p2
end

local function isForm(p, p2: string) -- 2 equivalent calls inferred from this helper
	return isFormData(p.custom_form, p2) -- inferred equivalent call
end

local CustomFormEntry = {}
CustomFormEntry.isFormData = isFormData

function CustomFormEntry.findForm(p: string, p2: string)
	local inputData = SduiInputDataUpdates.findInputData(p, function(p3)
		return isForm(p3, p2) -- inferred equivalent call
	end)

	return if inputData then inputData.custom_form else nil
end

function CustomFormEntry.updateForm(p: string, p2: string, callback)
	return SduiInputDataUpdates.updateInputDataField(p, function(p3)
		return isForm(p3, p2) -- inferred equivalent call
	end, "custom_form", function(p3)
		local v = callback(p3)

		if isFormData(v, p2) then -- inferred equivalent call
			return v
		end

		return nil
	end)
end

return CustomFormEntry
