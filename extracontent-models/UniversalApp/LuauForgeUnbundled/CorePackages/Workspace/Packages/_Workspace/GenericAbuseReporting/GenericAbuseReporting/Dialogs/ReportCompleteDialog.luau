local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/UIBlox")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Localization").Hooks.useLocalization
local useLocalizedStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/LocalizationKeys/useLocalizedStrings")
local MODAL_POSITION_OFFSET = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/MODAL_POSITION_OFFSET")

local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector

local function ReportCompleteDialog(props)
	local v5 = props.localizationKeys and useLocalization(props.localizationKeys) or useLocalizedStrings()
	local v6 = useLayerCollector()
	local absoluteSize = v6.absoluteSize

	return React.createElement(interactiveAlert, {
		screenSize = Vector2.new(absoluteSize.X, absoluteSize.Y - v6.insets.top),
		title = v5.completeTitle,
		bodyText = v5.completeDescription,
		anchorPoint = Vector2.new(0.5, 0),
		position = UDim2.new(0.5, 0, 0, v6.insets.top + MODAL_POSITION_OFFSET),
		buttonStackInfo = props.buttonStackInfo or {
			buttons = {
				{
					buttonType = buttonType.Secondary,
					props = { onActivated = props.onDismiss, text = v5.completeClose }
				}
			}
		},
		middleContent = props.middleContent
	})
end

return ReportCompleteDialog
