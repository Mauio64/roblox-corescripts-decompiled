local parent = script:FindFirstAncestor("GroupPeekSdui").Parent

require(parent.CustomForms)

local getGroupCustomFormUrl = require(script.Parent.getGroupCustomFormUrl)
local groupsFetch = require(script.Parent.groupsFetch)
local toCustomFormData = require(script.Parent.toCustomFormData)

return function(data)
	return groupsFetch(getGroupCustomFormUrl.results(data.entityId, data.formId, data.cfVertical), "GET"):andThen(function(p)
		return toCustomFormData(data.formId, p.responseBody, data.current)
	end)
end
