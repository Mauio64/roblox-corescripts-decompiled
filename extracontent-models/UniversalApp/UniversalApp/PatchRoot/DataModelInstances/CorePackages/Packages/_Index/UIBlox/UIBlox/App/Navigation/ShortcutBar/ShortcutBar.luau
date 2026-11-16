local UserInputService = game:GetService("UserInputService")

local parent = script.Parent.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent
local UIBloxConfig = require(parent2.UIBloxConfig)

local React = require(parent3.React)
local ReactOtter = require(parent3.ReactOtter)
local Foundation = require(parent3.Foundation)

local ReactUtils = require(parent3.ReactUtils)
local useDelayedActionHandler = ReactUtils.useDelayedActionHandler
local useEventConnection = ReactUtils.useEventConnection

local LuauPolyfill = require(parent3.LuauPolyfill)
local Object = LuauPolyfill.Object
local useStyle = require(parent2.Core.Style.useStyle)

require(script.Parent.Types)
local Shortcut = require(script.Parent.Shortcut)

local useInputType = require(parent2.Utility.useInputType)
local Utilities = require(parent.Utilities)
require(parent2.Enums.InputType)

local v = { dampingRatio = 2, frequency = 3 }

local v2 = {
	items = {},
	spacingTop = 12,
	spacingTrailing = 30,
	spacingBottom = 12,
	spacingLeading = 18,
	itemsGap = 24,
	itemIconLabelGap = 6,
	actionTextSpacingLeading = 12
}

local function ShortcutBar(props)
	local v3 = Object.assign({}, v2, props)
	local v4 = useStyle()

	local v5 = Foundation.Hooks.useTokens()
	local spacingTop, spacingTrailing, spacingBottom, spacingLeading, itemsGap, itemIconLabelGap, actionTextSpacingLeading

	if UIBloxConfig.useTokenizedShortcutBar then
		spacingTop = props.spacingTop or v5.Padding.Small
		spacingTrailing = props.spacingTrailing or v5.Padding.XLarge
		spacingBottom = props.spacingBottom or v5.Padding.Small
		spacingLeading = props.spacingLeading or v5.Padding.Medium
		itemsGap = props.itemsGap or v5.Gap.Large
		itemIconLabelGap = props.itemIconLabelGap or v5.Gap.XSmall
		actionTextSpacingLeading = props.actionTextSpacingLeading or v5.Padding.Small
	end

	local children = {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) }),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, spacingTop or v3.spacingTop),
			PaddingRight = UDim.new(0, spacingTrailing or v3.spacingTrailing),
			PaddingBottom = UDim.new(0, spacingBottom or v3.spacingBottom),
			PaddingLeft = UDim.new(0, spacingLeading or v3.spacingLeading)
		}),
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, itemsGap or v3.itemsGap)
		})
	}

	local v6 = useInputType()

	local v7, v8 = ReactOtter.useAnimatedBinding(0)

	local v9 = useDelayedActionHandler(not v3.transitionDelaySeconds and 0 or v3.transitionDelaySeconds, 0.1, function()
		v8(ReactOtter.spring(0, v))
	end)

	local function onInputChanged()
		if v3.transitionDelaySeconds then
			v8(ReactOtter.spring(1, v))
			v9()
		end
	end

	local state, setState = React.useState(Utilities.filterItems(v3.items, v6))

	useEventConnection(UserInputService.InputChanged, onInputChanged)
	React.useEffect(function()
		setState(Utilities.filterItems(v3.items, v6))
	end, { v6, v3.items })

	for i, publicProps in ipairs(state) do
		children["Item" .. tostring(i)] = React.createElement(Shortcut, {
			index = i,
			iconLabelGap = itemIconLabelGap or v3.itemIconLabelGap,
			actionTextSpacingLeading = actionTextSpacingLeading or v3.actionTextSpacingLeading,
			publicProps = publicProps
		})
	end

	if #state > 0 then
		local overMedia_0 = v4.Tokens.Color.OverMedia.OverMedia_0
		return React.createElement("CanvasGroup", {
			Position = v3.position,
			AnchorPoint = v3.anchorPoint,
			BackgroundTransparency = 1,
			GroupTransparency = not v3.transitionDelaySeconds and 0 or v7,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			ShortcutBarComponent = React.createElement("Frame", {
				Size = UDim2.fromOffset(0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = overMedia_0.Color3,
				BackgroundTransparency = overMedia_0.Transparency,
				AutomaticSize = Enum.AutomaticSize.XY
			}, children)
		})
	end

	return nil
end

return ShortcutBar
