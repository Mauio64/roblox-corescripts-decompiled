local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useLocalizedStrings = require(GenericAbuseReporting.LocalizationKeys.useLocalizedStrings)
local MODAL_POSITION_OFFSET = require(GenericAbuseReporting.Common.MODAL_POSITION_OFFSET)

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector

local function ReportCompleteDialog(props)
	local v = props.localizationKeys and useLocalization(props.localizationKeys) or useLocalizedStrings()
	local v2 = useLayerCollector()
	local absoluteSize = v2.absoluteSize

	return React.createElement(InteractiveAlert, {
		screenSize = Vector2.new(absoluteSize.X, absoluteSize.Y - v2.insets.top),
		title = v.completeTitle,
		bodyText = v.completeDescription,
		anchorPoint = Vector2.new(0.5, 0),
		position = UDim2.new(0.5, 0, 0, v2.insets.top + MODAL_POSITION_OFFSET),
		buttonStackInfo = props.buttonStackInfo or {
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = { onActivated = props.onDismiss, text = v.completeClose }
				}
			}
		},
		middleContent = props.middleContent
	})
end

return ReportCompleteDialog
