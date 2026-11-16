local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)

local AlertConstants = require(Foundation.Components.AlertActions.AlertConstants)
local AlertSeverity = require(Foundation.Enums.AlertSeverity)
local AlertVariant = require(Foundation.Enums.AlertVariant)
local Breakpoint = require(Foundation.Enums.Breakpoint)
local BreakpointConfig = require(Foundation.Utility.Responsive.BreakpointConfig)
local ButtonGroup = require(Foundation.Components.ButtonGroup)
local ButtonVariant = require(Foundation.Enums.ButtonVariant)
local CloseAffordance = require(Foundation.Components.CloseAffordance)
local CloseAffordanceVariant = require(Foundation.Enums.CloseAffordanceVariant)
local Flags = require(Foundation.Utility.Flags)
local Icon = require(Foundation.Components.Icon)
local IconSize = require(Foundation.Enums.IconSize)
local InputSize = require(Foundation.Enums.InputSize)
local Link = require(Foundation.Components.Link)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local Text = require(Foundation.Components.Text)
local TextOverflow = require(Foundation.Enums.TextOverflow)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local escapeRichText = require(Foundation.Utility.escapeRichText)
local isBuilderIcon = require(Foundation.Utility.isBuilderIcon)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local useAlertVariants = require(script.Parent.useAlertVariants)

local IconVariant = BuilderIcons.IconVariant

local v = {
	variant = AlertVariant.Feedback,
	severity = AlertSeverity.Info,
	testId = "--foundation-alert"
}

local feedbacks = {
	[AlertVariant.Standard] = AlertVariant.Feedback,
	[AlertVariant.Emphasis] = AlertVariant.Feedback
}

local width = BreakpointConfig.widths[Breakpoint.XSmall]

local function getTrailingLabels(link, actions) -- 1 equivalent call inferred from this helper
	if link then
		return link.text
	end

	if actions then
		return `{actions.primary.text}|{not actions.secondary and "" or actions.secondary.text}`
	end

	return ""
end

local function WrappingRichText(props)
	local state, setState = React.useState(0)
	local alertWidth = props.alertWidth
	local onAbsoluteSizeChanged = React.useCallback(function(p)
		local x = p.AbsoluteSize.X

		if alertWidth <= 0 or x <= alertWidth then
			setState(x)
		end
	end, { alertWidth })

	local v2 = {
		[`Label-{math.floor(state)}`] = React.createElement(Text, {
			Text = props.text,
			RichText = true,
			tag = { ["size-full-0"] = true, [props.slot.tag] = true },
			padding = props.slot.padding,
			sizeConstraint = state > 0 and { MaxSize = Vector2.new(state, 1e999) } or nil,
			stateLayer = props.stateLayer,
			onActivated = props.onActivated,
			testId = props.testId
		})
	}

	return React.createElement(
		View,
		{
			tag = props.slot.tag,
			LayoutOrder = props.LayoutOrder,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged
		},
		v2
	)
end

