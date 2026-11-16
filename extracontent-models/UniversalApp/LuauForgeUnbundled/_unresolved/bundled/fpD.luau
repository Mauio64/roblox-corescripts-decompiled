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

local module2 = require("@luauforge/bundled/edi")

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
		local v6 = {
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
		local v9 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local v10 = {
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
		local v11

		if isRecentCatalogSearchItem then
			v11 = Roact.createElement(imageSetLabel, {
				Size = UDim2.new(0, 24, 0, 24),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = images["icons/menu/recent"],
				ImageColor3 = props.Theme.IconDefault.Color,
				ImageTransparency = props.Theme.IconDefault.Transparency,
				LayoutOrder = 2
			})
		else
			v11 = Roact.createElement(module2, {
				Size = UDim2.new(0, 24, 0, 24),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = "LuaApp/icons/ic-search-new",
				ImageColor3 = props.Theme.IconDefault.Color,
				ImageTransparency = props.Theme.IconDefault.Transparency,
				LayoutOrder = 2
			})
		end

		v10.SearchIcon = v11

		local createElement3 = Roact.createElement
		local v13 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -112, 1, 0),
			LayoutOrder = 3
		}

		local v14 = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 5)
			}),
			TitleText = 0,
			CategoryText = 0
		}

		local createElement4 = Roact.createElement
		local v16 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0),
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

		local v17 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else props.Font.Body.Font
		v16.Font = v17

		v16.TextSize = props.Font.BaseSize * props.Font.Body.RelativeSize
		v16.TextColor3 = props.Theme.TextDefault.Color
		v16.TextTransparency = props.Theme.TextDefault.Transparency
		v16.TextXAlignment = Enum.TextXAlignment.Left
		v16.TextYAlignment = Enum.TextYAlignment.Top

		local v18 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
		v16.fitAxis = v18
		local v19 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
		v16.width = v19
		v14.TitleText = createElement4(v5, v16)

		local v20 = isRichItem

		if v20 then
			local createElement5 = Roact.createElement
			local v22 = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				Text = "Game",
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

			local v23 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodySmall.Font) else props.Font.CaptionBody.Font
			v22.Font = v23

			v22.TextSize = props.Font.BaseSize * props.Font.CaptionBody.RelativeSize
			v22.TextColor3 = props.Theme.TextMuted.Color
			v22.TextTransparency = props.Theme.TextMuted.Transparency
			v22.TextXAlignment = Enum.TextXAlignment.Left
			v22.TextYAlignment = Enum.TextYAlignment.Top

			local v24 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
			v22.fitAxis = v24
			local v25 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
			v22.width = v25
			v20 = createElement5(v5, v22)
		end

		v14.CategoryText = v20
		v10.Content = createElement3("Frame", v13, v14)

		v10.RichIcon = isRichItem and Roact.createElement("Frame", {
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
		return createElement(imageButton, v6, {
			Container = createElement2("Frame", v9, v10),
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
