local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local SignalsReact = require(parent.SignalsReact)
local TextSize = require(parent.TextSize)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getPreferredTextSizeLineBudget = SduiSharedUtilities.getPreferredTextSizeLineBudget

local SduiText = require(script.Parent.SduiText)

local useTokens = Foundation.Hooks.useTokens

local function SduiLineLimitedText(props)
	local v = useTokens()
	local v2 = SignalsReact.useSignalState(function(p)
		return TextSize.getTextSizeStore(p).getTextSizeOffset(p)
	end)

	local v3 = math.max(props.maxLines or 1, 1)
	local fontStyle = props.fontStyle or v.Typography.BodyMedium

	local v4 = v3 * fontStyle.FontSize * fontStyle.LineHeight + getPreferredTextSizeLineBudget(v2, v3)
	local v5

	if props.size then
		v5 = props.size.X
	else
		v5 = UDim.new(1, 0)
	end

	local createElement = React.createElement

	local join = Cryo.Dictionary.join
	local v6 = {
		automaticSize = Cryo.None,
		maxLines = Cryo.None,
		size = UDim2.new(v5, UDim.new(0, (math.ceil(v4)))),
		textWrapped = 0,
		textTruncate = 0
	}
	local textWrapped

	if props.textWrapped == nil then
		textWrapped = v3 > 1
	else
		textWrapped = props.textWrapped
	end

	v6.textWrapped = textWrapped
	local textTruncate

	if props.textTruncate == nil then
		textTruncate = Enum.TextTruncate.SplitWord
	else
		textTruncate = props.textTruncate
	end

	v6.textTruncate = textTruncate
	return createElement(SduiText, join(props, v6))
end

return SduiLineLimitedText
