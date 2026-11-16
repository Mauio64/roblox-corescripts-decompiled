local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local React = require(parent.React)

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
local AbuseReportFormDataContext = require(GenericAbuseReporting.Bedui.Provider.AbuseReportFormDataContext)

local SharedFlags = require(parent.SharedFlags)
local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport

local function AbuseReportFormDataProvider(p)
	local state, setState = React.useState({})
	local state2, setState2 = React.useState({})

	local updateForm = React.useCallback(function(p2: string, p3: string)
		setState(function(p4)
			local clone = table.clone(p4)
			clone[p2] = p3
			return clone
		end)
	end, {})

	local updateAdditionalReportTags = React.useCallback(function(p2: string, p3)
		setState2(function(p4)
			local clone = table.clone(p4)
			clone[p2] = p3
			return clone
		end)
	end, {})

	local createElement = React.createElement
	local provider = AbuseReportFormDataContext.Provider
	local v = {
		formData = state,
		updateForm = updateForm,
		custom = p.custom,
		additionalReportTags = 0,
		updateAdditionalReportTags = 0
	}

	if not FFlagAddThumbnailSelectorReport then
		state2 = nil
	end

	v.additionalReportTags = state2

	if not FFlagAddThumbnailSelectorReport then
		updateAdditionalReportTags = nil
	end

	v.updateAdditionalReportTags = updateAdditionalReportTags
	return createElement(provider, { value = v }, p.children)
end

return AbuseReportFormDataProvider
