local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)

local AvatarIcon = require(Foundation.Components.AvatarIcon)
local AvatarIconSize = require(Foundation.Enums.AvatarIconSize)
local Icon = require(Foundation.Components.Icon)
local IconSize = require(Foundation.Enums.IconSize)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local StatusIndicator = require(Foundation.Components.StatusIndicator)
local StatusIndicatorSize = require(Foundation.Enums.StatusIndicatorSize)
local StatusIndicatorVariant = require(Foundation.Enums.StatusIndicatorVariant)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function NavigationBarTab(props, ref)
	local v = useTokens()
	local item = props.item

	local icon = nil

	if typeof(item.icon) == "table" and item.icon.type == "Avatar" then
		icon = React.createElement(View, {
			tag = {
				["auto-xy radius-circle"] = true,
				["stroke-thick stroke-system-contrast"] = props.isActive,
				["stroke-standard stroke-emphasis"] = not props.isActive
			},
			testId = `{props.testId}--avatar-ring`
		}, {
			Avatar = React.createElement(AvatarIcon, {
				userId = item.icon.userId,
				size = AvatarIconSize.Large,
				testId = `{props.testId}--avatar`
			})
		})
	elseif typeof(item.icon) == "string" then
		local createElement = React.createElement
		local v2 = {
			name = item.icon,
			variant = 0,
			size = 0,
			style = 0,
			testId = 0
		}
		local variant

		if props.isActive then
			variant = BuilderIcons.IconVariant.Filled
		else
			variant = BuilderIcons.IconVariant.Regular
		end

		v2.variant = variant
		v2.size = IconSize.Large
		v2.style = v.Color.Content.Emphasis
		v2.testId = `{props.testId}--icon`
		icon = createElement(Icon, v2)
	end

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.LayoutOrder,
		tag = "fill auto-y",
		onActivated = function()
			props.onActivated(item.id)
		end,
		stateLayer = { affordance = StateLayerAffordance.None },
		ref = ref,
		testId = props.testId
	}

	local createElement2 = React.createElement
	local v3 = {
		tag = "col align-x-center gap-xxsmall size-full-0 auto-y",
		padding = {
			top = UDim.new(0, v.Padding.XXSmall + v.Padding.Small),
			bottom = UDim.new(0, v.Padding.XXSmall + v.Padding.Small)
		},
		testId = `{props.testId}--content`
	}

	local createElement3 = React.createElement
	local status

	if item.indicator then
		local createElement4 = React.createElement
		local v4

		if item.indicator.value == nil then
			v4 = {
				variant = StatusIndicatorVariant.Emphasis,
				size = StatusIndicatorSize.Small,
				mask = v.Color.Common.NavigationBar,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(1, -v.Size.Size_50, 0, v.Size.Size_50),
				ZIndex = 2,
				testId = `{props.testId}--status`
			}
		else
			v4 = {
				value = item.indicator.value,
				max = item.indicator.max or 99,
				variant = StatusIndicatorVariant.Emphasis,
				size = StatusIndicatorSize.Small,
				mask = v.Color.Common.NavigationBar,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(1, -v.Size.Size_150, 0, v.Size.Size_50),
				ZIndex = 2,
				testId = `{props.testId}--status`
			}
		end

		status = createElement4(StatusIndicator, v4)
	end

	return createElement(View, v2, {
		Content = createElement2(View, v3, {
			Media = createElement3(View, { LayoutOrder = 1, tag = "size-600" }, {
				Icon = icon,
				Status = status
			}),
			Label = React.createElement(Text, {
				LayoutOrder = 2,
				Text = item.text,
				tag = "size-full-0 auto-y text-caption-small text-align-x-center text-truncate-end content-emphasis",
				testId = `{props.testId}--label`
			})
		})
	})
end

return React.memo(React.forwardRef(NavigationBarTab))
