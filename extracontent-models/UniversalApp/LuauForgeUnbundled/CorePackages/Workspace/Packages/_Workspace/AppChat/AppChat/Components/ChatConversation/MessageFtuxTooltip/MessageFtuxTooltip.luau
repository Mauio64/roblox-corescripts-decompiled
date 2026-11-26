local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Style").GetTextSize
local enums = Foundation.Enums

local useMessageFtuxTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageFtuxTooltip/useMessageFtuxTooltip")
local MessageFtuxTooltipVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageFtuxTooltip/MessageFtuxTooltipVariant")

local v5 = { variant = MessageFtuxTooltipVariant.None, isReversed = false }

local function fn(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local v6 = Foundation.Hooks.useTokens()
	local v7 = useMessageFtuxTooltip(union.variant)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	React.useEffect(function()
		local titleSmall = v6.Typography.TitleSmall
		local v8 = getTextSize(v7.text, titleSmall.FontSize, titleSmall.Font, Vector2.new(10000, 10000)).X + v6.Padding.Small * 2

		local v10 = if union.messageRef.current then union.messageRef.current.AbsoluteSize.X < v8 else false
		setState(v10)

		setState2(true)
	end, { v7.text, v6, union.messageRef })

	local v8, v9 = React.useMemo(function()
		local v10

		if state then
			v10 = if union.isReversed then enums.PopoverAlign.Start else enums.PopoverAlign.End
		else
			v10 = if union.isReversed then enums.PopoverAlign.End else enums.PopoverAlign.Start
		end

		if state then
			return v10, 0
		end

		if union.isReversed then
			return v10, v6.Padding.Medium
		end

		return v10, -v6.Padding.Medium
	end, { state, union.isReversed, v6 })

	if v7.isDismissed then
		return nil
	end

	return (React.createElement(Foundation.Popover.Root, { isOpen = state2 }, {
		Anchor = React.createElement(Foundation.Popover.Anchor, {
			anchorRef = union.messageRef
		}),
		Content = React.createElement(Foundation.Popover.Content, {
			side = {
				position = Foundation.Enums.PopoverSide.Bottom,
				offset = -v6.Padding.Small
			},
			align = { position = v8, offset = v9 },
			hasArrow = true,
			radius = Foundation.Enums.Radius.Small,
			backgroundStyle = v6.Color.Content.Emphasis,
			onPressedOutside = v7.handleDismiss
		}, {
			TooltipText = React.createElement(Foundation.Text, {
				tag = "auto-xy padding-x-small padding-y-xsmall text-title-small content-inverse-emphasis",
				Text = v7.text
			})
		})
	}))
end

return React.memo(function(p2)
	if (p2.variant or v5.variant) == MessageFtuxTooltipVariant.None then
		return nil
	end

	return (React.createElement(fn, p2))
end)
