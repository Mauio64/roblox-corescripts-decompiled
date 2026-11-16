local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

local AlertActions = require(Foundation.Components.AlertActions)
local AlertConstants = require(Foundation.Components.AlertActions.AlertConstants)
require(Foundation.Enums.AlertSeverity)
local BuilderIcons = require(parent.BuilderIcons)
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

local v = { testId = "--foundation-feedback-alert" }

local function FeedbackAlert(p, p2)
	local v2 = withDefaults(p, v)
	local v3 = useFeedbackAlertVariants(useTokens(), v2.severity)

	local ref = ReactUtils.useComposedRef(p2)
	local text

	if v2.link then
		text = escapeRichText(v2.link.text)
	end

	local state, setState = React.useState(false)
	local onStateChanged = React.useCallback(function(p3)
		setState(p3 == ControlState.Hover)
	end, {})

	local createElement = React.createElement

	local v4 = withCommonProps(v2, {
		tag = v3.container.tag,
		stroke = v3.stroke,
		backgroundStyle = v3.backgroundStyle,
		ref = ref
	})

	local createElement2 = React.createElement
	local v5 = { LayoutOrder = 1, tag = v3.headerRow.tag, testId = `{v2.testId}--header` }
	local v6 = {
		Icon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = AlertConstants.SEVERITY_TO_ICON[v2.severity],
			size = IconSize.Large,
			variant = IconVariant.Filled,
			style = v3.icon.style,
			testId = `{v2.testId}--icon`
		}),
		Content = 0,
		Close = 0
	}

	local createElement3 = React.createElement
	local v7 = {
		LayoutOrder = 2,
		tag = "row align-y-center fill gap-xsmall auto-y",
		testId = `{v2.testId}--content`
	}
	local v8 = {
		Title = React.createElement(Text, {
			Text = v2.title,
			tag = v3.title.tag,
			LayoutOrder = 1,
			testId = `{v2.testId}--title`
		}),
		Subtitle = 0,
		Separator = 0,
		Link = 0
	}
	local subtitle

	if v2.subtitle then
		subtitle = React.createElement(Text, {
			Text = v2.subtitle,
			tag = v3.subtitle.tag,
			LayoutOrder = 2,
			testId = `{v2.testId}--subtitle`
		})
	end

	v8.Subtitle = subtitle
	local separator

	if v2.link then
		separator = React.createElement(Text, {
			Text = "·",
			tag = "auto-xy text-body-medium content-default",
			LayoutOrder = 3,
			testId = `{v2.testId}--separator`
		})
	end

	v8.Separator = separator
	local link

	if v2.link then
		local createElement4 = React.createElement

		if state then
			text = `<u>{text}</u>`
		end

		link = createElement4(Text, {
			Text = text,
			RichText = true,
			tag = v3.link.tag,
			LayoutOrder = 4,
			stateLayer = { affordance = StateLayerAffordance.None },
			onStateChanged = onStateChanged,
			onActivated = v2.link.onActivated,
			testId = `{v2.testId}--link`
		})
	end

	v8.Link = link
	v6.Content = createElement3(View, v7, v8)
	local close

	if v2.onClose ~= nil then
		close = React.createElement(CloseAffordance, {
			onActivated = v2.onClose,
			size = InputSize.XSmall,
			variant = CloseAffordanceVariant.Utility,
			LayoutOrder = 3,
			testId = `{v2.testId}--close`
		})
	end

	v6.Close = close
	local children = { HeaderRow = createElement2(View, v5, v6), Description = 0, Actions = 0 }
	local description

	if v2.description then
		description = React.createElement(Text, {
			Text = v2.description,
			tag = v3.description.tag,
			LayoutOrder = 2,
			testId = `{v2.testId}--description`
		})
	end

	children.Description = description

	children.Actions = React.createElement(AlertActions, {
		actions = v2.actions,
		testId = `{v2.testId}--actions`,
		LayoutOrder = 3
	})
	return createElement(View, v4, children)
end

return React.memo(React.forwardRef(FeedbackAlert))
