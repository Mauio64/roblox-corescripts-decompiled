local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local useStyle = require(AppChatParent.UIBlox).Core.Style.useStyle
local Responsive = require(AppChatParent.Responsive)
local configureTopBarWithNavigationOptions = require(AppChat.configureTopBarWithNavigationOptions)

local function wrapInOverlay(p1) -- line: 14
	-- upvalues: Responsive (copy), useStyle (copy), React (copy), configureTopBarWithNavigationOptions (copy)
	return function(p2) -- line: 15
		-- upvalues: Responsive (copy), useStyle (copy), React (copy), configureTopBarWithNavigationOptions (copy), p1 (copy)
		local v15 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
		local v16 = Responsive.useBreakpointYOrSmaller(Responsive.Keys.Small)
		local v17 = useStyle()

		return React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Image = "rbxasset://textures/ui/LuaChat/9-slice/modal.png",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, not v15 and -360 or -24, 1, not v16 and -72 or -24),
			ImageColor3 = v17.Theme.BackgroundUIDefault.Color,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(Vector2.new(5, 5), Vector2.new(6, 6))
		}, {
			sizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(1000, 800),
				MinSize = Vector2.new(0, 0)
			}),
			padding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 2.5),
				PaddingLeft = UDim.new(0, 2.5),
				PaddingRight = UDim.new(0, 2.5),
				PaddingTop = UDim.new(0, 2.5)
			}),
			layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			topBar = configureTopBarWithNavigationOptions(p2.navigation),
			overlayContent = React.createElement(p1, p2)
		})
	end
end

return function(p3) -- line: 54
	-- upvalues: RoactNavigation (copy), React (copy), Responsive (copy), useStyle (copy), configureTopBarWithNavigationOptions (copy)
	local v11 = RoactNavigation.createRobloxStackNavigator(p3)
	local v12 = React.PureComponent:extend("OverlayNavigatorConnector")

	v12.router = v11.router

	local function v13(p4) -- line: 15
		-- upvalues: Responsive (copy), useStyle (copy), React (copy), configureTopBarWithNavigationOptions (copy), v11 (copy)
		local v19 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
		local v20 = Responsive.useBreakpointYOrSmaller(Responsive.Keys.Small)
		local v21 = useStyle()

		return React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Image = "rbxasset://textures/ui/LuaChat/9-slice/modal.png",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, not v19 and -360 or -24, 1, not v20 and -72 or -24),
			ImageColor3 = v21.Theme.BackgroundUIDefault.Color,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(Vector2.new(5, 5), Vector2.new(6, 6))
		}, {
			sizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(1000, 800),
				MinSize = Vector2.new(0, 0)
			}),
			padding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 2.5),
				PaddingLeft = UDim.new(0, 2.5),
				PaddingRight = UDim.new(0, 2.5),
				PaddingTop = UDim.new(0, 2.5)
			}),
			layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			topBar = configureTopBarWithNavigationOptions(p4.navigation),
			overlayContent = React.createElement(v11, p4)
		})
	end

	function v12.render(p5) -- line: 61
		-- upvalues: React (copy), v13 (copy)
		return React.createElement(v13, p5.props)
	end

	return v12
end
