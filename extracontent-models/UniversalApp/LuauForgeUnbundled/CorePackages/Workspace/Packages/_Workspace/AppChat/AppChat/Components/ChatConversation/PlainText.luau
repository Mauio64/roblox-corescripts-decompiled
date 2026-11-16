local TextService = game:GetService("TextService")

local ChatBubbleContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Bubble/ChatBubbleContainer")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Style").GetTextSize
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.Style.useStyle
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation").Hooks.useTokens

local FFlagAppChatEnableAutotranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatEnableAutotranslation")
local FFlagAppChatBlueSentBubbles = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatBlueSentBubbles")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local view = Foundation.View
local text = Foundation.Text
local divider = Foundation.Divider
local dividerVariant = Foundation.Enums.DividerVariant
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local v5 = {
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

function LUAUFORGE_MODULE_GLOBALS_hlk_PlainText(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local v6 = useTokens()
	local v7 = useStyle()
	local maxWidth = joined.maxWidth
	local innerPadding = joined.innerPadding
	local v8 = math.max(0, maxWidth - innerPadding)
	local body = v7.Font.Body
	local textSize = joined.textSize or v7.Font.BaseSize * body.RelativeSize
	local text2 = joined.text
	local font = joined.font or body.Font
	local isRepliedTo = joined.isRepliedTo
	local vector2 = Vector2.new(v8, not isRepliedTo and 1e999 or textSize * 3)
	local v9

	if foundationFontFaceMigration then
		v9 = getTextSize(text2, textSize, font, vector2, { addTemporaryPadding = false })
	else
		v9 = TextService:GetTextSize(text2, textSize, font, vector2)
	end

	local isRepliedTo2 = joined.isRepliedTo

	local v10 = (joined.isUnfiltered or FFlagAppChatBlueSentBubbles) and not joined.isIncoming
	local v11

	if isRepliedTo2 then
		v11 = v7.Theme.TextDefault.Color
	elseif v10 then
		v11 = Color3.new(1, 1, 1)
	elseif joined.isIncoming then
		v11 = v6.Color.Content.Emphasis.Color3
	else
		v11 = v6.Color.ActionEmphasis.Foreground.Color3
	end

	local v12

	if FFlagAppChatEnableAutotranslation then
		v12 = React.useMemo(function()
			return {
				MinSize = Vector2.new(0, 0),
				MaxSize = Vector2.new(1e999, not isRepliedTo and 1e999 or textSize * 3)
			}
		end, { isRepliedTo, joined.textSize })
	end

	local v13

	if FFlagAppChatEnableAutotranslation then
		v13 = React.useMemo(function()
			return {
				MinSize = Vector2.new(0, 0),
				MaxSize = Vector2.new(v8 or maxWidth, 1e999)
			}
		end, { v8, maxWidth })
	end

	if FFlagAppChatEnableAutotranslation and joined.translatedText then
		local v14 = {
			TextColor3 = v11,
			Font = if not foundationFontFaceMigration then font else nil,
			FontFace = 0,
			TextSize = 0,
			TextTransparency = 0,
			sizeConstraint = 0
		}

		local v16 = if foundationFontFaceMigration then normalizeFontFace(font) else nil
		v14.FontFace = v16
		v14.TextSize = textSize
		v14.TextTransparency = joined.isPending and v7.Theme.TextMuted.Transparency or 0
		v14.sizeConstraint = v12

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
			Wrapper = React.createElement(
				view,
				{ tag = "auto-xy col gap-xsmall", sizeConstraint = v13 },
				{
					textContent = React.createElement(text, Cryo.Dictionary.union(v14, {
						Text = text2,
						LayoutOrder = 1,
						tag = {
							["text-align-x-left text-align-y-top auto-xy text-wrap content-muted text-body-small"] = true,
							["text-truncate-end"] = isRepliedTo,
							["text-truncate-none"] = not isRepliedTo
						}
					})),
					Divider = React.createElement(
						view,
						{ tag = "size-0 self-stretch auto-y", LayoutOrder = 2 },
						React.createElement(divider, {
							variant = dividerVariant.Default
						})
					),
					translatedTextContent = React.createElement(text, Cryo.Dictionary.union(v14, {
						Text = joined.translatedText,
						LayoutOrder = 3,
						tag = {
							["text-align-x-left text-align-y-top auto-xy text-wrap"] = true,
							["text-truncate-none"] = not isRepliedTo,
							["text-truncate-end"] = isRepliedTo
						}
					}))
				}
			)
		})
	else
		local createElement = React.createElement
		local v15 = {
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
		local v18 = {
			Text = text2,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			TextColor3 = v11,
			AutomaticSize = Enum.AutomaticSize.XY,
			Font = if not foundationFontFaceMigration then font else nil,
			FontFace = 0,
			TextSize = 0,
			Size = 0,
			TextTransparency = 0,
			TextYAlignment = 0,
			TextTruncate = 0,
			TextWrapped = true
		}

		local v20 = if foundationFontFaceMigration then normalizeFontFace(font) else nil
		v18.FontFace = v20
		v18.TextSize = textSize
		v18.Size = UDim2.fromOffset(math.ceil(v9.X), (math.ceil(v9.Y)))
		v18.TextTransparency = joined.isPending and v7.Theme.TextMuted.Transparency or 0
		v18.TextYAlignment = Enum.TextYAlignment.Top
		local v21 = if isRepliedTo then Enum.TextTruncate.AtEnd else nil
		v18.TextTruncate = v21
		return createElement(ChatBubbleContainer, v15, {
			textContent = createElement2("TextLabel", v18, {
				SizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(v8 or maxWidth, not isRepliedTo and 1e999 or textSize * 3)
				})
			})
		})
	end
end

return LUAUFORGE_MODULE_GLOBALS_hlk_PlainText
