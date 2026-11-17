local parent = script:FindFirstAncestor("GameFilters").Parent
require(parent.DiscoveryTypes)
local Foundation = require(parent.Foundation)
local RadioGroup = Foundation.RadioGroup
local View = Foundation.View
local Badge = Foundation.Badge
local Text = Foundation.Text
local React = require(parent.React)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppChartsFilterOptionTextTag = SharedFlags.FFlagLuaAppChartsFilterOptionTextTag

local useTokens = Foundation.Hooks.useTokens

return function(props)
	local v = useTokens()

	local xxLarge = v.Padding.XXLarge

	local v2 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v.Padding.Medium),
			PaddingBottom = UDim.new(0, v.Padding.Medium)
		}),
		SizeConstraint = 0,
		Layout = 0
	}
	local sizeConstraint

	if not FFlagLuaAppChartsFilterOptionTextTag then
		sizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = props.containerMaxWidthBinding:map(function(p: number)
				return Vector2.new(p - 3 * xxLarge, 1e999)
			end)
		})
	end

	v2.SizeConstraint = sizeConstraint
	local layout

	if FFlagLuaAppChartsFilterOptionTextTag then
		layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalFlex = Enum.UIFlexAlignment.Fill
		})
	end

	v2.Layout = layout

	for k, option in props.options do
		local v3

		if FFlagLuaAppChartsFilterOptionTextTag then
			if option.optionContextTag == nil then
				v3 = false
			else
				v3 = option.optionContextTag ~= ""
			end
		end

		local v4

		if FFlagLuaAppChartsFilterOptionTextTag then
			local createElement = React.createElement
			local item = RadioGroup.Item
			local children = { value = option.optionId, LayoutOrder = k, label = 0 }

			local createElement2 = React.createElement

			local createElement3 = React.createElement
			local v5 = {
				tag = {
					["auto-xy content-default gui-object-defaults size-0 text-color-defaults text-defaults text-size-defaults text-title-medium text-truncate-split text-align-x-left text-align-y-center shrink"] = true,
					["text-wrap"] = true
				},
				LayoutOrder = 1,
				Text = option.optionDisplayName,
				textStyle = 0
			}
			local textStyle

			if props.selectedOptionId == option.optionId then
				textStyle = v.Color.Content.Emphasis
			else
				textStyle = v.Color.Content.Default
			end

			v5.textStyle = textStyle
			local children2 = {
				OptionItem = createElement3(Text, v5, {
					SizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(v.Size.Size_3000 * 3, 1e999)
					})
				}),
				ContextTag = 0
			}
			local contextTag

			if v3 then
				contextTag = React.createElement(View, { tag = "auto-xy size-0", LayoutOrder = 2 }, {
					Badge = React.createElement(Badge, {
						variant = Foundation.Enums.BadgeVariant.Neutral,
						text = option.optionContextTag
					}),
					SizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(v.Size.Size_3000, 1e999)
					})
				}) or nil
			end

			children2.ContextTag = contextTag
			children.label = createElement2(
				View,
				{ tag = "size-0 auto-xy row gap-medium flex-between align-y-center fill" },
				children2
			)
			v4 = createElement(item, children)
		else
			v4 = React.createElement(RadioGroup.Item, {
				value = option.optionId,
				label = option.optionDisplayName
			})
		end

		table.insert(v2, v4)
	end

	if FFlagLuaAppChartsFilterOptionTextTag then
		return React.createElement(
			"Frame",
			{
				LayoutOrder = props.LayoutOrder,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = props.Size
			},
			{
				Padding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, xxLarge),
					PaddingRight = UDim.new(0, xxLarge)
				}),
				ScrollingFrame = React.createElement("ScrollingFrame", {
					AutomaticCanvasSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					CanvasSize = UDim2.fromScale(0, 0),
					ClipsDescendants = true,
					ElasticBehavior = Enum.ElasticBehavior.Always,
					ScrollBarThickness = 0,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					Selectable = false,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.fromScale(1, 1),
					[React.Change.AbsoluteCanvasSize] = props.onCanvasSizeChanged
				}, {
					RadioGroup = React.createElement(
						RadioGroup.Root,
						{
							value = props.selectedOptionId,
							onValueChanged = props.onSelectedOptionChanged
						},
						v2
					),
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalFlex = Enum.UIFlexAlignment.Fill
					})
				})
			}
		)
	end

	return React.createElement("ScrollingFrame", {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromScale(1, 0),
		ClipsDescendants = true,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		LayoutOrder = props.LayoutOrder,
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Selectable = false,
		Size = props.Size
	}, {
		MenuFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			[React.Change.AbsoluteSize] = function(p)
				props.onCanvasSizeChanged(p.AbsoluteSize)
			end
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, xxLarge),
				PaddingRight = UDim.new(0, xxLarge)
			}),
			RadioGroup = React.createElement(
				RadioGroup.Root,
				{ value = props.selectedOptionId, onValueChanged = props.onSelectedOptionChanged },
				v2
			)
		})
	})
end
