local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation").Hooks.useTokens

local SduiTextIconRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiTextIconRow")
local useCountdownSubtitleTextBinding = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameCollections").useCountdownSubtitleTextBinding

local function SduiCountdownTextIconRow(props)
	local v5 = useTokens()

	local fontStyle = props.fontStyle or v5.Typography.BodyMedium
	local textColor = props.textColor or v5.Color.Content.Default.Color3
	local gap = props.gap or v5.Gap.XXSmall
	local iconWidth = props.iconWidth or v5.Size.Size_400
	local v6 = props.onActivated ~= nil

	local v7 = useCountdownSubtitleTextBinding(
		props.endTimestamp,
		props.formatStringHoursMinutes,
		props.defaultString
	)

	return React.createElement(SduiTextIconRow, Cryo.Dictionary.join({
		gap = gap,
		fontStyle = fontStyle,
		textColor = textColor,
		textFlexMode = Enum.UIFlexMode.Shrink,
		icon = props.icon,
		iconWidth = iconWidth,
		iconColor = textColor,
		selectable = v6,
		testId = "--sdui-countdown-text-icon-row"
	}, props, { text = v7 }))
end

return React.memo(SduiCountdownTextIconRow)
