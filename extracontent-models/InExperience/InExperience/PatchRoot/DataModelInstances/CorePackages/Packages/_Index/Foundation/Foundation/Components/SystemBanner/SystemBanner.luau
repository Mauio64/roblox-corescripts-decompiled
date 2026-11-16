local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

local AlertActions = require(Foundation.Components.AlertActions)
local AlertConstants = require(Foundation.Components.AlertActions.AlertConstants)
require(Foundation.Enums.AlertSeverity)
local AlertVariant = require(Foundation.Enums.AlertVariant)
local Breakpoint = require(Foundation.Enums.Breakpoint)
local BuilderIcons = require(parent.BuilderIcons)
require(Foundation.Enums.ButtonVariant)
local CloseAffordance = require(Foundation.Components.CloseAffordance)
local CloseAffordanceVariant = require(Foundation.Enums.CloseAffordanceVariant)
local Icon = require(Foundation.Components.Icon)
local IconSize = require(Foundation.Enums.IconSize)
local IconVariant = BuilderIcons.IconVariant
local InputSize = require(Foundation.Enums.InputSize)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useBreakpoint = require(Foundation.Providers.Responsive.Hooks.useBreakpoint)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local useSystemBannerVariants = require(script.Parent.useSystemBannerVariants)

local SEVERITY_TO_ICON = AlertConstants.SEVERITY_TO_ICON

local v = { variant = AlertVariant.Standard, testId = "--foundation-system-banner" }

local standards = {
	[AlertVariant.System] = AlertVariant.Standard,
	[AlertVariant.Feedback] = AlertVariant.Standard
}

local function SystemBanner(p, p2)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local v4 = useSystemBannerVariants(v3, standards[v2.variant] or v2.variant, v2.severity)

	local state, setState = React.useState(nil)
	local ref = ReactUtils.useComposedRef(p2, setState)

	local v5 = useBreakpoint(state) == Breakpoint.XSmall

	local actions = React.useMemo(function()
		return (React.createElement(AlertActions, {
			actions = v2.actions,
			testId = `{v2.testId}--actions`,
			LayoutOrder = 3,
			tag = {
				["row gap-small auto-xy"] = true,
				["align-x-left"] = v5,
				["align-x-right"] = not v5
			},
			padding = v5 and { top = UDim.new(0, v3.Gap.Small) } or nil
		}))
	end, { v2.actions, v2.testId, v5, v3.Gap.Small })

	local v6 = React.useMemo(function()
		return { colorNamespace = v4.container.colorNamespace }
	end, { v4.container.colorNamespace })

	local createElement = React.createElement

	local v7 = withCommonProps(v2, {
		tag = {
			[v4.container.tag] = true,
			["align-y-center"] = v2.title == "" or v2.description == nil,
			["align-y-top"] = v2.title ~= "" and v2.description ~= nil
		},
		ref = ref
	})

	local createElement2 = React.createElement
	local provider = PresentationContext.Provider

	local v8 = {
		Icon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = SEVERITY_TO_ICON[v2.severity],
			size = IconSize.Large,
			variant = IconVariant.Filled,
			style = v4.icon.style,
			testId = `{v2.testId}--icon`
		}),
		Content = 0,
		Actions = 0,
		Close = 0
	}

	local createElement3 = React.createElement
	local v9 = {
		LayoutOrder = 2,
		tag = {
			["fill auto-xy"] = true,
			col = v5,
			row = not v5
		},
		testId = `{v2.testId}--content`
	}

	local createElement4 = React.createElement
	local title

	if v2.title ~= "" then
		title = React.createElement(Text, {
			Text = v2.title,
			textStyle = v4.title.style,
			tag = v4.title.tag,
			LayoutOrder = 1,
			testId = `{v2.testId}--title`
		})
	end

	local description

	if v2.description then
		description = React.createElement(Text, {
			Text = v2.description,
			textStyle = v4.description.style,
			tag = v4.description.tag,
			LayoutOrder = 2,
			testId = `{v2.testId}--description`
		})
	end

	local actions2

	if v5 then
		actions2 = actions
	end

	v8.Content = createElement3(View, v9, {
		Text = createElement4(View, { LayoutOrder = 2, tag = "col auto-xy" }, {
			Title = title,
			Description = description,
			Actions = actions2
		})
	})

	if v5 then
		actions = nil
	end

	v8.Actions = actions
	local close

	if v2.onClose ~= nil then
		close = React.createElement(CloseAffordance, {
			onActivated = v2.onClose,
			size = InputSize.Small,
			variant = CloseAffordanceVariant.Utility,
			LayoutOrder = 4,
			testId = `{v2.testId}--close`
		})
	end

	v8.Close = close
	return createElement(View, v7, createElement2(provider, { value = v6 }, v8))
end

return React.memo(React.forwardRef(SystemBanner))
