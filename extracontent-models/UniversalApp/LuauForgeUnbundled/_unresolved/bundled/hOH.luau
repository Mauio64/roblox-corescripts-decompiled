local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/ego")

local module2 = require("@luauforge/bundled/egM")
local module3 = require("@luauforge/bundled/egF")
local module4 = require("@luauforge/bundled/gsh")

local extended = module.PureComponent:extend("GenericTextButton")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind

local getFFlagLuaAppFixSelectionCursor = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppFixSelectionCursor

local React = require(CorePackages.Packages.React)
local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId
local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddTestIdsForArrow

function extended:init()
	self.state = { isButtonPressed = false }

	function self.onInputBegan()
		self:setState({ isButtonPressed = true })
	end

	function self.onInputEnded()
		self:setState({ isButtonPressed = false })
	end
end

local function getCombinedTransparency(p2, p3)
	return 1 - (1 - p2) * (1 - p3)
end

function extended:render()
	if getFFlagLuaAppFixSelectionCursor() then
		return withSelectionCursorProvider(function(p2)
			return self:renderWithSelectionCursor(p2)
		end)
	end

	return self:renderWithSelectionCursor(nil)
end

function extended:renderWithSelectionCursor(callback)
	local themeSettings = self.props.themeSettings
	local size = self.props.Size
	local position = self.props.Position
	local anchorPoint = self.props.AnchorPoint
	local layoutOrder = self.props.LayoutOrder
	local text = self.props.Text
	local font = self.props.Font
	local textSize = self.props.TextSize
	local onActivated = self.props.onActivated
	local isLoading = self.props.isLoading
	local isDisabled = self.props.isDisabled
	local isButtonPressed = self.state.isButtonPressed
	local v5 = themeSettings.Border.Hidden == false

	local nextSelectionDown = self.props.NextSelectionDown
	local nextSelectionLeft = self.props.NextSelectionLeft
	local nextSelectionRight = self.props.NextSelectionRight
	local nextSelectionUp = self.props.NextSelectionUp

	local v6 = themeSettings.Color
	local v7 = 0

	if isLoading or isDisabled then
		v6 = themeSettings.DisabledColor
		v7 = themeSettings.DisabledTransparency
	elseif isButtonPressed then
		v6 = themeSettings.OnPressColor
		v7 = themeSettings.OnPressTransparency
	end

	local transparency = themeSettings.Transparency
	local v8 = 1 - (1 - v7) * (1 - transparency)
	local v9

	if v5 then
		local transparency2 = themeSettings.Border.Transparency
		v9 = 1 - (1 - v7) * (1 - transparency2) or 0
	else
		v9 = 0
	end

	local transparency2 = themeSettings.Text.Transparency
	local v10 = 1 - (1 - v7) * (1 - transparency2)

	local forwardRef = self.props.forwardRef
	local testId = self.props.testId

	local v11 = if getFFlagLuaAppFixSelectionCursor() then callback(cursorKind.InputButton) else nil

	local createElement = module.createElement
	local v13 = {
		["Size"] = nil,
		Size = size,
		Position = position,
		AnchorPoint = anchorPoint,
		LayoutOrder = layoutOrder,
		BackgroundTransparency = 1,
		Image = "LuaApp/buttons/buttonFill",
		ImageColor3 = v6,
		ImageTransparency = v8,
		BorderSizePixel = 0,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 9, 9),
		NextSelectionDown = nextSelectionDown,
		NextSelectionLeft = nextSelectionLeft,
		NextSelectionRight = nextSelectionRight,
		NextSelectionUp = nextSelectionUp,
		SelectionImageObject = v11
	}

	local tag = React.Tag
	local v14 = if fFlagLuaAppAddTestIdsForArrow and testId then getTestId(testId) else nil
	v13[tag] = v14
	v13[module.Ref] = forwardRef
	v13[module.Event.InputBegan] = self.onInputBegan
	v13[module.Event.InputEnded] = self.onInputEnded
	v13[module.Event.Activated] = onActivated
	return createElement(module2, v13, {
		Border = v5 and module.createElement(module3, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "LuaApp/buttons/buttonStroke",
			ImageColor3 = themeSettings.Border.Color,
			ImageTransparency = v9,
			BorderSizePixel = 0,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9)
		}),
		Text = module.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, textSize),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Text = text,
			Font = font,
			TextSize = textSize,
			TextColor3 = themeSettings.Text.Color,
			TextTransparency = v10,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundTransparency = 1
		}),
		ShimmerAnimation = isLoading and module.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ClipsDescendants = true
			},
			{
				Shimmer = module.createElement(module4, {
					Size = UDim2.new(1, 0, 2, 0),
					Position = UDim2.new(0, 0, 0, 0),
					shimmerSpeed = 1.5
				})
			}
		)
	})
end

return module.forwardRef(function(p2, p3)
	return module.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
