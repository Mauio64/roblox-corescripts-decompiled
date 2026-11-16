local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local iconButton = Foundation.IconButton
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function TextFontButton(props)
	local v5 = useTokens()

	local createElement = React.createElement
	local v7 = { LayoutOrder = props.LayoutOrder, tag = "auto-xy radius-circle" }

	local v8 = {
		Icon = React.createElement(iconButton, {
			icon = BuilderIcons.Icon.TextUppercaseALowercaseA,
			onActivated = props.onToggle,
			size = Foundation.Enums.InputSize.Medium,
			isCircular = true
		}),
		Highlight = 0
	}

	local v9 = if props.expanded then React.createElement(view, {
		ZIndex = 2,
		tag = "size-full radius-circle",
		backgroundStyle = v5.Color.State.Hover
	}) else nil
	v8.Highlight = v9
	return createElement(view, v7, v8)
end

return TextFontButton
