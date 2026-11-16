local parent = script:FindFirstAncestor("AppBlox").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local useTokens = Foundation.Hooks.useTokens
local Icon = Foundation.Icon
local View = Foundation.View
local Text = Foundation.Text
local withDefaults = Foundation.Utility.withDefaults
local withCommonProps = Foundation.Utility.withCommonProps

local IconSize = Foundation.Enums.IconSize

local IconPosition = Foundation.Enums.IconPosition

local v = { testId = "--badge" }

local function BannerBadge(p, ref)
	local v2 = withDefaults(p, v)

	local v3 = useTokens()

	local xSmall = IconSize.XSmall

	local v4 = React.useMemo(function()
		if typeof(v2.icon) == "string" then
			return { name = v2.icon, position = IconPosition.Left }
		end

		return v2.icon
	end, { v2.icon })
	local v5

	if v2.text == nil then
		v5 = false
	else
		v5 = #v2.text > 0
	end

	local v6 = {
		container = {
			tag = "radius-circle row align-y-center align-x-center gap-xsmall",
			backgroundStyle = v3.Color.Shift.Shift_300,
			stroke = nil
		},
		text = { tag = "auto-xy text-label-small" },
		content = { style = v3.Color.Content.Emphasis }
	}

	if v5 then
		v6.container.tag = v6.container.tag .. " size-0-600 auto-x padding-x-small"
	else
		v6.container.tag = v6.container.tag .. " size-600"
	end

	local icon

	if v4 ~= nil then
		icon = React.createElement(Icon, {
			name = v4.name,
			variant = v4.variant,
			size = xSmall,
			style = v6.content.style,
			LayoutOrder = v4.position == IconPosition.Left and 1 or 3,
			testId = `{v2.testId}--icon`
		})
	end

	local createElement = React.createElement

	local v7 = withCommonProps(v2, {
		backgroundStyle = v6.container.backgroundStyle,
		tag = v6.container.tag,
		ref = ref
	})
	local text

	if v5 then
		text = React.createElement(Text, {
			Text = v2.text,
			textStyle = v6.content.style,
			RichText = true,
			LayoutOrder = 2,
			tag = v6.text.tag,
			testId = `{v2.testId}--text`
		})
	end

	return createElement(View, v7, { Icon = icon, Text = text })
end

return React.memo(React.forwardRef(BannerBadge))
