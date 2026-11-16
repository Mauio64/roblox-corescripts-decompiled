local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local BuilderIcons = require(parent.BuilderIcons)
local Icon = require(Foundation.Components.Icon)
local Image = require(Foundation.Components.Image)
local StatusIndicator = require(Foundation.Components.StatusIndicator)
require(Foundation.Enums.StatusIndicatorShape)
require(Foundation.Enums.StatusIndicatorVariant)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local uiblox = BuilderIcons.Migration.uiblox
local FillBehavior = require(Foundation.Enums.FillBehavior)
local Flags = require(Foundation.Utility.Flags)
require(Foundation.Enums.InputSize)
local getIconScale = require(Foundation.Utility.getIconScale)
local iconMigrationUtils = require(Foundation.Utility.iconMigrationUtils)
local isMigrated = iconMigrationUtils.isMigrated
local isBuilderOrMigratedIcon = iconMigrationUtils.isBuilderOrMigratedIcon

local Constants = require(Foundation.Constants)

local TabItemAccessory = require(script.Parent.TabItemAccessory)
local tabItemAccessory = TabItemAccessory.TabItemAccessory
local resolve = TabItemAccessory.resolve
local useTabItemVariants = require(script.Parent.useTabItemVariants)

local function TabItem(props, ref)
	local v = useTokens()
	local v2

	if props.isActive then
		v2 = v.Color.Content.Default
	else
		v2 = v.Color.Content.Emphasis
	end

	local v3 = props.fillBehavior == FillBehavior.Fill

	local v4 = useTabItemVariants(v, props.size, v3)

	local cursor = React.useMemo(function()
		return { radius = UDim.new(0, 0), offset = 0, borderWidth = v.Stroke.Thicker }
	end, { v })

	local v5 = React.useMemo(function()
		if props.icon == nil then
			return nil
		end

		if typeof(props.icon) == "string" then
			return { name = props.icon, variant = BuilderIcons.IconVariant.Regular }
		end

		return props.icon
	end, { props.icon })
	local resolved, accessory

	if Flags.FoundationTabsAccessory then
		resolved, accessory = resolve(props.leading, props.trailing, props.icon, props.indicator)
	end

	local icon = nil

	if v5 and not Flags.FoundationTabsAccessory then
		if isBuilderOrMigratedIcon(v5.name) then
			local createElement = React.createElement
			local name

			if isMigrated(v5.name) then
				name = uiblox[v5.name].name
			else
				name = v5.name
			end

			local variant

			if isMigrated(v5.name) then
				variant = uiblox[v5.name].variant
			else
				variant = v5.variant
			end

			icon = createElement(Icon, {
				name = name,
				variant = variant,
				size = v4.icon.size,
				style = v2
			})
		else
			local iconScale, scale = getIconScale(v5.name, v4.icon.size)

			if iconScale then
				icon = React.createElement(Image, {
					Image = v5.name,
					Size = UDim2.fromOffset(iconScale.X, iconScale.Y),
					imageStyle = v2,
					scale = scale
				})
			end
		end
	end

	local createElement = React.createElement
	local v6 = { tag = v4.container.tag, GroupTransparency = 0, testId = 0 }
	local groupTransparency

	if props.isDisabled then
		groupTransparency = Constants.DISABLED_TRANSPARENCY
	end

	v6.GroupTransparency = groupTransparency
	v6.testId = props.testId
	local v7 = {
		Interactive = React.createElement(View, {
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 1),
			onActivated = function()
				props.onActivated(props.id)
			end,
			selection = {
				Selectable = not props.isDisabled
			},
			cursor = cursor,
			isDisabled = props.isDisabled,
			ref = ref
		}),
		Content = 0
	}

	local createElement2 = React.createElement
	local v8 = { LayoutOrder = 2, tag = v4.content.tag, Size = v4.content.Size }

	if Flags.FoundationTabsAccessory or not props.icon then
		icon = nil
	end

	local leading

	if Flags.FoundationTabsAccessory and resolved then
		leading = React.createElement(tabItemAccessory, {
			accessory = resolved,
			contentStyle = v2,
			iconSize = v4.icon.size,
			LayoutOrder = 1,
			testId = `{props.testId}--leading`
		})
	end

	local v9 = {
		Icon = icon,
		Leading = leading,
		Text = React.createElement(Text, {
			Text = props.text,
			style = v2,
			tag = v4.text.tag,
			LayoutOrder = 2
		}),
		Indicator = 0,
		Trailing = 0
	}
	local indicator

	if not (Flags.FoundationTabsAccessory or not props.indicator) then
		local createElement3 = React.createElement
		local v10

		if props.indicator.value then
			v10 = {
				value = props.indicator.value,
				variant = props.indicator.variant,
				max = props.indicator.max,
				LayoutOrder = 3,
				testId = `{props.testId}--indicator`
			}
		else
			v10 = {
				variant = props.indicator.variant,
				shape = props.indicator.shape,
				LayoutOrder = 3,
				testId = `{props.testId}--indicator`
			}
		end

		indicator = createElement3(StatusIndicator, v10)
	end

	v9.Indicator = indicator
	local trailing

	if Flags.FoundationTabsAccessory and accessory then
		trailing = React.createElement(tabItemAccessory, {
			accessory = accessory,
			contentStyle = v2,
			iconSize = v4.icon.size,
			LayoutOrder = 3,
			testId = `{props.testId}--trailing`
		})
	end

	v9.Trailing = trailing
	v7.Content = createElement2(View, v8, v9)
	return createElement(View, v6, v7)
end

return React.memo(React.forwardRef(TabItem))
