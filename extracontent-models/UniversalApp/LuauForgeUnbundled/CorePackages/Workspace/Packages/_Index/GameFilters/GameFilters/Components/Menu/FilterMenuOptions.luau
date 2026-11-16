require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/DiscoveryTypes")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Foundation")
local radioGroup = Foundation.RadioGroup
local view = Foundation.View
local badge = Foundation.Badge
local text = Foundation.Text
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/React")

local fFlagLuaAppChartsFilterOptionTextTag = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/SharedFlags").FFlagLuaAppChartsFilterOptionTextTag
local defineFastFlag = game:DefineFastFlag("LuaAppWrapChartsFilterOptionLabels", false)

local useTokens = Foundation.Hooks.useTokens

return function(props)
	local v5 = useTokens()

	local xxLarge = v5.Padding.XXLarge

	local v6 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v5.Padding.Medium),
			PaddingBottom = UDim.new(0, v5.Padding.Medium)
		}),
		SizeConstraint = 0,
		Layout = 0
	}
	local v7

	if not fFlagLuaAppChartsFilterOptionTextTag then
		v7 = React.createElement("UISizeConstraint", {
			MaxSize = props.containerMaxWidthBinding:map(function(p2)
				return Vector2.new(p2 - 3 * xxLarge, 1e999)
			end)
		})
	end

	v6.SizeConstraint = v7

	local v8 = if fFlagLuaAppChartsFilterOptionTextTag then React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalFlex = Enum.UIFlexAlignment.Fill
	}) else nil
	v6.Layout = v8

	for k, option in props.options do
		local v9

		if fFlagLuaAppChartsFilterOptionTextTag then
			v9 = not (option.optionContextTag == nil) and option.optionContextTag ~= ""
		end

		local v10

		if fFlagLuaAppChartsFilterOptionTextTag then
			local createElement = React.createElement
			local item = radioGroup.Item
			local children = { value = option.optionId, LayoutOrder = k, label = 0 }

			local createElement2 = React.createElement

			local createElement3 = React.createElement
			local v14 = {
				tag = {
					["auto-xy content-default gui-object-defaults size-0 text-color-defaults text-defaults text-size-defaults text-title-medium text-truncate-split text-align-x-left text-align-y-center shrink"] = true,
					["text-wrap"] = defineFastFlag
				},
				LayoutOrder = 1,
				Text = option.optionDisplayName,
				textStyle = 0
			}
			local v15 = if props.selectedOptionId == option.optionId then v5.Color.Content.Emphasis else v5.Color.Content.Default
			v14.textStyle = v15
			local children2 = {
				OptionItem = createElement3(text, v14, {
					SizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(v5.Size.Size_3000 * 3, 1e999)
					})
				}),
				ContextTag = 0
			}

			local v16 = if v9 then React.createElement(
				view,
				{ tag = "auto-xy size-0", LayoutOrder = 2 },
				{
					Badge = React.createElement(badge, {
						variant = Foundation.Enums.BadgeVariant.Neutral,
						text = option.optionContextTag
					}),
					SizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(v5.Size.Size_3000, 1e999)
					})
				}
			) or nil else nil
			children2.ContextTag = v16
			children.label = createElement2(
				view,
				{
					tag = "size-0 auto-xy row gap-medium flex-between align-y-center fill"
				},
				children2
			)
			v10 = createElement(item, children)
		else
			v10 = React.createElement(radioGroup.Item, {
				value = option.optionId,
				label = option.optionDisplayName
			})
		end

		table.insert(v6, v10)
	end

	if fFlagLuaAppChartsFilterOptionTextTag then
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
						radioGroup.Root,
						{
							value = props.selectedOptionId,
							onValueChanged = props.onSelectedOptionChanged
						},
						v6
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
			[React.Change.AbsoluteSize] = function(p2)
				props.onCanvasSizeChanged(p2.AbsoluteSize)
			end
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, xxLarge),
				PaddingRight = UDim.new(0, xxLarge)
			}),
			RadioGroup = React.createElement(
				radioGroup.Root,
				{
					value = props.selectedOptionId,
					onValueChanged = props.onSelectedOptionChanged
				},
				v6
			)
		})
	})
end
