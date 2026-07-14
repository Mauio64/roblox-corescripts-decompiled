local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(FoundationParent.BuilderIcons)

local Flags = require(Foundation.Utility.Flags)
local Icon = require(Foundation.Components.Icon)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)

require(Foundation.Enums.IconSize)
require(Foundation.Enums.InputSize)

local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local useSegmentedControlVariants = require(script.Parent.useSegmentedControlVariants)

local function Segment(p1, p2) -- line: 44
	-- upvalues: useTokens (copy), useSegmentedControlVariants (copy), Flags (copy), React (copy), View (copy), withCommonProps (copy), Icon (copy), Text (copy)
	local v14 = useTokens()
	local v15 = useSegmentedControlVariants(v14, p1.size, if not Flags.FoundationSegmentedControlCircular then nil else p1.isCircular)

	if _G.__DEV__ == true then
		assert(p1.text == nil or p1.icon == nil, "Segment: `text` and `icon` are mutually exclusive. Only one can be provided.")
	end

	local v16 = p1.icon ~= nil
	local name = nil
	local variant = nil
	local icon = nil

	if v16 then
		if typeof(p1.icon) == "table" then
			local icon2 = p1.icon

			name = icon2.name
			variant = icon2.variant
		else
			name = p1.icon
		end

		icon = v15.icon
	end

	return React.createElement(View, withCommonProps(p1, {
		tag = v15.segment.tag,
		onActivated = function() -- line: 82
			-- upvalues: p1 (copy)
			p1.onActivated(p1.id)
		end,
		ref = p2
	}), {
		Text = if not v16 then React.createElement(Text, {
			tag = v15.text.tag,
			Text = p1.text
		}) else React.createElement(Icon, {
			name = name,
			variant = variant,
			size = icon.size,
			style = icon.style
		})
	})
end

return React.memo(React.forwardRef(Segment))
