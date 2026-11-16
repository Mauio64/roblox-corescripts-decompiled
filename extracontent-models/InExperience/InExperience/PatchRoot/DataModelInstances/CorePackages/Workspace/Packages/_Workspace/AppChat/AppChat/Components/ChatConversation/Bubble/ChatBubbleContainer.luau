local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local ColorSystem = UIBlox.Common.Style.ColorSystem
local Cryo = require(parent.Cryo)
local ChatBubbleEnum = require(script.Parent.ChatBubbleEnum)
local ChatBubbleGroupable = require(script.Parent.ChatBubbleGroupable)

local useStyle = UIBlox.Core.Style.useStyle
local RoactUtils = require(parent.RoactUtils)
local useSelectedTheme = RoactUtils.Hooks.useSelectedTheme
local RepliedToMarker = require(script.Parent.RepliedToMarker)

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local ColorMode = Foundation.Enums.ColorMode

local unfilteredMessageColorConfig = require(AppChat.Flags.unfilteredMessageColorConfig)
local FFlagAppChatConsoleFocusFixes = require(AppChat.Flags.FFlagAppChatConsoleFocusFixes)
local FFlagAppChatBlueSentBubbles = require(AppChat.Flags.FFlagAppChatBlueSentBubbles)
local FFlagAppChatBubbleThemeTokens = require(AppChat.Flags.FFlagAppChatBubbleThemeTokens)

local BUBBLE_VARIANTS = ChatBubbleEnum.BUBBLE_VARIANTS

local v = {
	isIncoming = false,
	hasTail = false,
	padding = 12,
	LayoutOrder = 0,
	isPending = false,
	isUnfiltered = false,
	isAssetCard = false,
	isRepliedTo = false,
	isPressed = false,
	isLastMessageInMessageGroup = false,
	[React.Change.AbsoluteSize] = function(_) end
}

