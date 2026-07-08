local UserInputService = game:GetService("UserInputService")
local ParentParent = script.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent
local ParentParent2Parent = ParentParent2.Parent
local UIBloxConfig = require(ParentParent2.UIBloxConfig)
local React = require(ParentParent2Parent.React)
local ReactOtter = require(ParentParent2Parent.ReactOtter)
local Foundation = require(ParentParent2Parent.Foundation)
local ReactUtils = require(ParentParent2Parent.ReactUtils)
local useDelayedActionHandler = ReactUtils.useDelayedActionHandler
local useEventConnection = ReactUtils.useEventConnection
local Object = require(ParentParent2Parent.LuauPolyfill).Object
local useStyle = require(ParentParent2.Core.Style.useStyle)

require(script.Parent.Types)

local Shortcut = require(script.Parent.Shortcut)
local useInputType = require(ParentParent2.Utility.useInputType)
local Utilities = require(ParentParent.Utilities)

require(ParentParent2.Enums.InputType)

local t1 = {
	dampingRatio = 2,
	frequency = 3
}
local t2 = {
	spacingTop = 12,
	spacingTrailing = 30,
	spacingBottom = 12,
	spacingLeading = 18,
	itemsGap = 24,
	itemIconLabelGap = 6,
	actionTextSpacingLeading = 12,
	items = {}
}

local function ShortcutBar(t3: {[any]: any}) -- line: 71
	-- upvalues: Object (copy), t2 (copy), useStyle (copy), Foundation (copy), UIBloxConfig (copy), React (copy), useInputType (copy), ReactOtter (copy), useDelayedActionHandler (copy), t1 (copy), Utilities (copy), useEventConnection (copy), UserInputService (copy), Shortcut (copy)
	local v21 = Object.assign({}, t2, t3)
	local v22 = useStyle()
	local v23 = Foundation.Hooks.useTokens()
	local v24 = nil
	local v25 = nil
	local v26 = nil
	local v27 = nil
	local v28 = nil
	local v29 = nil
	local v30 = nil

	if UIBloxConfig.useTokenizedShortcutBar then
		v24 = t3.spacingTop or v23.Padding.Small
		v25 = t3.spacingTrailing or v23.Padding.XLarge
		v26 = t3.spacingBottom or v23.Padding.Small
		v27 = t3.spacingLeading or v23.Padding.Medium
		v28 = t3.itemsGap or v23.Gap.Large
		v29 = t3.itemIconLabelGap or v23.Gap.XSmall
		v30 = t3.actionTextSpacingLeading or v23.Padding.Small
	end

	local t4 = {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.5, 0)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v24 or v21.spacingTop),
			PaddingRight = UDim.new(0, v25 or v21.spacingTrailing),
			PaddingBottom = UDim.new(0, v26 or v21.spacingBottom),
			PaddingLeft = UDim.new(0, v27 or v21.spacingLeading)
		}),
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v28 or v21.itemsGap)
		})
	}
	local v32 = useInputType()
	local v33, v34 = ReactOtter.useAnimatedBinding(0)
	local v35 = useDelayedActionHandler(not v21.transitionDelaySeconds and 0 or v21.transitionDelaySeconds, 0.1, function() -- line: 114
		-- upvalues: v34 (copy), ReactOtter (copy), t1 (copy)
		v34(ReactOtter.spring(0, t1))
	end)

	local function onInputChanged() -- line: 119
		-- upvalues: v21 (copy), v34 (copy), ReactOtter (copy), t1 (copy), v35 (copy)
		if v21.transitionDelaySeconds then
			v34(ReactOtter.spring(1, t1))
			v35()
		end
	end

	local v37, v38 = React.useState(Utilities.filterItems(v21.items, v32))

	useEventConnection(UserInputService.InputChanged, onInputChanged)
	React.useEffect(function() -- line: 129
		-- upvalues: v38 (copy), Utilities (copy), v21 (copy), v32 (copy)
		v38(Utilities.filterItems(v21.items, v32))
	end, {
		v32,
		v21.items
	})

	for i, v in ipairs(v37) do
		t4["Item" .. tostring(i)] = React.createElement(Shortcut, {
			index = i,
			iconLabelGap = v29 or v21.itemIconLabelGap,
			actionTextSpacingLeading = v30 or v21.actionTextSpacingLeading,
			publicProps = v
		})
	end

	if #v37 > 0 then
		local Contrast = v22.Tokens.Semantic.Color.BackgroundUi.Contrast

		return React.createElement("CanvasGroup", {
			BackgroundTransparency = 1,
			Position = v21.position,
			AnchorPoint = v21.anchorPoint,
			GroupTransparency = not v21.transitionDelaySeconds and 0 or v33,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			ShortcutBarComponent = React.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(0, 0),
				BackgroundColor3 = Contrast.Color3,
				BackgroundTransparency = Contrast.Transparency,
				AutomaticSize = Enum.AutomaticSize.XY
			}, t4)
		})
	end

	return nil
end

return ShortcutBar
