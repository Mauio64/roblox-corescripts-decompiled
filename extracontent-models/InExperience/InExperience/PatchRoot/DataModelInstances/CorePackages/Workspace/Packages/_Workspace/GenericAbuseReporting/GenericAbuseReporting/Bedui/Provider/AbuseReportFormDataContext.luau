local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local React = require(parent.React)

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport

return React.createContext({
	custom = FFlagAddThumbnailSelectorReport and {} or nil,
	formData = {},
	updateForm = function(_: string, _: string) end,
	additionalReportTags = FFlagAddThumbnailSelectorReport and {} or nil,
	updateAdditionalReportTags = FFlagAddThumbnailSelectorReport and function(_: string, _) end or nil
})
