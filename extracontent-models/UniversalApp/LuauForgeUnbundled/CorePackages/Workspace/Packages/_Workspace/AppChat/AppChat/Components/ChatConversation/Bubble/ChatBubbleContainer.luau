local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local colorSystem = UIBlox.Common.Style.ColorSystem
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local ChatBubbleEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Bubble/ChatBubbleEnum")
local ChatBubbleGroupable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Bubble/ChatBubbleGroupable")

local useStyle = UIBlox.Core.Style.useStyle
local useSelectedTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.useSelectedTheme
local RepliedToMarker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Bubble/RepliedToMarker")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local colorMode = Foundation.Enums.ColorMode

local unfilteredMessageColorConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/unfilteredMessageColorConfig")
local FFlagAppChatConsoleFocusFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConsoleFocusFixes")
local FFlagAppChatBlueSentBubbles = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatBlueSentBubbles")
local FFlagAppChatBubbleThemeTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatBubbleThemeTokens")

local BUBBLE_VARIANTS = ChatBubbleEnum.BUBBLE_VARIANTS

local v5 = {
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
	[React.Change.AbsoluteSize] = function(p2) end
}

local function ChatBubbleContainer(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useTokens()
	local v8

	if FFlagAppChatConsoleFocusFixes then
		v8 = { radius = UDim.new(0, v6.Size.Size_500) }
	else
		v8 = Foundation.Enums.CursorType.RoundedSlot
	end

	local v9 = useCursor(v8)

	local v10 = useStyle()
	local children = joined.children or {}
	local isIncoming = joined.isIncoming
	local isPending = joined.isPending
	local isUnfiltered = joined.isUnfiltered

	local v11 = useSelectedTheme()

	local state, setState = React.useState(v10.Theme.UIDefault)

	local function setBubbleStyle()
		local v12

		if joined.isRepliedTo and FFlagAppChatBubbleThemeTokens then
			v12 = {
				Color = v6.Color.Shift.Shift_200.Color3,
				Transparency = v6.Color.Shift.Shift_200.Transparency
			}
		elseif joined.isRepliedTo then
			v12 = { Color = 0, Transparency = 0 }
			local v13 = if v11 == string.lower(colorMode.Light) then colorSystem.Gray[30] else colorSystem.Gray[90]
			v12.Color = v13
		elseif joined.isAssetCard then
			v12 = {
				Color = v6.Color.Shift.Shift_400.Color3,
				Transparency = v6.Color.Shift.Shift_400.Transparency
			}
		elseif isIncoming then
			v12 = {
				Color = v6.Color.Shift.Shift_400.Color3,
				Transparency = v6.Color.Shift.Shift_400.Transparency
			}
		elseif isUnfiltered or FFlagAppChatBlueSentBubbles then
			v12 = {
				Color = v6.Color.System.Emphasis.Color3,
				Transparency = v6.Color.System.Emphasis.Transparency
			}
		else
			v12 = {
				Color = v6.Color.Extended.Gray.Gray_600.Color3,
				Transparency = v6.Color.Extended.Gray.Gray_600.Transparency
			}
		end

		setState(v12)
	end

	local function setPressedBubbleStyle()
		if joined.isRepliedTo or joined.isPending then
			return
		end

		if FFlagAppChatBubbleThemeTokens then
			local v12

			if isIncoming or joined.isAssetCard then
				local press = v6.Color.State.Press
				v12 = { Color = press.Color3, Transparency = press.Transparency }
			elseif isUnfiltered or FFlagAppChatBlueSentBubbles then
				v12 = {
					Color = v6.Color.Extended.Blue.Blue_1000.Color3,
					Transparency = v6.Color.Extended.Blue.Blue_1000.Transparency
				}
			else
				v12 = {
					Color = v6.Color.Extended.Gray.Gray_700.Color3,
					Transparency = v6.Color.Extended.Gray.Gray_700.Transparency
				}
			end

			setState(v12)
		else
			local v12

			if isIncoming then
				v12 = { Color = 0, Transparency = 0.35 }
				local v13 = if v11 == string.lower(colorMode.Light) then colorSystem.Gray[50] else colorSystem.Gray[70]
				v12.Color = v13
			elseif (isUnfiltered or FFlagAppChatBlueSentBubbles) and not joined.isAssetCard then
				v12 = { Color = 0, Transparency = 0 }
				local v13 = if v11 == colorMode.Light then unfilteredMessageColorConfig.UnfilteredMessagePressedLightColor3 else unfilteredMessageColorConfig.UnfilteredMessagePressedDarkColor3
				v12.Color = v13

				v12.Transparency = unfilteredMessageColorConfig.UnfilteredMessageTransparency
			else
				v12 = { Color = 0, Transparency = 0.4 }
				local v13 = if v11 == string.lower(colorMode.Light) then colorSystem.Gray[50] else colorSystem.Gray[70]
				v12.Color = v13
			end

			setState(v12)
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
		v11,
		isIncoming,
		isPending,
		isUnfiltered,
		joined.isAssetCard
	})

	local function getBubbleVariant(p3, p4, p5)
		if p3 and p4 or p5 then
			return BUBBLE_VARIANTS.SINGLE
		end

		if p3 then
			return BUBBLE_VARIANTS.TOP
		end

		if p4 then
			return BUBBLE_VARIANTS.BOTTOM
		end

		return BUBBLE_VARIANTS.MIDDLE
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v12 = {
		tag = "size-0-0 auto-xy",
		LayoutOrder = joined.LayoutOrder,
		BackgroundTransparency = 1,
		selection = {
			Selectable = not FFlagAppChatConsoleFocusFixes or not joined.isRepliedTo,
			SelectionImageObject = v9
		},
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = isIncoming and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right,
			Padding = UDim.new(0, ChatBubbleEnum.REPLIED_TO_MARKER_GAP)
		},
		ref = 0
	}

	local v13 = if FFlagAppChatConsoleFocusFixes then joined.bubbleRef else nil
	v12.ref = v13

	local createElement2 = React.createElement
	local v16 = {
		alignment = isIncoming and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right,
		children = children,
		imageStyle = { Color3 = state.Color, Transparency = state.Transparency },
		layoutOrder = 1,
		padding = joined.padding,
		variant = 0
	}
	local hasTail = joined.hasTail
	local isLastMessageInMessageGroup = joined.isLastMessageInMessageGroup
	local isRepliedTo = joined.isRepliedTo
	local v17

	if hasTail and isLastMessageInMessageGroup or isRepliedTo then
		v17 = BUBBLE_VARIANTS.SINGLE
	elseif hasTail then
		v17 = BUBBLE_VARIANTS.TOP
	else
		v17 = if isLastMessageInMessageGroup then BUBBLE_VARIANTS.BOTTOM else BUBBLE_VARIANTS.MIDDLE
	end

	v16.variant = v17
	local v14 = { bubble = createElement2(ChatBubbleGroupable, v16), repliedToMarker = 0 }

	local v18 = if joined.isRepliedTo then React.createElement(RepliedToMarker, {
		isIncoming = isIncoming,
		layoutOrder = joined.isIncoming and 0 or 2
	}) else nil
	v14.repliedToMarker = v18
	return createElement(view, v12, v14)
end

return React.memo(ChatBubbleContainer)
