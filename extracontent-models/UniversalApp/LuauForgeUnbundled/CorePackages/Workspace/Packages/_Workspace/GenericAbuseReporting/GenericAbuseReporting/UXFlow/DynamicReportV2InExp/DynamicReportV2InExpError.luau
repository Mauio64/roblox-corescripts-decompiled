local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Localization").Hooks.useLocalization

local empty = Foundation.Empty
local view = Foundation.View

local function DynamicReportV2InExpError()
	local v5 = useLocalization({
		errorText = "Feature.AbuseReportDialog.Label.GeneralError"
	})

	return React.createElement(view, {
		tag = "align-x-center align-y-center size-full"
	}, {
		Empty = React.createElement(empty, {
			icon = { name = "icons/status/oof_xlarge", size = "XLarge" },
			text = v5.errorText
		})
	})
end

return React.memo(DynamicReportV2InExpError)
