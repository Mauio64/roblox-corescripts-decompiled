local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Foundation")
local popover = Foundation.Popover
local popoverSide = Foundation.Enums.PopoverSide
local popoverAlign = Foundation.Enums.PopoverAlign
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/ControlBarTypes")
local CompactTooltipContent = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Components/CompactTooltipContent")
local fFlagMeProfileEntryTooltipEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags").FFlagMeProfileEntryTooltipEnabled

local function Tooltip(props)
	local v5 = useTokens()
	local v6 = fFlagMeProfileEntryTooltipEnabled and props.compact == true
	local side = props.side or popoverSide.Right
	local v7

	if fFlagMeProfileEntryTooltipEnabled then
		v7 = React.useMemo(function()
			return { position = side, offset = v5.Size.Size_150 }
		end, { side, v5.Size.Size_150 })
		React.useEffect(function()
			if props.open and props.onShown then
				props.onShown()
			end
		end, { props.open, props.onShown })
	end

	local createElement = React.createElement
	local root = popover.Root
	local v8 = {
		isOpen = props.open or false
	}

	local createElement2 = React.createElement
	local anchor = popover.Anchor
	local v10 = if fFlagMeProfileEntryTooltipEnabled then props.LayoutOrder else nil
	local v11 = if fFlagMeProfileEntryTooltipEnabled then props.Visible else nil
	local children = {
		Anchor = createElement2(anchor, { LayoutOrder = v10, Visible = v11 }, props.children),
		Content = 0
	}
	local createElement3 = React.createElement
	local content = popover.Content

	local v13 = props.align

	if not v13 then
		v13 = if v6 then popoverAlign.Start else popoverAlign.Center
	end

	if not v6 then
		v7 = side
	end

	local v14 = if v6 then v5.Inverse.Surface.Surface_0 else v5.Color.OverMedia.OverMedia_0
	local v15 = props.radius

	if not v15 then
		v15 = if v6 then radius.Medium else radius.Small
	end

	local v17

	if v6 then
		v17 = React.createElement(CompactTooltipContent, {
			bodyText = props.bodyText,
			onDismiss = props.onDismiss
		})
	else
		local createElement4 = React.createElement
		local view = Foundation.View

		local v20 = if props.titleText then React.createElement(Foundation.Text, {
			Text = props.titleText,
			tag = "auto-xy text-title-medium content-emphasis"
		}) else nil

		local v21 = if props.bodyText then React.createElement(Foundation.Text, {
			Text = props.bodyText,
			tag = "auto-xy text-body-small"
		}) else nil
		v17 = createElement4(view, { tag = "col gap-small auto-xy padding-medium" }, {
			Title = v20,
			Subtitle = v21
		})
	end

	children.Content = createElement3(content, {
		align = v13,
		side = v7,
		backgroundStyle = v14,
		radius = v15,
		selectionGroup = if v6 then false else nil
	}, v17)
	return createElement(root, v8, children)
end

return Tooltip
