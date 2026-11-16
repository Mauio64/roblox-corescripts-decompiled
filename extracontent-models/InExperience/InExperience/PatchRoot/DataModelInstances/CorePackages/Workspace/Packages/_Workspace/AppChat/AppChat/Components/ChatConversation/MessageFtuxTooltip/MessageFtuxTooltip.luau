local parent = script:FindFirstAncestor("AppChat").Parent

local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local Enums = Foundation.Enums

local useMessageFtuxTooltip = require(script.Parent.useMessageFtuxTooltip)
local MessageFtuxTooltipVariant = require(script.Parent.MessageFtuxTooltipVariant)

local v = { variant = MessageFtuxTooltipVariant.None, isReversed = false }

local function fn(p)
	local union = Cryo.Dictionary.union(v, p)
	local v2 = Foundation.Hooks.useTokens()
	local v3 = useMessageFtuxTooltip(union.variant)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	React.useEffect(function()
		local titleSmall = v2.Typography.TitleSmall
		local v4

		if FoundationFontFaceMigration then
			v4 = GetTextSize(v3.text, titleSmall.FontSize, titleSmall.Font, Vector2.new(10000, 10000)).X + v2.Padding.Small * 2
		else
			v4 = Text.GetTextWidth(v3.text, titleSmall.Font, titleSmall.FontSize) + v2.Padding.Small * 2
		end

		local v5

		if union.messageRef.current then
			v5 = union.messageRef.current.AbsoluteSize.X < v4
		else
			v5 = false
		end

		setState(v5)

		setState2(true)
	end, { v3.text, v2, union.messageRef })

	local position, offset = React.useMemo(function()
		local v4

		if state then
			if union.isReversed then
				v4 = Enums.PopoverAlign.Start
			else
				v4 = Enums.PopoverAlign.End
			end
		elseif union.isReversed then
			v4 = Enums.PopoverAlign.End
		else
			v4 = Enums.PopoverAlign.Start
		end

		if state then
			return v4, 0
		end

		if union.isReversed then
			return v4, v2.Padding.Medium
		end

		return v4, -v2.Padding.Medium
	end, { state, union.isReversed, v2 })

	if v3.isDismissed then
		return nil
	end

	return (React.createElement(Foundation.Popover.Root, { isOpen = state2 }, {
		Anchor = React.createElement(Foundation.Popover.Anchor, { anchorRef = union.messageRef }),
		Content = React.createElement(Foundation.Popover.Content, {
			side = {
				position = Foundation.Enums.PopoverSide.Bottom,
				offset = -v2.Padding.Small
			},
			align = { position = position, offset = offset },
			hasArrow = true,
			radius = Foundation.Enums.Radius.Small,
			backgroundStyle = v2.Color.Content.Emphasis,
			onPressedOutside = v3.handleDismiss
		}, {
			TooltipText = React.createElement(Foundation.Text, {
				tag = "auto-xy padding-x-small padding-y-xsmall text-title-small content-inverse-emphasis",
				Text = v3.text
			})
		})
	}))
end

return React.memo(function(p)
	if (p.variant or v.variant) == MessageFtuxTooltipVariant.None then
		return nil
	end

	return (React.createElement(fn, p))
end)
