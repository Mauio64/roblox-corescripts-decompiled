local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Popover = Foundation.Popover
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
require(AvatarExperienceControlBar.ControlBarTypes)
local CompactTooltipContent = require(script.Parent.CompactTooltipContent)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagMeProfileEntryTooltipEnabled = AvatarExperienceFlags.FFlagMeProfileEntryTooltipEnabled

local function Tooltip(props)
	local v = useTokens()
	local v2 = FFlagMeProfileEntryTooltipEnabled and props.compact == true
	local side = props.side or PopoverSide.Right
	local side2

	if FFlagMeProfileEntryTooltipEnabled then
		side2 = React.useMemo(function()
			return { position = side, offset = v.Size.Size_150 }
		end, { side, v.Size.Size_150 })
		React.useEffect(function()
			if props.open and props.onShown then
				props.onShown()
			end
		end, { props.open, props.onShown })
	end

	local createElement = React.createElement
	local root = Popover.Root
	local v3 = {
		isOpen = props.open or false
	}

	local createElement2 = React.createElement
	local anchor = Popover.Anchor
	local layoutOrder

	if FFlagMeProfileEntryTooltipEnabled then
		layoutOrder = props.LayoutOrder
	end

	local visible

	if FFlagMeProfileEntryTooltipEnabled then
		visible = props.Visible
	end

	local children = {
		Anchor = createElement2(anchor, { LayoutOrder = layoutOrder, Visible = visible }, props.children),
		Content = 0
	}
	local createElement3 = React.createElement
	local content = Popover.Content

	local align = props.align

	if not align then
		align = if v2 then PopoverAlign.Start else PopoverAlign.Center
	end

	if not v2 then
		side2 = side
	end

	local backgroundStyle

	if v2 then
		backgroundStyle = v.Inverse.Surface.Surface_0
	else
		backgroundStyle = v.Color.OverMedia.OverMedia_0
	end

	local radius = props.radius

	if not radius then
		radius = if v2 then Radius.Medium else Radius.Small
	end

	local v4

	if v2 then
		v4 = React.createElement(CompactTooltipContent, {
			bodyText = props.bodyText,
			onDismiss = props.onDismiss
		})
	else
		local createElement4 = React.createElement
		local view = Foundation.View
		local title

		if props.titleText then
			title = React.createElement(Foundation.Text, {
				Text = props.titleText,
				tag = "auto-xy text-title-medium content-emphasis"
			})
		end

		local subtitle

		if props.bodyText then
			subtitle = React.createElement(Foundation.Text, {
				Text = props.bodyText,
				tag = "auto-xy text-body-small"
			})
		end

		v4 = createElement4(view, { tag = "col gap-small auto-xy padding-medium" }, {
			Title = title,
			Subtitle = subtitle
		})
	end

	children.Content = createElement3(content, {
		align = align,
		side = side2,
		backgroundStyle = backgroundStyle,
		radius = radius,
		selectionGroup = not v2 and nil
	}, v4)
	return createElement(root, v3, children)
end

return Tooltip
