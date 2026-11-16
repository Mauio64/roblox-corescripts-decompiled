local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local escapeRichText = require(ChatUIPrimitives.Utils.escapeRichText)
local formatInlineIcon = require(ChatUIPrimitives.Utils.formatInlineIcon)
local BubbleView = require(script.Parent.Parent.Bubble.BubbleView)
local Sizing = require(script.Parent.Parent.Parent.Sizing)

local function BubbleReplyQuote(props)
	local v = Sizing.useSizing()
	local v2 = Foundation.Hooks.useTokens()
	local isObservingUser = props.isObservingUser
	local reply = v.reply
	local cornerRadius = v.bubble.cornerRadius
	local contentMaxWidth = v.bubble.contentMaxWidth
	local useDefaultTags = Foundation.Hooks.useDefaultTags
	local v3

	if isObservingUser then
		v3 = reply.rightLabelTag
	else
		v3 = reply.leftLabelTag
	end

	local tag = useDefaultTags(v3, "auto-xy content-muted")

	local cornerRadii = React.useMemo(function()
		return {
			topLeft = cornerRadius,
			topRight = cornerRadius,
			bottomLeft = cornerRadius,
			bottomRight = cornerRadius
		}
	end, { cornerRadius })
	local sizeConstraint = React.useMemo(function()
		return {
			MinSize = Vector2.new(0, 0),
			MaxSize = Vector2.new(contentMaxWidth, 1e999)
		}
	end, { contentMaxWidth })
	local sizeConstraint2 = React.useMemo(function()
		return {
			MinSize = Vector2.new(0, 0),
			MaxSize = Vector2.new(reply.textMaxWidth, reply.textMaxHeight)
		}
	end, { reply.textMaxWidth, reply.textMaxHeight })

	local createElement = React.createElement
	local view = Foundation.View
	local v4 = {
		tag = {
			["col gap-xxsmall auto-xy padding-bottom-xxsmall"] = true,
			["align-x-right"] = isObservingUser,
			["align-x-left"] = not isObservingUser
		},
		LayoutOrder = props.LayoutOrder
	}
	local label

	if props.label ~= nil then
		label = React.createElement(Foundation.Text, {
			tag = tag,
			Text = props.label,
			TextTruncate = Enum.TextTruncate.AtEnd,
			sizeConstraint = sizeConstraint,
			LayoutOrder = 1,
			testId = "message-reply-label"
		})
	end

	return createElement(view, v4, {
		Label = label,
		Quote = React.createElement(
			Foundation.View,
			{ tag = "row gap-small auto-xy", LayoutOrder = 2, testId = "message-reply-quote" },
			{
				Marker = React.createElement(Foundation.View, {
					tag = "self-stretch radius-circle bg-shift-400",
					Size = UDim2.fromOffset(reply.markerWidth, 0),
					LayoutOrder = isObservingUser and 2 or 1,
					testId = "message-reply-marker"
				}),
				Bubble = React.createElement(BubbleView, {
					backgroundStyle = v2.Color.Shift.Shift_200,
					cornerRadii = cornerRadii,
					LayoutOrder = isObservingUser and 1 or 2
				}, {
					Text = React.createElement(Foundation.Text, {
						tag = "auto-xy text-wrap text-align-x-left text-align-y-top content-muted",
						fontStyle = reply.fontStyle,
						Text = props.text,
						TextTruncate = Enum.TextTruncate.AtEnd,
						sizeConstraint = sizeConstraint2,
						testId = "message-reply"
					})
				})
			}
		)
	})
end

local function InlineReplyQuote(p)
	local text = React.useMemo(function()
		local v = string.gsub(p.text, "%s+", " ")
		return `{formatInlineIcon(Foundation.Enums.IconName.ArrowCurlToLeft, { weight = "600" })} {escapeRichText(v)}`
	end, { p.text })

	return React.createElement(Foundation.Text, {
		tag = "size-full-0 auto-y text-caption-small text-align-x-left content-muted",
		Text = text,
		RichText = true,
		TextTruncate = Enum.TextTruncate.AtEnd,
		LayoutOrder = p.LayoutOrder,
		testId = "message-reply"
	})
end

return { Bubble = BubbleReplyQuote, Inline = InlineReplyQuote }
