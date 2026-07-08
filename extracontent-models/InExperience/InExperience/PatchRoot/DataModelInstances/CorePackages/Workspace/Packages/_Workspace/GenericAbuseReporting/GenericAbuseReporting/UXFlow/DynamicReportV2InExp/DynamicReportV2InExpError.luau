local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local Empty = Foundation.Empty
local View = Foundation.View

local function DynamicReportV2InExpError() -- line: 14
	-- upvalues: useLocalization (copy), React (copy), View (copy), Empty (copy)
	local v8 = useLocalization({
		errorText = "Feature.AbuseReportDialog.Label.GeneralError"
	})

	return React.createElement(View, {
		tag = "align-x-center align-y-center size-full"
	}, {
		Empty = React.createElement(Empty, {
			icon = {
				name = "icons/status/oof_xlarge",
				size = "XLarge"
			},
			text = v8.errorText
		})
	})
end

return React.memo(DynamicReportV2InExpError)
