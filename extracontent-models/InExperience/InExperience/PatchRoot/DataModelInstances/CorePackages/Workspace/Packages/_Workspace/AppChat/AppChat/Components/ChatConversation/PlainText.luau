local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local ChatBubbleContainer = require(script.Parent.Bubble.ChatBubbleContainer)
local React = require(parent.React)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Cryo = require(parent.Cryo)

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local FFlagAppChatEnableAutotranslation = require(AppChat.Flags.FFlagAppChatEnableAutotranslation)
local FFlagAppChatBlueSentBubbles = require(AppChat.Flags.FFlagAppChatBlueSentBubbles)

local Foundation2 = require(parent.Foundation)
local normalizeFontFace = Foundation2.Utility.normalizeFontFace
local View = Foundation2.View
local Text = Foundation2.Text
local Divider = Foundation2.Divider
local DividerVariant = Foundation2.Enums.DividerVariant

local v = {
	text = "",
	maxWidth = 0,
	innerPadding = 0,
	isIncoming = false,
	hasTail = false,
	LayoutOrder = 0,
	isPending = false,
	isUnfiltered = false,
	isRepliedTo = false,
	isPressed = false,
	isLastMessageInMessageGroup = false,
	[React.Change.AbsoluteSize] = function() end
}

function PlainText(p)
	local joined = Cryo.Dictionary.join(v, p)

	local v2 = useTokens()
	local v3 = useStyle()
	local maxWidth = joined.maxWidth
	local innerPadding = joined.innerPadding
	local v4 = math.max(0, maxWidth - innerPadding)
	local body = v3.Font.Body
	local textSize = joined.textSize or v3.Font.BaseSize * body.RelativeSize
	local text = joined.text
	local font = joined.font or body.Font
	local isRepliedTo = joined.isRepliedTo
	local textSize2 = GetTextSize(text, textSize, font, Vector2.new(v4, not isRepliedTo and 1e999 or textSize * 3), {
		addTemporaryPadding = false
	})

	local isRepliedTo2 = joined.isRepliedTo

	local v5 = (joined.isUnfiltered or FFlagAppChatBlueSentBubbles) and not joined.isIncoming
	local textColor

	if isRepliedTo2 then
		textColor = v3.Theme.TextDefault.Color
	elseif v5 then
		textColor = Color3.new(1, 1, 1)
	elseif joined.isIncoming then
		textColor = v2.Color.Content.Emphasis.Color3
	else
		textColor = v2.Color.ActionEmphasis.Foreground.Color3
	end

	local sizeConstraint

	if FFlagAppChatEnableAutotranslation then
		sizeConstraint = React.useMemo(function()
			return {
				MinSize = Vector2.new(0, 0),
				MaxSize = Vector2.new(1e999, not isRepliedTo and 1e999 or textSize * 3)
			}
		end, { isRepliedTo, joined.textSize })
	end

	local sizeConstraint2

	if FFlagAppChatEnableAutotranslation then
		sizeConstraint2 = React.useMemo(function()
			return {
				MinSize = Vector2.new(0, 0),
				MaxSize = Vector2.new(v4 or maxWidth, 1e999)
			}
		end, { v4, maxWidth })
	end

	if FFlagAppChatEnableAutotranslation and joined.translatedText then
		local v6 = {
			TextColor3 = textColor,
			FontFace = normalizeFontFace(font),
			TextSize = textSize,
			TextTransparency = joined.isPending and v3.Theme.TextMuted.Transparency or 0,
			sizeConstraint = sizeConstraint
		}

		return React.createElement(ChatBubbleContainer, {
			isIncoming = joined.isIncoming,
			hasTail = joined.hasTail,
			isPending = joined.isPending,
			isUnfiltered = joined.isUnfiltered,
			padding = {
				top = UDim.new(0, innerPadding),
				bottom = UDim.new(0, innerPadding),
				left = UDim.new(0, innerPadding + 2),
				right = UDim.new(0, innerPadding + 2)
			},
			LayoutOrder = joined.LayoutOrder,
			isRepliedTo = joined.isRepliedTo,
			isPressed = joined.isPressed,
			[React.Change.AbsoluteSize] = joined[React.Change.AbsoluteSize],
			isLastMessageInMessageGroup = joined.isLastMessageInMessageGroup,
			bubbleRef = joined.bubbleRef
		}, {
			Wrapper = React.createElement(View, {
				tag = "auto-xy col gap-xsmall",
				sizeConstraint = sizeConstraint2
			}, {
				textContent = React.createElement(Text, Cryo.Dictionary.union(v6, {
					Text = text,
					LayoutOrder = 1,
					tag = {
						["text-align-x-left text-align-y-top auto-xy text-wrap content-muted text-body-small"] = true,
						["text-truncate-end"] = isRepliedTo,
						["text-truncate-none"] = not isRepliedTo
					}
				})),
				Divider = React.createElement(
					View,
					{ tag = "size-0 self-stretch auto-y", LayoutOrder = 2 },
					React.createElement(Divider, { variant = DividerVariant.Default })
				),
				translatedTextContent = React.createElement(Text, Cryo.Dictionary.union(v6, {
					Text = joined.translatedText,
					LayoutOrder = 3,
					tag = {
						["text-align-x-left text-align-y-top auto-xy text-wrap"] = true,
						["text-truncate-none"] = not isRepliedTo,
						["text-truncate-end"] = isRepliedTo
					}
				}))
			})
		})
	else
		local createElement = React.createElement
		local v6 = {
			isIncoming = joined.isIncoming,
			hasTail = joined.hasTail,
			isPending = joined.isPending,
			isUnfiltered = joined.isUnfiltered,
			padding = {
				top = UDim.new(0, innerPadding),
				bottom = UDim.new(0, innerPadding),
				left = UDim.new(0, innerPadding + 2),
				right = UDim.new(0, innerPadding + 2)
			},
			LayoutOrder = joined.LayoutOrder,
			isRepliedTo = joined.isRepliedTo,
			isPressed = joined.isPressed,
			[React.Change.AbsoluteSize] = joined[React.Change.AbsoluteSize],
			isLastMessageInMessageGroup = joined.isLastMessageInMessageGroup,
			bubbleRef = joined.bubbleRef
		}

		local createElement2 = React.createElement
		local v7 = {
			Text = text,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			TextColor3 = textColor,
			AutomaticSize = Enum.AutomaticSize.XY,
			FontFace = normalizeFontFace(font),
			TextSize = textSize,
			Size = UDim2.fromOffset(math.ceil(textSize2.X), (math.ceil(textSize2.Y))),
			TextTransparency = joined.isPending and v3.Theme.TextMuted.Transparency or 0,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextTruncate = 0,
			TextWrapped = true
		}
		local textTruncate

		if isRepliedTo then
			textTruncate = Enum.TextTruncate.AtEnd
		end

		v7.TextTruncate = textTruncate
		return createElement(ChatBubbleContainer, v6, {
			textContent = createElement2("TextLabel", v7, {
				SizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(v4 or maxWidth, not isRepliedTo and 1e999 or textSize * 3)
				})
			})
		})
	end
end

return PlainText
