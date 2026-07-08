local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)
local Foundation = require(AvatarExperienceControlBarParent.Foundation)
local Popover = Foundation.Popover
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

require(AvatarExperienceControlBar.ControlBarTypes)

local function Tooltip(p1) -- line: 15
	-- upvalues: useTokens (copy), React (copy), Popover (copy), PopoverAlign (copy), PopoverSide (copy), EnumsRadius (copy), Foundation (copy)
	local v12 = useTokens()

	return React.createElement(Popover.Root, {
		isOpen = p1.open or false
	}, {
		Anchor = React.createElement(Popover.Anchor, nil, p1.children),
		Content = React.createElement(Popover.Content, {
			align = p1.align or PopoverAlign.Center,
			side = p1.side or PopoverSide.Right,
			backgroundStyle = v12.Color.OverMedia.OverMedia_0,
			radius = p1.radius or EnumsRadius.Small
		}, React.createElement(Foundation.View, {
			tag = "col gap-small padding-medium auto-xy"
		}, {
			Title = if not p1.titleText then nil else React.createElement(Foundation.Text, {
				tag = "auto-xy text-title-medium content-emphasis",
				Text = p1.titleText
			}),
			Subtitle = if not p1.bodyText then nil else React.createElement(Foundation.Text, {
				tag = "auto-xy text-body-small",
				Text = p1.bodyText
			})
		}))
	})
end

return Tooltip
