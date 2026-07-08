local Parent = script:FindFirstAncestor("AppChat").Parent
local Text = require(Parent.AppCommonLib).Text
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local Foundation = require(Parent.Foundation)
local Enums = Foundation.Enums
local useMessageFtuxTooltip = require(script.Parent.useMessageFtuxTooltip)
local MessageFtuxTooltipVariant = require(script.Parent.MessageFtuxTooltipVariant)
local t1 = {
	isReversed = false,
	variant = MessageFtuxTooltipVariant.None
}

return React.memo(function(t2: {[any]: any}) -- line: 25
	-- upvalues: Cryo (copy), t1 (copy), Foundation (copy), useMessageFtuxTooltip (copy), React (copy), Text (copy), Enums (copy)
	local v11 = Cryo.Dictionary.union(t1, t2)
	local v12 = Foundation.Hooks.useTokens()
	local v13 = useMessageFtuxTooltip(v11.variant)
	local v14, v15 = React.useState(false)
	local v16, v17 = React.useState(false)

	React.useEffect(function() -- line: 32
		-- upvalues: v12 (copy), Text (copy), v13 (copy), v15 (copy), v11 (copy), v17 (copy)
		local TitleSmall = v12.Typography.TitleSmall
		local v21 = Text.GetTextWidth(v13.text, TitleSmall.Font, TitleSmall.FontSize) + v12.Padding.Small * 2

		v15(not not v11.messageRef.current and v21 > v11.messageRef.current.AbsoluteSize.X)
		v17(true)
	end, {
		v13.text,
		v12
	})

	local v18, v19 = React.useMemo(function() -- line: 43
		-- upvalues: v14 (copy), v11 (copy), Enums (copy), v12 (copy)
		local v22 = if not v14 then if not v11.isReversed then Enums.PopoverAlign.Start else Enums.PopoverAlign.End else if not v11.isReversed then Enums.PopoverAlign.End else Enums.PopoverAlign.Start

		if v14 then
			return v22, 0
		end

		if v11.isReversed then
			return v22, v12.Padding.Medium
		end

		return v22, -v12.Padding.Medium
	end, {
		v14,
		v11.isReversed,
		v12
	})

	if not v13.isDismissed then
		return (React.createElement(Foundation.Popover.Root, {
			isOpen = v16
		}, {
			Anchor = React.createElement(Foundation.Popover.Anchor, {
				anchorRef = v11.messageRef
			}),
			Content = React.createElement(Foundation.Popover.Content, {
				hasArrow = true,
				side = {
					position = Foundation.Enums.PopoverSide.Bottom,
					offset = -v12.Padding.Small
				},
				align = {
					position = v18,
					offset = v19
				},
				radius = Foundation.Enums.Radius.Small,
				backgroundStyle = v12.Color.Content.Emphasis,
				onPressedOutside = v13.handleDismiss
			}, {
				TooltipText = React.createElement(Foundation.Text, {
					tag = "auto-xy text-title-small padding-x-small padding-y-xsmall content-inverse-emphasis",
					Text = v13.text
				})
			})
		}))
	end

	return nil
end)
