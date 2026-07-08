local TextService = game:GetService("TextService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local ChatBubbleContainerAutomaticSize = require(script.Parent.Bubble.ChatBubbleContainerAutomaticSize)
local React = require(AppChatParent.React)
local useStyle = require(AppChatParent.UIBlox).Core.Style.useStyle
local Cryo = require(AppChatParent.Cryo)
local useTokens = require(AppChatParent.Foundation).Hooks.useTokens
local FFlagAppChatEnableAutotranslation = require(AppChat.Flags.FFlagAppChatEnableAutotranslation)
local Foundation = require(AppChatParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local Divider = Foundation.Divider
local DividerVariant = Foundation.Enums.DividerVariant
local t1 = {
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
	[React.Change.AbsoluteSize] = function() -- line: 51
	end
}

function PlainText(t2: {[any]: any}) -- line: 58
	-- upvalues: Cryo (copy), t1 (copy), useTokens (copy), useStyle (copy), TextService (copy), FFlagAppChatEnableAutotranslation (copy), React (copy), ChatBubbleContainerAutomaticSize (copy), View (copy), FoundationText (copy), Divider (copy), DividerVariant (copy)
	local v17 = Cryo.Dictionary.join(t1, t2)
	local v18 = useTokens()
	local v19 = useStyle()
	local maxWidth = v17.maxWidth
	local innerPadding = v17.innerPadding
	local v22 = math.max(0, maxWidth - innerPadding)
	local Body = v19.Font.Body
	local v24 = v17.textSize or v19.Font.BaseSize * Body.RelativeSize
	local text = v17.text
	local v26 = v17.font or Body.Font
	local isRepliedTo = v17.isRepliedTo
	local vector2 = Vector2.new(v22, not isRepliedTo and 1e999 or v24 * 3)
	local TextSize = TextService:GetTextSize(text, v24, v26, vector2)
	local isRepliedTo2 = v17.isRepliedTo
	local v31 = v17.isUnfiltered and not v17.isIncoming
	local v32 = if not isRepliedTo2 then if not v31 then if not v17.isIncoming then v18.Color.ActionEmphasis.Foreground.Color3 else v18.Color.Content.Emphasis.Color3 else Color3.new(1, 1, 1) else v19.Theme.TextDefault.Color
	local v33 = if not FFlagAppChatEnableAutotranslation then nil else React.useMemo(function() -- line: 92
		-- upvalues: isRepliedTo (copy), v24 (copy)
		return {
			MinSize = Vector2.new(0, 0),
			MaxSize = Vector2.new(1e999, not isRepliedTo and 1e999 or v24 * 3)
		}
	end, {
		isRepliedTo,
		v17.textSize
	})
	local v34 = if not FFlagAppChatEnableAutotranslation then nil else React.useMemo(function() -- line: 100
		-- upvalues: v22 (copy), maxWidth (copy)
		return {
			MinSize = Vector2.new(0, 0),
			MaxSize = Vector2.new(v22 or maxWidth, 1e999)
		}
	end, {
		v22,
		maxWidth
	})

	if FFlagAppChatEnableAutotranslation and v17.translatedText then
		local t3 = {
			TextColor3 = v32,
			Font = v26,
			TextSize = v24,
			TextTransparency = v17.isPending and v19.Theme.TextMuted.Transparency or 0,
			sizeConstraint = v33
		}

		return React.createElement(ChatBubbleContainerAutomaticSize, {
			isIncoming = v17.isIncoming,
			hasTail = v17.hasTail,
			isPending = v17.isPending,
			isUnfiltered = v17.isUnfiltered,
			padding = {
				top = UDim.new(0, innerPadding),
				bottom = UDim.new(0, innerPadding),
				left = UDim.new(0, innerPadding + 2),
				right = UDim.new(0, innerPadding + 2)
			},
			LayoutOrder = v17.LayoutOrder,
			isRepliedTo = v17.isRepliedTo,
			isPressed = v17.isPressed,
			[React.Change.AbsoluteSize] = v17[React.Change.AbsoluteSize],
			isLastMessageInMessageGroup = v17.isLastMessageInMessageGroup
		}, {
			Wrapper = React.createElement(View, {
				tag = "auto-xy col gap-xsmall",
				sizeConstraint = v34
			}, {
				textContent = React.createElement(FoundationText, Cryo.Dictionary.union(t3, {
					LayoutOrder = 1,
					Text = text,
					tag = {
						["text-align-x-left text-align-y-top auto-xy text-wrap content-muted text-body-small"] = true,
						["text-truncate-end"] = isRepliedTo,
						["text-truncate-none"] = not isRepliedTo
					}
				})),
				Divider = React.createElement(View, {
					tag = "size-0 self-stretch auto-y",
					LayoutOrder = 2
				}, React.createElement(Divider, {
					variant = DividerVariant.Default
				})),
				translatedTextContent = React.createElement(FoundationText, Cryo.Dictionary.union(t3, {
					LayoutOrder = 3,
					Text = v17.translatedText,
					tag = {
						["text-align-x-left text-align-y-top auto-xy text-wrap"] = true,
						["text-truncate-none"] = not isRepliedTo,
						["text-truncate-end"] = isRepliedTo
					}
				}))
			})
		})
	end

	return React.createElement(ChatBubbleContainerAutomaticSize, {
		isIncoming = v17.isIncoming,
		hasTail = v17.hasTail,
		isPending = v17.isPending,
		isUnfiltered = v17.isUnfiltered,
		padding = {
			top = UDim.new(0, innerPadding),
			bottom = UDim.new(0, innerPadding),
			left = UDim.new(0, innerPadding + 2),
			right = UDim.new(0, innerPadding + 2)
		},
		LayoutOrder = v17.LayoutOrder,
		isRepliedTo = v17.isRepliedTo,
		isPressed = v17.isPressed,
		[React.Change.AbsoluteSize] = v17[React.Change.AbsoluteSize],
		isLastMessageInMessageGroup = v17.isLastMessageInMessageGroup
	}, {
		textContent = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			Text = text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = v32,
			AutomaticSize = Enum.AutomaticSize.XY,
			Font = v26,
			TextSize = v24,
			Size = UDim2.fromOffset(math.ceil(TextSize.X), (math.ceil(TextSize.Y))),
			TextTransparency = v17.isPending and v19.Theme.TextMuted.Transparency or 0,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextTruncate = if not isRepliedTo then nil else Enum.TextTruncate.AtEnd
		}, {
			SizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(v22 or maxWidth, not isRepliedTo and 1e999 or v24 * 3)
			})
		})
	})
end

return PlainText
