local CorePackages = game:GetService("CorePackages")

local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton

local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)

local fitTextLabel = AvatarExperienceDeps.RoactFitComponents.FitTextLabel

local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local images = UIBlox.App.ImageSet.Images

local interactable = UIBlox.Core.Control.Interactable
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXActionButtonRoundedRectCursor = AvatarExperienceFlags.FFlagAXActionButtonRoundedRectCursor
local fFlagAXGifting = AvatarExperienceFlags.FFlagAXGifting

local module2 = require("@luauforge/bundled/dME")

local component_assetscircle_17 = images["component_assets/circle_17"]

local extended = Roact.PureComponent:extend("ActionButton")

local strictInterface = t.strictInterface
local v5 = {
	NextSelectionLeft = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	Size = t.UDim2,
	Position = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.number),
	AnchorPoint = t.optional(t.Vector2),
	buttonProps = t.table,
	Font = t.table,
	fillWidth = 0,
	forwardRef = 0
}
local v6 = if fFlagAXGifting then t.optional(t.boolean) else nil
v5.fillWidth = v6

v5.forwardRef = t.optional(t.table)
extended.validateProps = strictInterface(v5)

function extended:init()
	self.state = { isButtonPressed = false }

	function self.onInputBegan()
		self:setState({ isButtonPressed = true })
	end

	function self.onInputEnded()
		self:setState({ isButtonPressed = false })
	end
end

function extended:renderWithStyle(p2, callback)
	local size = self.props.Size
	local position = self.props.Position
	local anchorPoint = self.props.AnchorPoint
	local layoutOrder = self.props.LayoutOrder
	local font = self.props.Font
	local buttonProps = self.props.buttonProps
	local isButtonPressed = self.state.isButtonPressed

	local theme = p2.Theme

	local v7 = 0

	if buttonProps.buttonIsDisabled then
		v7 = module2.ActionBar.DisabledButtonTransparency
	elseif isButtonPressed then
		v7 = theme.Overlay.Transparency
	end

	local v8

	if buttonProps.buttonIsLoading then
		v8 = Roact.createElement(skeleton, {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			radius = radius.Medium
		})
	else
		v8 = Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1
			},
			{
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, buttonProps.buttonIconPadding)
				}),
				Icon = buttonProps.buttonIcon and Roact.createElement(imageSetLabel, {
					Size = UDim2.new(0, buttonProps.buttonIconSize, 0, buttonProps.buttonIconSize),
					BackgroundTransparency = 1,
					Image = buttonProps.buttonIcon,
					ImageTransparency = v7,
					ImageColor3 = buttonProps.buttonTextColor,
					LayoutOrder = 1
				}),
				Text = Roact.createElement(fitTextLabel, {
					width = fitTextLabel.Width.FitToText,
					Size = UDim2.new(0, 0, 0, font.BaseSize * font.Header1.RelativeSize),
					BackgroundTransparency = 1,
					Text = buttonProps.buttonText or "",
					Font = font.Header2.Font,
					TextSize = (font.BaseSize - 2) * font.Header2.RelativeSize,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextWrapped = false,
					TextColor3 = buttonProps.buttonTextColor,
					TextTransparency = v7,
					LayoutOrder = 2
				})
			}
		)
	end

	local forwardRef = self.props.forwardRef

	local createElement = Roact.createElement
	local v9 = focusable[interactable]
	local v10 = {
		Size = size,
		Position = position,
		AnchorPoint = anchorPoint,
		LayoutOrder = layoutOrder,
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Image = component_assetscircle_17,
		ImageColor3 = buttonProps.buttonColor,
		ImageTransparency = v7,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 9, 9),
		ClipsDescendants = true,
		[Roact.Event.InputBegan] = self.onInputBegan,
		[Roact.Event.InputEnded] = self.onInputEnded,
		[Roact.Event.Activated] = function()
			if buttonProps.onActivated ~= nil and not buttonProps.buttonIsLoading then
				buttonProps.onActivated()
			end
		end,
		NextSelectionLeft = self.props.NextSelectionLeft,
		NextSelectionDown = self.props.NextSelectionDown,
		NextSelectionUp = self.props.NextSelectionUp,
		NextSelectionRight = self.props.NextSelectionRight,
		[Roact.Ref] = forwardRef
	}

	local v11 = if fFlagAXActionButtonRoundedRectCursor then callback(cursorKind.RoundedRect) else callback(cursorKind.RoundedRectNoInset)
	v10.SelectionImageObject = v11

	local v13 = if fFlagAXGifting and self.props.fillWidth then Roact.createElement("UIFlexItem", {
		FlexMode = Enum.UIFlexMode.Fill
	}) else nil
	return createElement(v9, v10, { ButtonInfo = v8, FlexItem = v13 })
end

function extended:render()
	return withStyle(function(p2)
		return withSelectionCursorProvider(function(p3)
			return self:renderWithStyle(p2, p3)
		end)
	end)
end

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
