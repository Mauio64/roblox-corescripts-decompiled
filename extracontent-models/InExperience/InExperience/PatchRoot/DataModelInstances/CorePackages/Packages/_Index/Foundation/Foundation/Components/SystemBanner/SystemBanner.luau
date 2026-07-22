local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactUtils = require(FoundationParent.ReactUtils)
local AlertActions = require(Foundation.Components.AlertActions)
local AlertConstants = require(Foundation.Components.AlertActions.AlertConstants)

require(Foundation.Enums.AlertSeverity)

local AlertVariant = require(Foundation.Enums.AlertVariant)
local Breakpoint = require(Foundation.Enums.Breakpoint)
local BuilderIcons = require(FoundationParent.BuilderIcons)

require(Foundation.Enums.ButtonVariant)

local CloseAffordance = require(Foundation.Components.CloseAffordance)
local CloseAffordanceVariant = require(Foundation.Enums.CloseAffordanceVariant)
local Flags = require(Foundation.Utility.Flags)
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
local t1 = {
	testId = "--foundation-system-banner",
	variant = AlertVariant.Standard
}

local function SystemBanner(p1, p2) -- line: 57
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useSystemBannerVariants (copy), React (copy), ReactUtils (copy), useBreakpoint (copy), Flags (copy), Breakpoint (copy), AlertActions (copy), View (copy), withCommonProps (copy), PresentationContext (copy), Icon (copy), SEVERITY_TO_ICON (copy), IconSize (copy), IconVariant (copy), Text (copy), CloseAffordance (copy), InputSize (copy), CloseAffordanceVariant (copy)
	local v30 = withDefaults(p1, t1)
	local v31 = useTokens()
	local v32 = useSystemBannerVariants(v31, v30.variant, v30.severity)
	local v33, v34 = React.useState(nil)
	local v35 = ReactUtils.useComposedRef(p2, v34)
	local v36 = useBreakpoint(v33)
	local v37 = if not Flags.FoundationSystemBannerWrapActionsOnXSmall then v36 == Breakpoint.XSmall or v36 == Breakpoint.Small else v36 == Breakpoint.XSmall
	local v38 = React.useMemo(function() -- line: 71
		-- upvalues: React (copy), AlertActions (copy), v30 (copy), v37 (copy), v31 (copy)
		return (React.createElement(AlertActions, {
			LayoutOrder = 3,
			actions = v30.actions,
			testId = `{ v30.testId }--actions`,
			tag = {
				["row gap-small auto-xy"] = true,
				["align-x-left"] = v37,
				["align-x-right"] = not v37
			},
			padding = if not v37 then nil else {
				top = UDim.new(0, v31.Gap.Small)
			}
		}))
	end, {
		v30.actions,
		v30.testId,
		v37,
		v31.Gap.Small
	})

	return React.createElement(View, withCommonProps(v30, {
		tag = {
			[v32.container.tag] = true,
			["align-y-center"] = v30.title == "" or v30.description == nil,
			["align-y-top"] = v30.title ~= "" and v30.description ~= nil
		},
		ref = v35
	}), React.createElement(PresentationContext.Provider, {
		value = {
			colorMode = v32.container.colorMode
		}
	}, {
		Icon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = SEVERITY_TO_ICON[v30.severity],
			size = IconSize.Large,
			variant = IconVariant.Filled,
			style = v32.icon.style,
			testId = `{ v30.testId }--icon`
		}),
		Content = React.createElement(View, {
			LayoutOrder = 2,
			tag = {
				["fill auto-xy"] = true,
				col = v37,
				row = not v37
			},
			testId = `{ v30.testId }--content`
		}, {
			Text = React.createElement(View, {
				LayoutOrder = 2,
				tag = "col auto-xy"
			}, {
				Title = if v30.title == "" then nil else React.createElement(Text, {
					LayoutOrder = 1,
					Text = v30.title,
					textStyle = v32.title.style,
					tag = v32.title.tag,
					testId = `{ v30.testId }--title`
				}),
				Description = if not v30.description then nil else React.createElement(Text, {
					LayoutOrder = 2,
					Text = v30.description,
					textStyle = v32.description.style,
					tag = v32.description.tag,
					testId = `{ v30.testId }--description`
				}),
				Actions = if not v37 then nil else v38
			})
		}),
		Actions = if v37 then nil else v38,
		Close = if v30.onClose == nil then nil else React.createElement(CloseAffordance, {
			LayoutOrder = 4,
			onActivated = v30.onClose,
			size = InputSize.Small,
			variant = CloseAffordanceVariant.Utility,
			testId = `{ v30.testId }--close`
		})
	}))
end

return React.memo(React.forwardRef(SystemBanner))
