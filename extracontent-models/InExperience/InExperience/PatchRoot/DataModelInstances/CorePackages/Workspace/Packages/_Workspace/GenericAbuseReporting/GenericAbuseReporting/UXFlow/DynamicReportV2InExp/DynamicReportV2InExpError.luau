local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Empty = Foundation.Empty
local View = Foundation.View

local function DynamicReportV2InExpError()
	local v = useLocalization({ errorText = "Feature.AbuseReportDialog.Label.GeneralError" })

	return React.createElement(View, { tag = "align-x-center align-y-center size-full" }, {
		Empty = React.createElement(Empty, {
			icon = { name = "icons/status/oof_xlarge", size = "XLarge" },
			text = v.errorText
		})
	})
end

return React.memo(DynamicReportV2InExpError)
