local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes")

local fFlagAddThumbnailSelectorReport = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagAddThumbnailSelectorReport

return React.createContext({
	custom = fFlagAddThumbnailSelectorReport and {} or nil,
	formData = {},
	updateForm = function(p2, p3) end,
	additionalReportTags = fFlagAddThumbnailSelectorReport and {} or nil,
	updateAdditionalReportTags = fFlagAddThumbnailSelectorReport and function(p2, p3) end or nil
})
