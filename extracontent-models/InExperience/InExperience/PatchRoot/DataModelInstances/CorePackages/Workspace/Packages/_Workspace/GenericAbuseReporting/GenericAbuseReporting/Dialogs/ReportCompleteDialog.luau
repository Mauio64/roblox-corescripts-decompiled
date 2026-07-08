local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local UIBlox = require(GenericAbuseReportingParent.UIBlox)
local useLocalization = require(GenericAbuseReportingParent.Localization).Hooks.useLocalization
local useLocalizedStrings = require(GenericAbuseReporting.LocalizationKeys.useLocalizedStrings)
local MODAL_POSITION_OFFSET = require(GenericAbuseReporting.Common.MODAL_POSITION_OFFSET)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector

local function ReportCompleteDialog(t1: {[any]: any}) -- line: 39
	-- upvalues: useLocalization (copy), useLocalizedStrings (copy), useLayerCollector (copy), React (copy), InteractiveAlert (copy), MODAL_POSITION_OFFSET (copy), ButtonType (copy)
	local v13 = t1.localizationKeys and useLocalization(t1.localizationKeys) or useLocalizedStrings()
	local v14 = useLayerCollector()
	local absoluteSize = v14.absoluteSize

	return React.createElement(InteractiveAlert, {
		screenSize = Vector2.new(absoluteSize.X, absoluteSize.Y - v14.insets.top),
		title = v13.completeTitle,
		bodyText = v13.completeDescription,
		anchorPoint = Vector2.new(0.5, 0),
		position = UDim2.new(0.5, 0, 0, v14.insets.top + MODAL_POSITION_OFFSET),
		buttonStackInfo = t1.buttonStackInfo or {
			buttons = {{
				buttonType = ButtonType.Secondary,
				props = {
					onActivated = t1.onDismiss,
					text = v13.completeClose
				}
			}}
		},
		middleContent = t1.middleContent
	})
end

return ReportCompleteDialog
