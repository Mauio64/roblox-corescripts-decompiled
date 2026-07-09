local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local FitChildren = require(Modules.LuaApp.FitChildren)
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
local LocalizedFitTextLabel = require(Modules.LuaApp.Components.LocalizedFitTextLabel)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle
local withTheme_DEPRECATED = require(Modules.LuaApp.withTheme_DEPRECATED)
local v12 = Roact.PureComponent:extend("ListCell")

v12.defaultProps = {
	textLocalization = false
}

function v12.init(p1) -- line: 23
	p1.state = {
		cellPressed = false
	}

	function p1.onInputBegan(_, p3) -- line: 28
		-- upvalues: p1 (copy)
		if (p3.UserInputType == Enum.UserInputType.Touch or p3.UserInputType == Enum.UserInputType.MouseButton1) and (p3.UserInputState == Enum.UserInputState.Begin and not p1.state.cellPressed) then
			p1:setState({
				cellPressed = true
			})
		end
	end
	function p1.onInputEnd() -- line: 43
		-- upvalues: p1 (copy)
		if p1.state.cellPressed then
			p1:setState({
				cellPressed = false
			})
		end
	end
	function p1.onActivated() -- line: 51
		-- upvalues: p1 (copy)
		p1.props.item.onActivated()
	end
end
function v12.render(p4) -- line: 59
	-- upvalues: withStyle (copy), Roact (copy), FitChildren (copy), ImageSetLabel (copy), DEPRECATED_ImageSetLabel (copy), LocalizedFitTextLabel (copy), FitTextLabel (copy)
	return withStyle(function(p5) -- line: 60
		-- upvalues: p4 (copy), Roact (copy), FitChildren (copy), ImageSetLabel (copy), DEPRECATED_ImageSetLabel (copy), LocalizedFitTextLabel (copy), FitTextLabel (copy)
		local item = p4.props.item
		local layoutOrder = p4.props.layoutOrder
		local cellPressed = p4.state.cellPressed
		local renderRightSideGadget = item.renderRightSideGadget
		local v22 = item.rightSideGadgetSize or Vector2.new(0, 0)
		local useUIBloxImage = item.useUIBloxImage
		local ContextualMenu = p4.props.appTheme.ContextualMenu
		local IconTransparency = ContextualMenu.Cells.Icon.Transparency

		if item.checked then
			IconTransparency = ContextualMenu.Cells.Icon.OnTransparency
		elseif item.disabled then
			cellPressed = false
			IconTransparency = ContextualMenu.Cells.Icon.DisabledTransparency
		end

		local BodyFont = p5.Font.Body.Font
		local v27 = p5.Font.BaseSize * p5.Font.Body.RelativeSize

		return Roact.createElement(FitChildren.FitImageButton, {
			BackgroundTransparency = cellPressed and ContextualMenu.Cells.Background.OnPressTransparency or 1,
			BackgroundColor3 = ContextualMenu.Cells.Background.OnPressColor,
			BorderSizePixel = 0,
			fitAxis = FitChildren.FitAxis.Height,
			ClipsDescendants = false,
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, 0, 0, 0),
			[Roact.Event.Activated] = p4.onActivated,
			[Roact.Event.InputBegan] = p4.onInputBegan,
			[Roact.Event.InputEnded] = p4.onInputEnd
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Icon = Roact.createElement(FitChildren.FitFrame, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				fitAxis = FitChildren.FitAxis.Height,
				Size = UDim2.new(0, 56, 0, 0)
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 10)
				}),
				Image = useUIBloxImage and Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Image = item.checked and item.displayIconChecked or item.displayIcon,
					ImageColor3 = item.checked and ContextualMenu.Cells.Icon.OnColor or ContextualMenu.Cells.Icon.Color,
					ImageTransparency = IconTransparency,
					Size = UDim2.new(0, 36, 0, 36)
				}) or Roact.createElement(DEPRECATED_ImageSetLabel, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Image = item.checked and item.displayIconChecked or item.displayIcon,
					ImageColor3 = item.checked and ContextualMenu.Cells.Icon.OnColor or ContextualMenu.Cells.Icon.Color,
					ImageTransparency = IconTransparency,
					Size = UDim2.new(0, 36, 0, 36)
				})
			}),
			Content = Roact.createElement(FitChildren.FitFrame, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				fitAxis = FitChildren.FitAxis.Height,
				Size = UDim2.new(1, -56 - v22.X, 0, 0)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				TopPadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 23)
				}),
				TextContent = Roact.createElement(item.textLocalization and LocalizedFitTextLabel or FitTextLabel, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					TextWrapped = true,
					Font = BodyFont,
					Size = UDim2.new(1, -10, 0, 0),
					Text = item.checked and item.textChecked or item.text,
					TextColor3 = ContextualMenu.Title.Color,
					TextTransparency = item.disabled and ContextualMenu.Title.DisabledTransparency or ContextualMenu.Title.Transparency,
					TextSize = v27,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					fitAxis = FitChildren.FitAxis.Height
				}),
				UIBottomPadding = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, 23)
				})
			}),
			RightSideGadget = renderRightSideGadget and Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 3,
				Size = UDim2.new(0, v22.X, 0, v22.Y)
			}, renderRightSideGadget())
		})
	end)
end

return (withTheme_DEPRECATED(v12))
