local Parent = script:FindFirstAncestor("GameFilters").Parent

require(Parent.DiscoveryTypes)

local Foundation = require(Parent.Foundation)
local RadioGroup = Foundation.RadioGroup
local View = Foundation.View
local Badge = Foundation.Badge
local FoundationText = Foundation.Text
local React = require(Parent.React)
local FFlagLuaAppChartsFilterOptionTextTag = require(Parent.SharedFlags).FFlagLuaAppChartsFilterOptionTextTag
local v9 = game:DefineFastFlag("LuaAppWrapChartsFilterOptionLabels", false)
local useTokens = Foundation.Hooks.useTokens

return function(t1: {[any]: any}) -- line: 28
	-- upvalues: useTokens (copy), React (copy), FFlagLuaAppChartsFilterOptionTextTag (copy), RadioGroup (copy), View (copy), FoundationText (copy), v9 (copy), Badge (copy), Foundation (copy)
	local v12 = useTokens()
	local XXLarge = v12.Padding.XXLarge
	local t2 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v12.Padding.Medium),
			PaddingBottom = UDim.new(0, v12.Padding.Medium)
		}),
		SizeConstraint = if not FFlagLuaAppChartsFilterOptionTextTag then React.createElement("UISizeConstraint", {
			MaxSize = t1.containerMaxWidthBinding:map(function(n1: number) -- line: 42
				-- upvalues: XXLarge (copy)
				return Vector2.new(n1 - 3 * XXLarge, 1e999)
			end)
		}) else nil,
		Layout = if not FFlagLuaAppChartsFilterOptionTextTag then nil else React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalFlex = Enum.UIFlexAlignment.Fill
		})
	}

	for v15, v16 in t1.options do
		local v17 = if not FFlagLuaAppChartsFilterOptionTextTag then nil else v16.optionContextTag ~= nil and v16.optionContextTag ~= ""

		table.insert(t2, if not FFlagLuaAppChartsFilterOptionTextTag then React.createElement(RadioGroup.Item, {
			value = v16.optionId,
			label = v16.optionDisplayName
		}) else React.createElement(RadioGroup.Item, {
			value = v16.optionId,
			LayoutOrder = v15,
			label = React.createElement(View, {
				tag = "size-0 auto-xy row gap-medium flex-between align-y-center fill"
			}, {
				OptionItem = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = {
						["auto-xy content-default gui-object-defaults size-0 text-color-defaults text-defaults text-size-defaults text-title-medium text-truncate-split text-align-x-left text-align-y-center shrink"] = true,
						["text-wrap"] = v9
					},
					Text = v16.optionDisplayName,
					textStyle = if t1.selectedOptionId ~= v16.optionId then v12.Color.Content.Default else v12.Color.Content.Emphasis
				}, {
					SizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(v12.Size.Size_3000 * 3, 1e999)
					})
				}),
				ContextTag = v17 and React.createElement(View, {
					tag = "auto-xy size-0",
					LayoutOrder = 2
				}, {
					Badge = React.createElement(Badge, {
						variant = Foundation.Enums.BadgeVariant.Neutral,
						text = v16.optionContextTag
					}),
					SizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(v12.Size.Size_3000, 1e999)
					})
				}) or nil
			})
		}))
	end

	if FFlagLuaAppChartsFilterOptionTextTag then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = t1.LayoutOrder,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = t1.Size
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, XXLarge),
				PaddingRight = UDim.new(0, XXLarge)
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
				[React.Change.AbsoluteCanvasSize] = t1.onCanvasSizeChanged
			}, {
				RadioGroup = React.createElement(RadioGroup.Root, {
					value = t1.selectedOptionId,
					onValueChanged = t1.onSelectedOptionChanged
				}, t2),
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalFlex = Enum.UIFlexAlignment.Fill
				})
			})
		})
	end

	return React.createElement("ScrollingFrame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ScrollBarThickness = 0,
		Selectable = false,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.fromScale(1, 0),
		ElasticBehavior = Enum.ElasticBehavior.Always,
		LayoutOrder = t1.LayoutOrder,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Size = t1.Size
	}, {
		MenuFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			[React.Change.AbsoluteSize] = function(p1) -- line: 163
				-- upvalues: t1 (copy)
				t1.onCanvasSizeChanged(p1.AbsoluteSize)
			end
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, XXLarge),
				PaddingRight = UDim.new(0, XXLarge)
			}),
			RadioGroup = React.createElement(RadioGroup.Root, {
				value = t1.selectedOptionId,
				onValueChanged = t1.onSelectedOptionChanged
			}, t2)
		})
	})
end
