local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

local function SduiRevealRowsButtonWithDivider(props)
	local element = React.createElement(getSduiComponentWrapper(props.ctaComponent), {
		componentConfig = props.ctaComponent,
		sduiContext = props.sduiContext,
		debugName = "SduiRevealRowsButtonWithDivider.CtaComponent",
		extraLocalProps = { onActivated = props.onActivated }
	})

	return React.createElement(
		Foundation.View,
		{
			tag = "row align-y-center gap-xsmall size-full-0 auto-y",
			LayoutOrder = props.layoutOrder,
			ZIndex = props.zIndex
		},
		{
			LeadingLine = React.createElement(Foundation.View, { tag = "grow", LayoutOrder = 1 }, {
				Divider = React.createElement(Foundation.Divider)
			}),
			ButtonOutline = React.createElement(
				Foundation.View,
				{ tag = "auto-xy stroke-default radius-circle", LayoutOrder = 2 },
				{ Cta = element }
			),
			TrailingLine = React.createElement(Foundation.View, { tag = "grow", LayoutOrder = 3 }, {
				Divider = React.createElement(Foundation.Divider)
			})
		}
	)
end

return React.memo(SduiRevealRowsButtonWithDivider)
