local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)

local AbuseReportFormDataContext = require(GenericAbuseReporting.Bedui.Provider.AbuseReportFormDataContext)
local FFlagAddThumbnailSelectorReport = require(GenericAbuseReportingParent.SharedFlags).FFlagAddThumbnailSelectorReport

local function AbuseReportFormDataProvider(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), AbuseReportFormDataContext (copy), FFlagAddThumbnailSelectorReport (copy)
	local v8, v9 = React.useState({})
	local v10, v11 = React.useState({})
	local v12 = React.useCallback(function(s1: string, s2: string) -- line: 23
		-- upvalues: v9 (copy)
		v9(function(p1) -- line: 24
			-- upvalues: s1 (copy), s2 (copy)
			local v19 = table.clone(p1)

			v19[s1] = s2

			return v19
		end)
	end, {})
	local v13 = React.useCallback(function(s3: string, p2) -- line: 31
		-- upvalues: v11 (copy)
		v11(function(p3) -- line: 32
			-- upvalues: s3 (copy), p2 (copy)
			local v21 = table.clone(p3)

			v21[s3] = p2

			return v21
		end)
	end, {})

	return React.createElement(AbuseReportFormDataContext.Provider, {
		value = {
			formData = v8,
			updateForm = v12,
			custom = t1.custom,
			additionalReportTags = if not FFlagAddThumbnailSelectorReport then nil else v10,
			updateAdditionalReportTags = if not FFlagAddThumbnailSelectorReport then nil else v13
		}
	}, t1.children)
end

return AbuseReportFormDataProvider
