local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local StatusBadgeShape = require(Foundation.Enums.StatusBadgeShape)
local StatusBadgeSize = require(Foundation.Enums.StatusBadgeSize)
local StatusBadgeVariant = require(Foundation.Enums.StatusBadgeVariant)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local useStatusBadgeVariants = require(script.Parent.useStatusBadgeVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local t1 = {
	testId = "--foundation-status-badge",
	variant = StatusBadgeVariant.Standard,
	shape = StatusBadgeShape.Utility,
	size = StatusBadgeSize.Small
}

local function StatusBadge(p1, p2) -- line: 38
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useStatusBadgeVariants (copy), useScaledValue (copy), React (copy), View (copy), withCommonProps (copy), Text (copy)
	local v18 = withDefaults(p1, t1)
	local v19 = useTokens()
	local v20 = useStatusBadgeVariants(v19, v18.variant, v18.shape, v18.size)
	local v21 = useScaledValue(200)

	return React.createElement(View, withCommonProps(v18, {
		tag = v20.container.tag,
		ref = p2
	}), {
		Content = React.createElement(View, {
			LayoutOrder = 1,
			tag = v20.content.tag,
			layout = if not v20.content.gap then nil else {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v20.content.gap)
			},
			testId = `{ v18.testId }--content`
		}, {
			StatusLight = React.createElement(View, {
				LayoutOrder = 1,
				tag = v20.statusLight.tag,
				testId = `{ v18.testId }--status-light`
			}, {
				Dot = React.createElement(View, {
					LayoutOrder = 1,
					tag = v20.dot.tag,
					testId = `{ v18.testId }--dot`
				})
			}),
			Text = React.createElement(Text, {
				LayoutOrder = 2,
				Text = v18.text,
				tag = v20.text.tag,
				textStyle = v20.text.style,
				sizeConstraint = {
					MaxSize = Vector2.new(v21, 1e999)
				},
				testId = `{ v18.testId }--text`
			})
		})
	})
end

return React.memo(React.forwardRef(StatusBadge))
