local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes")
local AbuseReportFormDataContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportFormDataContext")

local fFlagAddThumbnailSelectorReport = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagAddThumbnailSelectorReport

local function AbuseReportFormDataProvider(p2)
	local state, setState = React.useState({})
	local state2, setState2 = React.useState({})

	local v5 = React.useCallback(function(p3, p4)
		setState(function(p5)
			local clone = table.clone(p5)
			clone[p3] = p4
			return clone
		end)
	end, {})

	local v6 = React.useCallback(function(p3, p4)
		setState2(function(p5)
			local clone = table.clone(p5)
			clone[p3] = p4
			return clone
		end)
	end, {})

	local createElement = React.createElement
	local provider = AbuseReportFormDataContext.Provider
	local v8 = {
		formData = state,
		updateForm = v5,
		custom = p2.custom,
		additionalReportTags = 0,
		updateAdditionalReportTags = 0
	}

	if not fFlagAddThumbnailSelectorReport then
		state2 = nil
	end

	v8.additionalReportTags = state2

	if not fFlagAddThumbnailSelectorReport then
		v6 = nil
	end

	v8.updateAdditionalReportTags = v6
	return createElement(provider, { value = v8 }, p2.children)
end

return AbuseReportFormDataProvider
