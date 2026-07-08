local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local UIBlox = require(AppChatParent.UIBlox)
local ColorSystem = UIBlox.Common.Style.ColorSystem
local Cryo = require(AppChatParent.Cryo)
local Constants = UIBlox.App.Style.Constants
local ChatBubbleEnum = require(script.Parent.ChatBubbleEnum)
local ChatBubbleGroupable = require(script.Parent.ChatBubbleGroupable)
local useStyle = UIBlox.Core.Style.useStyle
local useSelectedTheme = require(AppChatParent.RoactUtils).Hooks.useSelectedTheme
local RepliedToMarker = require(script.Parent.RepliedToMarker)
local Foundation = require(AppChatParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local unfilteredMessageColorConfig = require(AppChat.Flags.unfilteredMessageColorConfig)
local BUBBLE_VARIANTS = ChatBubbleEnum.BUBBLE_VARIANTS
local t1 = {
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
	[React.Change.AbsoluteSize] = function(_) -- line: 48
	end
}

local function ChatBubbleContainer(t2: {[any]: any}) -- line: 51
	-- upvalues: Cryo (copy), t1 (copy), useCursor (copy), Foundation (copy), useTokens (copy), useStyle (copy), useSelectedTheme (copy), React (copy), Constants (copy), ColorSystem (copy), unfilteredMessageColorConfig (copy), BUBBLE_VARIANTS (copy), ChatBubbleEnum (copy), ChatBubbleGroupable (copy), RepliedToMarker (copy)
	local v22 = Cryo.Dictionary.join(t1, t2)
	local v23 = useCursor(Foundation.Enums.CursorType.RoundedSlot)
	local v24 = useTokens()
	local v25 = useStyle()
	local v26 = v22.children or {}
	local isIncoming = v22.isIncoming
	local isPending = v22.isPending
	local isUnfiltered = v22.isUnfiltered
	local v30 = useSelectedTheme()
	local v31, v32 = React.useState(v25.Theme.UIDefault)

	local function setBubbleStyle() -- line: 66
		-- upvalues: v22 (copy), v30 (copy), Constants (copy), ColorSystem (copy), v24 (copy), isIncoming (copy), isUnfiltered (copy), v32 (copy)
		local v37 = if not v22.isRepliedTo then if not v22.isAssetCard then if not isIncoming then if not isUnfiltered then {
			Color = v24.Color.Extended.Gray.Gray_600.Color3,
			Transparency = v24.Color.Extended.Gray.Gray_600.Transparency
		} else {
			Color = v24.Color.System.Emphasis.Color3,
			Transparency = v24.Color.System.Emphasis.Transparency
		} else {
			Color = v24.Color.Shift.Shift_400.Color3,
			Transparency = v24.Color.Shift.Shift_400.Transparency
		} else {
			Color = v24.Color.Shift.Shift_400.Color3,
			Transparency = v24.Color.Shift.Shift_400.Transparency
		} else {
			Transparency = 0,
			Color = if v30 ~= string.lower(Constants.ThemeName.Light) then ColorSystem.Gray[90] else ColorSystem.Gray[30]
		}

		v32(v37)
	end
	local function setPressedBubbleStyle() -- line: 104
		-- upvalues: v22 (copy), isIncoming (copy), v30 (copy), Constants (copy), ColorSystem (copy), isUnfiltered (copy), unfilteredMessageColorConfig (copy), v32 (copy)
		if v22.isRepliedTo or v22.isPending then
			return
		end

		local v38 = if not isIncoming then if not isUnfiltered or v22.isAssetCard then {
			Transparency = 0.4,
			Color = if v30 ~= string.lower(Constants.ThemeName.Light) then ColorSystem.Gray[70] else ColorSystem.Gray[50]
		} else {
			Color = if v30 ~= Constants.ThemeName.Light then unfilteredMessageColorConfig.UnfilteredMessagePressedDarkColor3 else unfilteredMessageColorConfig.UnfilteredMessagePressedLightColor3,
			Transparency = unfilteredMessageColorConfig.UnfilteredMessageTransparency
		} else {
			Transparency = 0.35,
			Color = if v30 ~= string.lower(Constants.ThemeName.Light) then ColorSystem.Gray[70] else ColorSystem.Gray[50]
		}

		v32(v38)
	end

	React.useLayoutEffect(function() -- line: 139
		-- upvalues: v22 (copy), setPressedBubbleStyle (copy), setBubbleStyle (copy)
		if v22.isPressed then
			setPressedBubbleStyle()

			return
		end

		setBubbleStyle()
	end, {
		v22.isPressed,
		v22.isRepliedTo,
		v30,
		isIncoming,
		isPending,
		isUnfiltered,
		v22.isAssetCard
	})

	local function getBubbleVariant(p2, p3, p4) -- line: 157
		-- upvalues: BUBBLE_VARIANTS (copy)
		if p2 and p3 or p4 then
			return BUBBLE_VARIANTS.SINGLE
		end

		if p2 then
			return BUBBLE_VARIANTS.TOP
		end

		if p3 then
			return BUBBLE_VARIANTS.BOTTOM
		end

		return BUBBLE_VARIANTS.MIDDLE
	end
	local function renderGroupedBubbleUI() -- line: 173
		-- upvalues: React (copy), Foundation (copy), v22 (copy), v23 (copy), isIncoming (copy), ChatBubbleEnum (copy), ChatBubbleGroupable (copy), v26 (copy), v31 (copy), BUBBLE_VARIANTS (copy), RepliedToMarker (copy)
		local createElement = React.createElement
		local View = Foundation.View
		local t3 = {
			tag = "auto-xy size-0-0",
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			LayoutOrder = v22.LayoutOrder,
			selection = {
				Selectable = true,
				SelectionImageObject = v23
			},
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = isIncoming and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right,
				Padding = UDim.new(0, ChatBubbleEnum.REPLIED_TO_MARKER_GAP)
			}
		}
		local t4 = {}
		local createElement2 = React.createElement
		local v47 = ChatBubbleGroupable
		local t5 = {
			layoutOrder = 1,
			alignment = isIncoming and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right,
			children = v26,
			imageStyle = {
				Color3 = v31.Color,
				Transparency = v31.Transparency
			},
			padding = v22.padding
		}
		local hasTail = v22.hasTail
		local isLastMessageInMessageGroup = v22.isLastMessageInMessageGroup
		local isRepliedTo = v22.isRepliedTo

		t5.variant = if not (not not hasTail and isLastMessageInMessageGroup) and not isRepliedTo then if not hasTail then if not isLastMessageInMessageGroup then BUBBLE_VARIANTS.MIDDLE else BUBBLE_VARIANTS.BOTTOM else BUBBLE_VARIANTS.TOP else BUBBLE_VARIANTS.SINGLE
		t4.bubble = createElement2(v47, t5)
		t4.repliedToMarker = if not v22.isRepliedTo then nil else React.createElement(RepliedToMarker, {
			isIncoming = isIncoming,
			layoutOrder = not v22.isIncoming and 2 or 0
		})

		return createElement(View, t3, t4)
	end

	return renderGroupedBubbleUI()
end

return React.memo(ChatBubbleContainer)
