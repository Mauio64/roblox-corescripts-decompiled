local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ecR")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local Foundation = require(CorePackages.Packages.Foundation)
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local v5

if foundationFontFaceMigration then
	local FitFrame = require(CorePackages.Packages.FitFrame)
	v5 = FitFrame.FitTextLabel
else
	v5 = require("@luauforge/bundled/fpE")
end

local module3 = require("@luauforge/bundled/edi")

game:DefineFastFlag("ListPickerIconNotNeeded", false)

local extended = module.PureComponent:extend("ListPickerItem")

function extended:init()
	self.state = { menuItemDown = false }

	function self.onMenuItemActive(p2, p3)
		self.props.onSelectItem(p2, p3)
	end

	function self.onMenuItemInputBegan(p2, p3)
		if
			(p3.UserInputType == Enum.UserInputType.Touch or p3.UserInputType == Enum.UserInputType.MouseButton1)
			and p3.UserInputState == Enum.UserInputState.Begin
		then
			self:onMenuItemDown()
		end
	end

	function self.onMenuItemInputEnd(p2, p3)
		self:onMenuItemUp()
	end
end

function extended:onMenuItemDown()
	if not self.state.menuItemDown then
		self:eventDisconnect()

		self.userInputServiceCon = UserInputService.InputEnded:Connect(function()
			self:onMenuItemUp()
		end)

		self:setState({ menuItemDown = true })
	end
end

function extended:onMenuItemUp(p2)
	if self.state.menuItemDown or self.state.menuItemActive ~= p2 then
		self:setState({ menuItemDown = false })
	end

	self:eventDisconnect()
end

function extended:eventDisconnect()
	if self.userInputServiceCon then
		self.userInputServiceCon:Disconnect()
		self.userInputServiceCon = nil
	end
end

function extended.render(data)
	local item = data.props.item

	local layoutOrder = data.props.layoutOrder
	local separatorEnabled = data.props.separatorEnabled

	local menuItemDown = data.state.menuItemDown
	local v6

	if game:GetFastFlag("ListPickerIconNotNeeded") then
		v6 = not (item.displayIcon == nil) and item.displayIcon ~= ""
	else
		v6 = true
	end

	return withStyle(function(props)
		local createElement = module.createElement
		local fitImageButton = FitChildren.FitImageButton
		local v7 = {
			AutoButtonColor = false,
			BackgroundColor3 = menuItemDown and props.Theme.BackgroundOnPress.Color or props.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = menuItemDown and props.Theme.BackgroundOnPress.Transparency or props.Theme.BackgroundUIDefault.Transparency,
			BorderSizePixel = 0,
			fitAxis = FitChildren.FitAxis.Height,
			ClipsDescendants = false,
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, 0, 0, 0),
			[module.Event.Activated] = item.onSelect,
			[module.Event.InputBegan] = data.onMenuItemInputBegan,
			[module.Event.InputEnded] = data.onMenuItemInputEnd
		}
		local v8 = {
			Layout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Icon = module.createElement("Frame", {
				Size = UDim2.new(0, v6 and 60 or 20, 0, 20),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1
			}, {
				Image = v6 and module.createElement(module3, {
					Size = UDim2.new(0, 20, 0, 20),
					Position = UDim2.new(0, 20, 0, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Image = item.displayIcon,
					ImageColor3 = props.Theme.IconDefault.Color,
					ImageTransparency = props.Theme.IconDefault.Transparency
				})
			}),
			Content = 0
		}

		local createElement2 = module.createElement
		local fitFrame = FitChildren.FitFrame
		local v9 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			fitAxis = FitChildren.FitAxis.Height,
			LayoutOrder = 2,
			Size = UDim2.new(1, v6 and -60 or 0, 0, 0)
		}
		local children = {
			Layout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			TopPadding = module.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 15)
			}),
			TextContent = 0,
			UIBottomPadding = 0,
			Separator = 0
		}

		local createElement3 = module.createElement
		local v11 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = UDim2.new(1, -20, 0, 0),
			Text = item.text,
			Font = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			TextWrapped = true,
			fitAxis = 0,
			width = 0
		}

		local v12 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else props.Font.Body.Font
		v11.Font = v12

		v11.TextSize = props.Font.BaseSize * props.Font.Body.RelativeSize
		v11.TextColor3 = props.Theme.TextDefault.Color
		v11.TextTransparency = props.Theme.TextDefault.Transparency
		v11.TextXAlignment = Enum.TextXAlignment.Left
		v11.TextYAlignment = Enum.TextYAlignment.Top

		local v13 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
		v11.fitAxis = v13
		local v14 = if foundationFontFaceMigration then UDim.new(1, -20) else nil
		v11.width = v14
		children.TextContent = createElement3(v5, v11)

		children.UIBottomPadding = module.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 15),
			LayoutOrder = 3
		})

		children.Separator = separatorEnabled and module.createElement("Frame", {
			BackgroundColor3 = props.Theme.Divider.Color,
			BackgroundTransparency = props.Theme.Divider.Transparency,
			BorderSizePixel = 0,
			LayoutOrder = 4,
			Size = UDim2.new(1, 0, 0, 1)
		})
		v8.Content = createElement2(fitFrame, v9, children)
		return createElement(fitImageButton, v7, v8)
	end)
end

function extended:willUnmount()
	self:eventDisconnect()
end

return extended
