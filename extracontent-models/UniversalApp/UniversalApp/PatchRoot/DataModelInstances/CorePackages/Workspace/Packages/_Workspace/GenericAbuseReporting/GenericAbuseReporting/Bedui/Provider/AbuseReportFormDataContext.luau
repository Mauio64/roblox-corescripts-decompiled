local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)

local FFlagAddThumbnailSelectorReport = require(GenericAbuseReportingParent.SharedFlags).FFlagAddThumbnailSelectorReport

return React.createContext({
	custom = if not FFlagAddThumbnailSelectorReport then nil else {},
	formData = {},
	updateForm = function(_: string, _: string) -- line: 16
	end,
	additionalReportTags = if not FFlagAddThumbnailSelectorReport then nil else {},
	updateAdditionalReportTags = if not FFlagAddThumbnailSelectorReport then nil else function(_: string, _) -- line: 19
	end
})
