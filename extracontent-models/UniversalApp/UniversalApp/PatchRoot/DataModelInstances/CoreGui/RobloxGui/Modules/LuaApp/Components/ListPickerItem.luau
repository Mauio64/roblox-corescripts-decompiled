local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")
local Roact = require(Modules.Common.Roact)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local FitChildren = require(Modules.LuaApp.FitChildren)
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)

game:DefineFastFlag("ListPickerIconNotNeeded", false)

local v9 = Roact.PureComponent:extend("ListPickerItem")

function v9.init(p1) -- line: 24
	p1.state = {
		menuItemDown = false
	}

	function p1.onMenuItemActive(p2, p3) -- line: 29
		-- upvalues: p1 (copy)
		p1.props.onSelectItem(p2, p3)
	end
	function p1.onMenuItemInputBegan(_, p5) -- line: 33
		-- upvalues: p1 (copy)
		if (p5.UserInputType == Enum.UserInputType.Touch or p5.UserInputType == Enum.UserInputType.MouseButton1) and p5.UserInputState == Enum.UserInputState.Begin then
			p1:onMenuItemDown()
		end
	end
	function p1.onMenuItemInputEnd(_, _) -- line: 44
		-- upvalues: p1 (copy)
		p1:onMenuItemUp()
	end
end
function v9.onMenuItemDown(p8) -- line: 49
	-- upvalues: UserInputService (copy)
	if not p8.state.menuItemDown then
		p8:eventDisconnect()
		p8.userInputServiceCon = UserInputService.InputEnded:Connect(function() -- line: 53
			-- upvalues: p8 (copy)
			p8:onMenuItemUp()
		end)
		p8:setState({
			menuItemDown = true
		})
	end
end
function v9.onMenuItemUp(p9, p10) -- line: 63
	if p9.state.menuItemDown or p10 ~= p9.state.menuItemActive then
		p9:setState({
			menuItemDown = false
		})
	end

	p9:eventDisconnect()
end
function v9.eventDisconnect(p11) -- line: 73
	if p11.userInputServiceCon then
		p11.userInputServiceCon:Disconnect()
		p11.userInputServiceCon = nil
	end
end
function v9.render(p12) -- line: 82
	-- upvalues: withStyle (copy), Roact (copy), FitChildren (copy), DEPRECATED_ImageSetLabel (copy), FitTextLabel (copy)
	local item = p12.props.item
	local layoutOrder = p12.props.layoutOrder
	local separatorEnabled = p12.props.separatorEnabled
	local menuItemDown = p12.state.menuItemDown
	local u20 = true

	if game:GetFastFlag("ListPickerIconNotNeeded") then
		u20 = item.displayIcon ~= nil and item.displayIcon ~= ""
	end

	return withStyle(function(p13) -- line: 98
		-- upvalues: Roact (copy), FitChildren (copy), menuItemDown (copy), layoutOrder (copy), item (copy), p12 (copy), u20 (ref), DEPRECATED_ImageSetLabel (copy), FitTextLabel (copy), separatorEnabled (copy)
		return Roact.createElement(FitChildren.FitImageButton, {
			AutoButtonColor = false,
			BackgroundColor3 = menuItemDown and p13.Theme.BackgroundOnPress.Color or p13.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = menuItemDown and p13.Theme.BackgroundOnPress.Transparency or p13.Theme.BackgroundUIDefault.Transparency,
			BorderSizePixel = 0,
			fitAxis = FitChildren.FitAxis.Height,
			ClipsDescendants = false,
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, 0, 0, 0),
			[Roact.Event.Activated] = item.onSelect,
			[Roact.Event.InputBegan] = p12.onMenuItemInputBegan,
			[Roact.Event.InputEnded] = p12.onMenuItemInputEnd
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Icon = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Size = UDim2.new(0, not u20 and 20 or 60, 0, 20)
			}, {
				Image = u20 and Roact.createElement(DEPRECATED_ImageSetLabel, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 20, 0, 20),
					Position = UDim2.new(0, 20, 0, 0),
					Image = item.displayIcon,
					ImageColor3 = p13.Theme.IconDefault.Color,
					ImageTransparency = p13.Theme.IconDefault.Transparency
				})
			}),
			Content = Roact.createElement(FitChildren.FitFrame, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				fitAxis = FitChildren.FitAxis.Height,
				Size = UDim2.new(1, not u20 and 0 or -60, 0, 0)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				TopPadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 15)
				}),
				TextContent = Roact.createElement(FitTextLabel, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					TextWrapped = true,
					Size = UDim2.new(1, -20, 0, 0),
					Text = item.text,
					Font = p13.Font.Body.Font,
					TextSize = p13.Font.BaseSize * p13.Font.Body.RelativeSize,
					TextColor3 = p13.Theme.TextDefault.Color,
					TextTransparency = p13.Theme.TextDefault.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					fitAxis = FitChildren.FitAxis.Height
				}),
				UIBottomPadding = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, 15)
				}),
				Separator = separatorEnabled and Roact.createElement("Frame", {
					BorderSizePixel = 0,
					LayoutOrder = 4,
					BackgroundColor3 = p13.Theme.Divider.Color,
					BackgroundTransparency = p13.Theme.Divider.Transparency,
					Size = UDim2.new(1, 0, 0, 1)
				})
			})
		})
	end)
end
function v9.willUnmount(p14) -- line: 194
	p14:eventDisconnect()
end

return v9
