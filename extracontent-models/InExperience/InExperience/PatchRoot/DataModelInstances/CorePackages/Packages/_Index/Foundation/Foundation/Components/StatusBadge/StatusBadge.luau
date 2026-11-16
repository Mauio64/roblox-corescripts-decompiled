local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

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

local v = {
	variant = StatusBadgeVariant.Standard,
	shape = StatusBadgeShape.Utility,
	size = StatusBadgeSize.Small,
	testId = "--foundation-status-badge"
}

local function StatusBadge(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useStatusBadgeVariants(useTokens(), v2.variant, v2.shape, v2.size)
	local v4 = useScaledValue(200)

	return React.createElement(View, withCommonProps(v2, { tag = v3.container.tag, ref = ref }), {
		Content = React.createElement(View, {
			tag = v3.content.tag,
			layout = v3.content.gap and {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v3.content.gap)
			} or nil,
			LayoutOrder = 1,
			testId = `{v2.testId}--content`
		}, {
			StatusLight = React.createElement(
				View,
				{ tag = v3.statusLight.tag, LayoutOrder = 1, testId = `{v2.testId}--status-light` },
				{
					Dot = React.createElement(View, {
						tag = v3.dot.tag,
						LayoutOrder = 1,
						testId = `{v2.testId}--dot`
					})
				}
			),
			Text = React.createElement(Text, {
				Text = v2.text,
				tag = v3.text.tag,
				textStyle = v3.text.style,
				LayoutOrder = 2,
				sizeConstraint = { MaxSize = Vector2.new(v4, 1e999) },
				testId = `{v2.testId}--text`
			})
		})
	})
end

return React.memo(React.forwardRef(StatusBadge))
