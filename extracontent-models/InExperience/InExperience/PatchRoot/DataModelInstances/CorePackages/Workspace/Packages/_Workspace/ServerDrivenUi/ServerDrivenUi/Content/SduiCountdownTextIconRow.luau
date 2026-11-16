local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local SduiTextIconRow = require(ServerDrivenUi.Content.SduiTextIconRow)
local GameCollections = require(parent.GameCollections)
local useCountdownSubtitleTextBinding = GameCollections.useCountdownSubtitleTextBinding

local function SduiCountdownTextIconRow(props)
	local v = useTokens()

	local fontStyle = props.fontStyle or v.Typography.BodyMedium
	local textColor = props.textColor or v.Color.Content.Default.Color3
	local gap = props.gap or v.Gap.XXSmall
	local iconWidth = props.iconWidth or v.Size.Size_400
	local selectable = props.onActivated ~= nil

	local text = useCountdownSubtitleTextBinding(
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
		selectable = selectable,
		testId = "--sdui-countdown-text-icon-row"
	}, props, { text = text }))
end

return React.memo(SduiCountdownTextIconRow)
