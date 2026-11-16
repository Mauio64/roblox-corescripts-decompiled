local parent = script:FindFirstAncestor("GroupPeekSdui").Parent

local HttpService = game:GetService("HttpService")
local Http = require(parent.Http)
local Promise = require(parent.Promise)
require(parent.CustomForms)

local getGroupCustomFormUrl = require(script.Parent.getGroupCustomFormUrl)
local groupsFetch = require(script.Parent.groupsFetch)

return function(data)
	local values = {}

	for _, answer in data.answers do
		local fieldId = answer.fieldId
		local v

		if answer.fieldType == "Radio" then
			v = { choiceOptionId = answer.optionIds[1] }
		else
			v = { multiChoiceOptionIds = answer.optionIds }
		end

		values[fieldId] = v
	end

	return groupsFetch(getGroupCustomFormUrl.responses(data.entityId, data.formId), "POST", {
		postBody = HttpService:JSONEncode({
			responseSpecs = { values = values },
			cfVertical = data.cfVertical
		})
	}):andThen(function(): nil
		return nil
	end, function(p)
		if type(p) == "table" and p.StatusCode == Http.StatusCodes.CONFLICT then
			return nil
		end

		return Promise.reject(p)
	end)
end