local function Alert(p, ref2)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local v4 = feedbacks[v2.variant] or v2.variant

	local state, setState = React.useState(Vector2.zero)
	local onAbsoluteSizeChanged = React.useCallback(function(p2)
		setState(p2.AbsoluteSize)

		if v2.onAbsoluteSizeChanged then
			v2.onAbsoluteSizeChanged(p2)
		end
	end, { v2.onAbsoluteSizeChanged })

	local state2, setState2 = React.useState(0)
	local onAbsoluteSizeChanged2 = React.useCallback(function(p2)
		setState2(p2.AbsoluteSize.X)
	end, {})
	local trailingLabels = getTrailingLabels(v2.link, v2.actions) -- inferred equivalent call

	local ref = React.useRef(false)
	React.useEffect(function()
		if ref.current then
			setState2(0)
		end

		ref.current = true
	end, { trailingLabels })
	local v5

	if state.X > 0 then
		v5 = state.X <= width
	else
		v5 = false
	end

	local v6 = state.X * (Flags.FoundationAlertStackTrailingOnOverflow and 0.3 or 0.4)

	if Flags.FoundationAlertStackTrailingOnOverflow then
		if not v5 then
			if v6 > 0 then
				v5 = v6 < state2
			else
				v5 = false
			end
		end
	elseif not v5 then
		if v2.actions == nil or not (v6 > 0) then
			v5 = false
		else
			v5 = v6 < state2
		end
	end

	local v7 = useAlertVariants(v3, v2.severity, v4, v5)

	local buttons = React.useMemo(function()
		if not v2.actions then
			return nil
		end

		local v8 = {
			{
				text = v2.actions.primary.text,
				onActivated = v2.actions.primary.onActivated,
				variant = ButtonVariant.Standard
			}
		}

		if v2.actions.secondary then
			table.insert(v8, {
				text = v2.actions.secondary.text,
				onActivated = v2.actions.secondary.onActivated,
				variant = ButtonVariant.Utility
			})
		end

		return v8
	end, { v2.actions })

	local name = AlertConstants.SEVERITY_TO_ICON[v2.severity]
	local variant = IconVariant.Filled
	local iconBackplate = v7.iconBackplate
	local icon = v2.icon

	if icon ~= nil and v2.severity == AlertSeverity.Info then
		local v8 = if typeof(icon) == "string" then icon else icon.name

		if isBuilderIcon(v8) then
			if typeof(icon) == "table" and icon.variant then
				variant = icon.variant
			else
				variant = IconVariant.Filled
			end

			name = v8
			iconBackplate = nil
		end
	end

	local v8 = React.createElement(Icon, {
		name = name,
		size = IconSize.Medium,
		variant = variant,
		style = v7.icon.style,
		LayoutOrder = 2,
		ZIndex = 2,
		testId = `{v2.testId}--icon`
	})

	local createElement = React.createElement

	if iconBackplate then
		v8 = React.createElement(View, { Size = v7.iconFrame.Size, LayoutOrder = 1 }, {
			Backplate = React.createElement(View, {
				Size = iconBackplate.Size,
				Position = iconBackplate.Position,
				tag = iconBackplate.tag,
				backgroundStyle = iconBackplate.backgroundStyle,
				LayoutOrder = 1,
				ZIndex = 1,
				testId = `{v2.testId}--icon-backplate`
			}),
			Icon = v8
		})
	end

	local element = createElement(View, {
		tag = "align-y-center size-0-800 auto-x",
		LayoutOrder = 1
	}, { Content = v8 })
	local message

	if v2.richText then
		message = React.createElement(WrappingRichText, {
			slot = v7.message,
			text = v2.text,
			LayoutOrder = 2,
			testId = `{v2.testId}--message`,
			alertWidth = state.X
		})
	else
		message = React.createElement(Text, {
			Text = v2.text,
			tag = v7.message.tag,
			padding = v7.message.padding,
			LayoutOrder = 2,
			testId = `{v2.testId}--message`
		})
	end

	if v5 then
		onAbsoluteSizeChanged2 = nil
	end

	local trailing

	if v2.link and Flags.FoundationAlertUseLink then
		local createElement2 = React.createElement
		local v9 = {
			tag = v7.linkContainer.tag,
			padding = v7.link.padding,
			LayoutOrder = 3,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged2
		}

		local createElement3 = React.createElement
		local v10 = {
			text = v2.link.text,
			onActivated = v2.link.onActivated,
			hasUnderline = true,
			textOverflow = 0,
			testId = 0
		}
		local textOverflow

		if v5 then
			textOverflow = TextOverflow.Wrap
		else
			textOverflow = TextOverflow.None
		end

		v10.textOverflow = textOverflow
		v10.testId = `{v2.testId}--link`
		trailing = createElement2(View, v9, { Link = createElement3(Link, v10) })
	elseif v2.link then
		if v5 and Flags.FoundationAlertLinkWrap then
			trailing = React.createElement(WrappingRichText, {
				slot = v7.link,
				text = `<u>{escapeRichText(v2.link.text)}</u>`,
				LayoutOrder = 3,
				testId = `{v2.testId}--link`,
				alertWidth = state.X,
				onActivated = v2.link.onActivated,
				stateLayer = { affordance = StateLayerAffordance.None }
			})
		else
			local createElement2 = React.createElement
			local v9 = {
				Text = `<u>{escapeRichText(v2.link.text)}</u>`,
				RichText = true,
				tag = v7.link.tag,
				padding = v7.link.padding,
				sizeConstraint = 0,
				stateLayer = 0,
				onActivated = 0,
				LayoutOrder = 3,
				testId = 0,
				onAbsoluteSizeChanged = 0
			}
			local sizeConstraint

			if not Flags.FoundationAlertStackTrailingOnOverflow then
				sizeConstraint = not v5 and v6 > 0 and { MaxSize = Vector2.new(v6, 1e999) } or nil
			end

			v9.sizeConstraint = sizeConstraint

			v9.stateLayer = { affordance = StateLayerAffordance.None }
			v9.onActivated = v2.link.onActivated

			v9.testId = `{v2.testId}--link`
			v9.onAbsoluteSizeChanged = onAbsoluteSizeChanged2
			trailing = createElement2(Text, v9)
		end
	elseif buttons then
		trailing = React.createElement(ButtonGroup, {
			buttons = buttons,
			size = InputSize.Small,
			LayoutOrder = 3,
			testId = `{v2.testId}--actions`,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged2
		})
	end

	local close

	if v2.onClose then
		close = React.createElement(CloseAffordance, {
			onActivated = v2.onClose,
			size = InputSize.Small,
			variant = CloseAffordanceVariant.Utility,
			LayoutOrder = 4,
			testId = `{v2.testId}--close`
		})
	end

	local v9 = v5 and {
		Icon = element,
		Stack = React.createElement(View, {
			LayoutOrder = 2,
			tag = v7.stack.tag,
			testId = `{v2.testId}--stack`
		}, {
			Message = message,
			Trailing = trailing
		}),
		Close = close
	} or { Icon = element, Message = message, Trailing = trailing, Close = close }

	local v10 = withCommonProps(v2, {
		tag = v7.container.tag,
		backgroundStyle = v7.container.backgroundStyle,
		ref = ref2
	})

	v10.onAbsoluteSizeChanged = onAbsoluteSizeChanged

	local v11 = v4 == AlertVariant.System and {
		TopBorder = React.createElement(View, {
			Size = v7.border.Size,
			backgroundStyle = v7.border.backgroundStyle,
			LayoutOrder = 1,
			testId = `{v2.testId}--top-border`
		}),
		Main = React.createElement(View, { tag = v7.main.tag, LayoutOrder = 2 }, v9),
		BottomBorder = React.createElement(View, {
			Size = v7.border.Size,
			backgroundStyle = v7.border.backgroundStyle,
			LayoutOrder = 3,
			testId = `{v2.testId}--bottom-border`
		})
	} or v9

	return React.createElement(View, v10, v11)
end

return React.memo(React.forwardRef(Alert))
