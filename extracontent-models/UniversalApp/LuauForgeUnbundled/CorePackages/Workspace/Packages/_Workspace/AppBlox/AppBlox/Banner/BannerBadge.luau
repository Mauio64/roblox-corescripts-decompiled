local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")

local useTokens = Foundation.Hooks.useTokens
local icon = Foundation.Icon
local view = Foundation.View
local text = Foundation.Text
local withDefaults = Foundation.Utility.withDefaults
local withCommonProps = Foundation.Utility.withCommonProps

local iconSize = Foundation.Enums.IconSize

local iconPosition = Foundation.Enums.IconPosition

local v5 = { testId = "--badge" }

local function BannerBadge(p2, p3)
	local v6 = withDefaults(p2, v5)

	local v7 = useTokens()

	local xSmall = iconSize.XSmall

	local v8 = React.useMemo(function()
		if typeof(v6.icon) == "string" then
			return { name = v6.icon, position = iconPosition.Left }
		end

		return v6.icon
	end, { v6.icon })

	local v9 = not (v6.text == nil) and #v6.text > 0

	local v10 = {
		container = {
			tag = "radius-circle row align-y-center align-x-center gap-xsmall",
			backgroundStyle = v7.Color.Shift.Shift_300,
			stroke = nil
		},
		text = { tag = "auto-xy text-label-small" },
		content = { style = v7.Color.Content.Emphasis }
	}

	if v9 then
		v10.container.tag = v10.container.tag .. " size-0-600 auto-x padding-x-small"
	else
		v10.container.tag = v10.container.tag .. " size-600"
	end

	local v11

	if v8 ~= nil then
		v11 = React.createElement(icon, {
			name = v8.name,
			variant = v8.variant,
			size = xSmall,
			style = v10.content.style,
			LayoutOrder = v8.position == iconPosition.Left and 1 or 3,
			testId = `{v6.testId}--icon`
		})
	end

	local createElement = React.createElement

	local v13 = withCommonProps(v6, {
		backgroundStyle = v10.container.backgroundStyle,
		tag = v10.container.tag,
		ref = p3
	})

	local v15 = if v9 then React.createElement(text, {
		Text = v6.text,
		textStyle = v10.content.style,
		RichText = true,
		LayoutOrder = 2,
		tag = v10.text.tag,
		testId = `{v6.testId}--text`
	}) else nil
	return createElement(view, v13, { Icon = v11, Text = v15 })
end

return React.memo(React.forwardRef(BannerBadge))
