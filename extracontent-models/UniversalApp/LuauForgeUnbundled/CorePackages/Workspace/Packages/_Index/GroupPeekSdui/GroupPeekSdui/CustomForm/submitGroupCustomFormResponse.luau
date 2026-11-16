local HttpService = game:GetService("HttpService")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/Http")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/CustomForms")

local getGroupCustomFormUrl = require("@game/CorePackages/Workspace/Packages/_Index/GroupPeekSdui/GroupPeekSdui/CustomForm/getGroupCustomFormUrl")
local groupsFetch = require("@game/CorePackages/Workspace/Packages/_Index/GroupPeekSdui/GroupPeekSdui/CustomForm/groupsFetch")

return function(data)
	local v5 = {}

	for k, answer in data.answers do
		local fieldId = answer.fieldId
		local v6 = if answer.fieldType == "Radio" then {
			choiceOptionId = answer.optionIds[1]
		} else { multiChoiceOptionIds = answer.optionIds }
		v5[fieldId] = v6
	end

	return groupsFetch(getGroupCustomFormUrl.responses(data.entityId, data.formId), "POST", {
		postBody = HttpService:JSONEncode({
			responseSpecs = { values = v5 },
			cfVertical = data.cfVertical
		})
	}):andThen(function(): nil
		return nil
	end, function(p2)
		if type(p2) == "table" and p2.StatusCode == Http.StatusCodes.CONFLICT then
			return nil
		end

		return Promise.reject(p2)
	end)
end
