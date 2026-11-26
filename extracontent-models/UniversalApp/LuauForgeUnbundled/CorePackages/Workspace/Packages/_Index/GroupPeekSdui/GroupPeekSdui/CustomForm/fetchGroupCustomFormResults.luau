require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/CustomForms")

local getGroupCustomFormUrl = require("@game/CorePackages/Workspace/Packages/_Index/GroupPeekSdui/GroupPeekSdui/CustomForm/getGroupCustomFormUrl")
local groupsFetch = require("@game/CorePackages/Workspace/Packages/_Index/GroupPeekSdui/GroupPeekSdui/CustomForm/groupsFetch")
local toCustomFormData = require("@game/CorePackages/Workspace/Packages/_Index/GroupPeekSdui/GroupPeekSdui/CustomForm/toCustomFormData")

return function(data)
	return groupsFetch(getGroupCustomFormUrl.results(data.entityId, data.formId, data.cfVertical), "GET"):andThen(function(p2)
		return toCustomFormData(data.formId, p2.responseBody, data.current)
	end)
end