local function ChatBubbleContainer(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useTokens()
	local v3

	if FFlagAppChatConsoleFocusFixes then
		v3 = { radius = UDim.new(0, v2.Size.Size_500) }
	else
		v3 = Foundation.Enums.CursorType.RoundedSlot
	end

	local selectionImageObject = useCursor(v3)

	local v4 = useStyle()
	local children = joined.children or {}
	local isIncoming = joined.isIncoming
	local isPending = joined.isPending
	local isUnfiltered = joined.isUnfiltered

	local v5 = useSelectedTheme()

	local state, setState = React.useState(v4.Theme.UIDefault)

	local function setBubbleStyle()
		local v6

		if joined.isRepliedTo and FFlagAppChatBubbleThemeTokens then
			v6 = {
				Color = v2.Color.Shift.Shift_200.Color3,
				Transparency = v2.Color.Shift.Shift_200.Transparency
			}
		elseif joined.isRepliedTo then
			v6 = { Color = 0, Transparency = 0 }
			local color

			if v5 == string.lower(ColorMode.Light) then
				color = ColorSystem.Gray[30]
			else
				color = ColorSystem.Gray[90]
			end

			v6.Color = color
		elseif joined.isAssetCard then
			v6 = {
				Color = v2.Color.Shift.Shift_400.Color3,
				Transparency = v2.Color.Shift.Shift_400.Transparency
			}
		elseif isIncoming then
			v6 = {
				Color = v2.Color.Shift.Shift_400.Color3,
				Transparency = v2.Color.Shift.Shift_400.Transparency
			}
		elseif isUnfiltered or FFlagAppChatBlueSentBubbles then
			v6 = {
				Color = v2.Color.System.Emphasis.Color3,
				Transparency = v2.Color.System.Emphasis.Transparency
			}
		else
			v6 = {
				Color = v2.Color.Extended.Gray.Gray_600.Color3,
				Transparency = v2.Color.Extended.Gray.Gray_600.Transparency
			}
		end

		setState(v6)
	end

	local function setPressedBubbleStyle()
		if joined.isRepliedTo or joined.isPending then
			return
		end

		if FFlagAppChatBubbleThemeTokens then
			local v6

			if isIncoming or joined.isAssetCard then
				local press = v2.Color.State.Press
				v6 = { Color = press.Color3, Transparency = press.Transparency }
			elseif isUnfiltered or FFlagAppChatBlueSentBubbles then
				v6 = {
					Color = v2.Color.Extended.Blue.Blue_1000.Color3,
					Transparency = v2.Color.Extended.Blue.Blue_1000.Transparency
				}
			else
				v6 = {
					Color = v2.Color.Extended.Gray.Gray_700.Color3,
					Transparency = v2.Color.Extended.Gray.Gray_700.Transparency
				}
			end

			setState(v6)
		else
			local v6

			if isIncoming then
				v6 = { Color = 0, Transparency = 0.35 }
				local color

				if v5 == string.lower(ColorMode.Light) then
					color = ColorSystem.Gray[50]
				else
					color = ColorSystem.Gray[70]
				end

				v6.Color = color
			elseif (isUnfiltered or FFlagAppChatBlueSentBubbles) and not joined.isAssetCard then
				v6 = { Color = 0, Transparency = 0 }
				local color

				if v5 == ColorMode.Light then
					color = unfilteredMessageColorConfig.UnfilteredMessagePressedLightColor3
				else
					color = unfilteredMessageColorConfig.UnfilteredMessagePressedDarkColor3
				end

				v6.Color = color

				v6.Transparency = unfilteredMessageColorConfig.UnfilteredMessageTransparency
			else
				v6 = { Color = 0, Transparency = 0.4 }
				local color

				if v5 == string.lower(ColorMode.Light) then
					color = ColorSystem.Gray[50]
				else
					color = ColorSystem.Gray[70]
				end

				v6.Color = color
			end

			setState(v6)
		end
	end

	React.useLayoutEffect(function()
		if joined.isPressed then
			setPressedBubbleStyle()
		else
			setBubbleStyle()
		end
	end, {
		joined.isPressed,
		joined.isRepliedTo,
		v5,
		isIncoming,
		isPending,
		isUnfiltered,
		joined.isAssetCard
	})

	local function getBubbleVariant(hasTail, isLastMessageInMessageGroup, isRepliedTo) -- 1 equivalent call inferred from this helper
		if hasTail and isLastMessageInMessageGroup or isRepliedTo then
			return BUBBLE_VARIANTS.SINGLE
		end

		if hasTail then
			return BUBBLE_VARIANTS.TOP
		end

		if isLastMessageInMessageGroup then
			return BUBBLE_VARIANTS.BOTTOM
		end

		return BUBBLE_VARIANTS.MIDDLE
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v6 = {
		tag = "size-0-0 auto-xy",
		LayoutOrder = joined.LayoutOrder,
		BackgroundTransparency = 1,
		selection = {
			Selectable = not FFlagAppChatConsoleFocusFixes or not joined.isRepliedTo,
			SelectionImageObject = selectionImageObject
		},
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = isIncoming and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right,
			Padding = UDim.new(0, ChatBubbleEnum.REPLIED_TO_MARKER_GAP)
		},
		ref = 0
	}
	local ref

	if FFlagAppChatConsoleFocusFixes then
		ref = joined.bubbleRef
	end

	v6.ref = ref
	local v7 = {
		bubble = React.createElement(ChatBubbleGroupable, {
			alignment = isIncoming and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right,
			children = children,
			imageStyle = { Color3 = state.Color, Transparency = state.Transparency },
			layoutOrder = 1,
			padding = joined.padding,
			variant = getBubbleVariant(joined.hasTail, joined.isLastMessageInMessageGroup, joined.isRepliedTo) -- inferred equivalent call
		}),
		repliedToMarker = 0
	}
	local repliedToMarker

	if joined.isRepliedTo then
		repliedToMarker = React.createElement(RepliedToMarker, {
			isIncoming = isIncoming,
			layoutOrder = joined.isIncoming and 0 or 2
		})
	end

	v7.repliedToMarker = repliedToMarker
	return createElement(view, v6, v7)
end

return React.memo(ChatBubbleContainer)
