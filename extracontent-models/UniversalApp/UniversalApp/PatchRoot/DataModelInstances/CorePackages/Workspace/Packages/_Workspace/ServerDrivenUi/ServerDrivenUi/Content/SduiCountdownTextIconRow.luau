local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local Cryo = require(ServerDrivenUiParent.Cryo)
local useTokens = require(ServerDrivenUiParent.Foundation).Hooks.useTokens
local SduiTextIconRow = require(ServerDrivenUi.Content.SduiTextIconRow)
local useCountdownSubtitleTextBinding = require(ServerDrivenUiParent.GameCollections).useCountdownSubtitleTextBinding

local function SduiCountdownTextIconRow(p1) -- line: 21
	-- upvalues: useTokens (copy), useCountdownSubtitleTextBinding (copy), React (copy), SduiTextIconRow (copy), Cryo (copy)
	local v10 = useTokens()
	local v11 = p1.fontStyle or v10.Typography.BodyMedium
	local v12 = p1.textColor or v10.Color.Content.Default.Color3
	local v13 = p1.gap or v10.Gap.XXSmall
	local v14 = p1.iconWidth or v10.Size.Size_400
	local v15 = p1.onActivated ~= nil
	local v16 = useCountdownSubtitleTextBinding(p1.endTimestamp, p1.formatStringHoursMinutes, p1.defaultString)

	return React.createElement(SduiTextIconRow, Cryo.Dictionary.join({
		testId = "--sdui-countdown-text-icon-row",
		gap = v13,
		fontStyle = v11,
		textColor = v12,
		textFlexMode = Enum.UIFlexMode.Shrink,
		icon = p1.icon,
		iconWidth = v14,
		iconColor = v12,
		selectable = v15
	}, p1, {
		text = v16
	}))
end

return React.memo(SduiCountdownTextIconRow)
