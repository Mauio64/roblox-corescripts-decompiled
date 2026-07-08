local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactUtils = require(FoundationParent.ReactUtils)
local AlertActions = require(Foundation.Components.AlertActions)
local AlertConstants = require(Foundation.Components.AlertActions.AlertConstants)

require(Foundation.Enums.AlertSeverity)

local BuilderIcons = require(FoundationParent.BuilderIcons)
local CloseAffordance = require(Foundation.Components.CloseAffordance)
local CloseAffordanceVariant = require(Foundation.Enums.CloseAffordanceVariant)
local ControlState = require(Foundation.Enums.ControlState)
local Icon = require(Foundation.Components.Icon)
local IconSize = require(Foundation.Enums.IconSize)
local InputSize = require(Foundation.Enums.InputSize)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local escapeRichText = require(Foundation.Utility.escapeRichText)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local IconVariant = BuilderIcons.IconVariant
local useFeedbackAlertVariants = require(script.Parent.useFeedbackAlertVariants)
local t1 = {
	testId = "--foundation-feedback-alert"
}

local function FeedbackAlert(p1, p2) -- line: 50
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useFeedbackAlertVariants (copy), ReactUtils (copy), escapeRichText (copy), React (copy), ControlState (copy), View (copy), withCommonProps (copy), Icon (copy), AlertConstants (copy), IconSize (copy), IconVariant (copy), Text (copy), StateLayerAffordance (copy), CloseAffordance (copy), InputSize (copy), CloseAffordanceVariant (copy), AlertActions (copy)
	local v27 = withDefaults(p1, t1)
	local v28 = useTokens()
	local v29 = useFeedbackAlertVariants(v28, v27.severity)
	local v30 = ReactUtils.useComposedRef(p2)
	local v31 = if not v27.link then nil else escapeRichText(v27.link.text)
	local v32, v33 = React.useState(false)
	local v34 = React.useCallback(function(p3) -- line: 60
		-- upvalues: v33 (copy), ControlState (copy)
		v33(p3 == ControlState.Hover)
	end, {})

	return React.createElement(View, withCommonProps(v27, {
		tag = v29.container.tag,
		stroke = v29.stroke,
		backgroundStyle = v29.backgroundStyle,
		ref = v30
	}), {
		HeaderRow = React.createElement(View, {
			LayoutOrder = 1,
			tag = v29.headerRow.tag,
			testId = `{ v27.testId }--header`
		}, {
			Icon = React.createElement(Icon, {
				LayoutOrder = 1,
				name = AlertConstants.SEVERITY_TO_ICON[v27.severity],
				size = IconSize.Large,
				variant = IconVariant.Filled,
				style = v29.icon.style,
				testId = `{ v27.testId }--icon`
			}),
			Content = React.createElement(View, {
				LayoutOrder = 2,
				tag = "row align-y-center fill gap-xsmall auto-y",
				testId = `{ v27.testId }--content`
			}, {
				Title = React.createElement(Text, {
					LayoutOrder = 1,
					Text = v27.title,
					tag = v29.title.tag,
					testId = `{ v27.testId }--title`
				}),
				Subtitle = if not v27.subtitle then nil else React.createElement(Text, {
					LayoutOrder = 2,
					Text = v27.subtitle,
					tag = v29.subtitle.tag,
					testId = `{ v27.testId }--subtitle`
				}),
				Separator = if not v27.link then nil else React.createElement(Text, {
					Text = "·",
					tag = "auto-xy text-body-medium content-default",
					LayoutOrder = 3,
					testId = `{ v27.testId }--separator`
				}),
				Link = if not v27.link then nil else React.createElement(Text, {
					RichText = true,
					LayoutOrder = 4,
					Text = if not v32 then v31 else `<u>{ v31 }</u>`,
					tag = v29.link.tag,
					stateLayer = {
						affordance = StateLayerAffordance.None
					},
					onStateChanged = v34,
					onActivated = v27.link.onActivated,
					testId = `{ v27.testId }--link`
				})
			}),
			Close = if v27.onClose == nil then nil else React.createElement(CloseAffordance, {
				LayoutOrder = 3,
				onActivated = v27.onClose,
				size = InputSize.XSmall,
				variant = CloseAffordanceVariant.Utility,
				testId = `{ v27.testId }--close`
			})
		}),
		Description = if not v27.description then nil else React.createElement(Text, {
			LayoutOrder = 2,
			Text = v27.description,
			tag = v29.description.tag,
			testId = `{ v27.testId }--description`
		}),
		Actions = React.createElement(AlertActions, {
			LayoutOrder = 3,
			actions = v27.actions,
			testId = `{ v27.testId }--actions`
		})
	})
end

return React.memo(React.forwardRef(FeedbackAlert))
