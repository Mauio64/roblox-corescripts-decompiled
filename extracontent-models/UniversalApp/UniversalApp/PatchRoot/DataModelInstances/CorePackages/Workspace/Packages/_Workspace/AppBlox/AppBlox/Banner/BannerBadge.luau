local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Icon = Foundation.Icon
local View = Foundation.View
local FoundationText = Foundation.Text
local withDefaults = Foundation.Utility.withDefaults
local withCommonProps = Foundation.Utility.withCommonProps
local IconSize = Foundation.Enums.IconSize
local IconPosition = Foundation.Enums.IconPosition
local t1 = {
	testId = "--badge"
}

local function BannerBadge(p1, p2) -- line: 54
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), IconSize (copy), React (copy), IconPosition (copy), Icon (copy), View (copy), withCommonProps (copy), FoundationText (copy)
	local v16 = withDefaults(p1, t1)
	local v17 = useTokens()
	local XSmall = IconSize.XSmall
	local v19 = React.useMemo(function() -- line: 61
		-- upvalues: v16 (copy), IconPosition (copy)
		if typeof(v16.icon) == "string" then
			return {
				name = v16.icon,
				position = IconPosition.Left
			}
		end

		return v16.icon
	end, { v16.icon })
	local v20 = v16.text ~= nil and #v16.text > 0
	local t2 = {
		container = {
			tag = "radius-circle row align-y-center align-x-center gap-xsmall",
			stroke = nil,
			backgroundStyle = v17.Color.Shift.Shift_300
		},
		text = {
			tag = "auto-xy text-label-small"
		},
		content = {
			style = v17.Color.Content.Emphasis
		}
	}

	if not v20 then
		t2.container.tag = t2.container.tag .. " size-600"
	else
		t2.container.tag = t2.container.tag .. " size-0-600 auto-x padding-x-small"
	end

	local v22 = nil

	if v19 ~= nil then
		v22 = React.createElement(Icon, {
			name = v19.name,
			variant = v19.variant,
			size = XSmall,
			style = t2.content.style,
			LayoutOrder = v19.position ~= IconPosition.Left and 3 or 1,
			testId = `{ v16.testId }--icon`
		})
	end

	return React.createElement(View, withCommonProps(v16, {
		backgroundStyle = t2.container.backgroundStyle,
		tag = t2.container.tag,
		ref = p2
	}), {
		Icon = v22,
		Text = if not v20 then nil else React.createElement(FoundationText, {
			RichText = true,
			LayoutOrder = 2,
			Text = v16.text,
			textStyle = t2.content.style,
			tag = t2.text.tag,
			testId = `{ v16.testId }--text`
		})
	})
end

return React.memo(React.forwardRef(BannerBadge))
