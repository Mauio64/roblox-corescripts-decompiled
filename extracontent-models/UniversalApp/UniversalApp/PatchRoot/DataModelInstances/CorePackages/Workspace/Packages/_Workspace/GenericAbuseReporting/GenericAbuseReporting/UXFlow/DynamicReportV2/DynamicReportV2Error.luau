local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local Empty = Foundation.Empty
local Sheet = Foundation.Sheet
local View = Foundation.View
local FFlagAbuseReportMenuV2 = require(Parent.SharedFlags).FFlagAbuseReportMenuV2

local function DynamicReportV2ErrorLegacy() -- line: 14
	-- upvalues: React (copy), Sheet (copy), Empty (copy)
	return React.createElement(React.Fragment, nil, {
		Content = React.createElement(Sheet.Content, {}, { React.createElement(Empty, {}) })
	})
end
local function DynamicReportV2ErrorV2() -- line: 22
	-- upvalues: useLocalization (copy), React (copy), Sheet (copy), View (copy), Empty (copy)
	local v11 = useLocalization({
		errorText = "Feature.AbuseReportDialog.Label.GeneralError"
	})

	return React.createElement(React.Fragment, nil, {
		Content = React.createElement(Sheet.Content, {}, {
			Center = React.createElement(View, {
				tag = "align-x-center align-y-center size-full"
			}, {
				Empty = React.createElement(Empty, {
					icon = {
						name = "icons/status/oof_xlarge",
						size = "XLarge"
					},
					text = v11.errorText
				})
			})
		})
	})
end

return React.memo(if not FFlagAbuseReportMenuV2 then DynamicReportV2ErrorLegacy else DynamicReportV2ErrorV2)
