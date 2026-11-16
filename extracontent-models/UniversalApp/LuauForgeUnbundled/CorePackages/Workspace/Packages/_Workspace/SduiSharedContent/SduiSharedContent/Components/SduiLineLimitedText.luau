local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SignalsReact")
local TextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/TextSize")
local getPreferredTextSizeLineBudget = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedUtilities").getPreferredTextSizeLineBudget

local SduiText = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiText")

local useTokens = Foundation.Hooks.useTokens

local function SduiLineLimitedText(props)
	local v5 = useTokens()
	local v6 = SignalsReact.useSignalState(function(p2)
		return TextSize.getTextSizeStore(p2).getTextSizeOffset(p2)
	end)

	local v7 = math.max(props.maxLines or 1, 1)
	local fontStyle = props.fontStyle or v5.Typography.BodyMedium

	local v8 = v7 * fontStyle.FontSize * fontStyle.LineHeight + getPreferredTextSizeLineBudget(v6, v7)
	local v9 = if props.size then props.size.X else UDim.new(1, 0)

	local createElement = React.createElement

	local join = Cryo.Dictionary.join
	local v11 = {
		automaticSize = Cryo.None,
		maxLines = Cryo.None,
		size = UDim2.new(v9, UDim.new(0, (math.ceil(v8)))),
		textWrapped = 0,
		textTruncate = 0
	}
	local v12 = if props.textWrapped == nil then v7 > 1 else props.textWrapped
	v11.textWrapped = v12
	local v13 = if props.textTruncate == nil then Enum.TextTruncate.SplitWord else props.textTruncate
	v11.textTruncate = v13
	return createElement(SduiText, join(props, v11))
end

return SduiLineLimitedText
