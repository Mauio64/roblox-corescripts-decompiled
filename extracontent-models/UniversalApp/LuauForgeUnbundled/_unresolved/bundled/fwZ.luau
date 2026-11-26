local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)

local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local loadableImage = UIBlox.App.Loading.LoadableImage
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FitFrame = require(CorePackages.Packages.FitFrame)
local fitTextLabel = FitFrame.FitTextLabel
local module = require("@luauforge/bundled/egF")

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local extended = Roact.PureComponent:extend("SearchBarListPickerItem")

extended.defaultProps = { displayIcon = nil }

function extended:init()
	self.state = { menuItemDown = false }

	function self.onMenuItemInputBegan(p2, p3)
		if
			(p3.UserInputType == Enum.UserInputType.Touch or p3.UserInputType == Enum.UserInputType.MouseButton1)
			and p3.UserInputState == Enum.UserInputState.Begin
		then
			self.onMenuItemDown()
		end
	end

	function self.onMenuItemInputEnd(p2, p3)
		self.onMenuItemUp()
	end

	function self.eventDisconnect()
		if self.userInputServiceConn then
			self.userInputServiceConn:Disconnect()
			self.userInputServiceConn = nil
		end
	end

	function self.onMenuItemDown()
		if not self.state.menuItemDown then
			self.eventDisconnect()
			self.userInputServiceConn = UserInputService.InputEnded:Connect(function()
				self.onMenuItemUp()
			end)
			self:setState({ menuItemDown = true })
		end
	end

	function self.onMenuItemUp(p2)
		if self.state.menuItemDown or self.state.menuItemActive ~= p2 then
			self:setState({ menuItemDown = false })
		end

		self.eventDisconnect()
	end
end

function extended:renderWithProviders(callback)
	local item = self.props.item
	local layoutOrder = self.props.layoutOrder
	local separatorEnabled = self.props.separatorEnabled
	local menuItemDown = self.state.menuItemDown

	local isRichItem = item.isRichItem

	local isRecentCatalogSearchItem = item.isRecentCatalogSearchItem

	local forwardRef = self.props.forwardRef

	return withStyle(function(props)
		local createElement = Roact.createElement
		local imageButton = focusable.ImageButton
		local v5 = {
			BackgroundColor3 = menuItemDown and props.Theme.BackgroundOnPress.Color or props.Theme.BackgroundDefault.Color,
			BackgroundTransparency = menuItemDown and props.Theme.BackgroundOnPress.Transparency or 1,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, 0, 0, isRichItem and 64 or 56),
			AutomaticSize = Enum.AutomaticSize.Y,
			[Roact.Event.Activated] = item.onSelect,
			[Roact.Event.InputBegan] = self.onMenuItemInputBegan,
			[Roact.Event.InputEnded] = self.onMenuItemInputEnd,
			NextSelectionLeft = self.props.NextSelectionLeft,
			NextSelectionRight = self.props.NextSelectionRight,
			NextSelectionUp = self.props.NextSelectionUp,
			NextSelectionDown = self.props.NextSelectionDown,
			[Roact.Ref] = forwardRef,
			SelectionImageObject = callback(cursorKind.RoundedRectNoInset)
		}

		local createElement2 = Roact.createElement
		local v8 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local v9 = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 9)
			}),
			LeftSpacing = Roact.createElement("Frame", {
				Size = UDim2.new(0, 0, 0, isRichItem and 64 or 56),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1
			}),
			SearchIcon = 0,
			Content = 0,
			RichIcon = 0
		}
		local v10

		if isRecentCatalogSearchItem then
			v10 = Roact.createElement(imageSetLabel, {
				Size = UDim2.new(0, 24, 0, 24),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = images["icons/menu/recent"],
				ImageColor3 = props.Theme.IconDefault.Color,
				ImageTransparency = props.Theme.IconDefault.Transparency,
				LayoutOrder = 2
			})
		else
			v10 = Roact.createElement(module, {
				Size = UDim2.new(0, 24, 0, 24),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = "LuaApp/icons/ic-search-new",
				ImageColor3 = props.Theme.IconDefault.Color,
				ImageTransparency = props.Theme.IconDefault.Transparency,
				LayoutOrder = 2
			})
		end

		v9.SearchIcon = v10

		v9.Content = Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -112, 1, 0),
				LayoutOrder = 3
			},
			{
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 5)
				}),
				TitleText = Roact.createElement(fitTextLabel, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 0),
					Text = item.text,
					Font = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
					TextSize = props.Font.BaseSize * props.Font.Body.RelativeSize,
					TextColor3 = props.Theme.TextDefault.Color,
					TextTransparency = props.Theme.TextDefault.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextWrapped = true,
					width = UDim.new(1, 0)
				}),
				CategoryText = isRichItem and Roact.createElement(fitTextLabel, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 0),
					Text = "Game",
					Font = normalizeFontFace(props.Tokens.Typography.BodySmall.Font),
					TextSize = props.Font.BaseSize * props.Font.CaptionBody.RelativeSize,
					TextColor3 = props.Theme.TextMuted.Color,
					TextTransparency = props.Theme.TextMuted.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextWrapped = true,
					width = UDim.new(1, 0)
				})
			}
		)

		v9.RichIcon = isRichItem and Roact.createElement("Frame", {
			Size = UDim2.new(0, 44, 0, 44),
			Position = UDim2.new(1, -44, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 4
		}, {
			Shadow = Roact.createElement("Frame", {
				Size = UDim2.new(0, 36, 0, 36),
				Position = UDim2.new(0, 8, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = props.Theme.BackgroundOnHover.Color,
				BackgroundTransparency = props.Theme.BackgroundOnHover.Transparency,
				ZIndex = 10
			}),
			Border = Roact.createElement("Frame", {
				Size = UDim2.new(0, 36, 0, 36),
				Position = UDim2.new(0, 2, 0, 6),
				BorderSizePixel = 0,
				BackgroundColor3 = props.Theme.BackgroundDefault.Color,
				BackgroundTransparency = props.Theme.BackgroundDefault.Transparency,
				ZIndex = 11
			}),
			GameIcon = Roact.createElement(loadableImage, {
				Size = UDim2.new(0, 36, 0, 36),
				Position = UDim2.new(0, 0, 0, 8),
				BackgroundTransparency = 1,
				Image = item.displayIcon,
				useShimmerAnimationWhileLoading = true,
				ZIndex = 12
			})
		})
		return createElement(imageButton, v5, {
			Container = createElement2("Frame", v8, v9),
			Separator = separatorEnabled and Roact.createElement("Frame", {
				BackgroundColor3 = props.Theme.Divider.Color,
				BackgroundTransparency = props.Theme.Divider.Transparency,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, 0)
			})
		})
	end)
end

function extended:render()
	return withSelectionCursorProvider(function(p2)
		return self:renderWithProviders(p2)
	end)
end

function extended.willUnmount(p2)
	p2.eventDisconnect()
end

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
