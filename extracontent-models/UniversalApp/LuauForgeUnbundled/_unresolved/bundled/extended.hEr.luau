local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local withStyle = UIBlox.Style.withStyle

local module = require("@luauforge/bundled/dwA")

local vrConstants = require("@luauforge/bundled/fye").VRConstants

local module2 = require("@luauforge/bundled/hEs")
local module3 = require("@luauforge/bundled/edi")
local module4 = require("@luauforge/bundled/edp")

local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local GRAY1 = module.Color.GRAY1
local sourceSans = Enum.Font.SourceSans

local GRAY1_2 = module.Color.GRAY1
local sourceSans2 = Enum.Font.SourceSans

local v5 = { Image = "LuaApp/buttons/buttonFill", SliceCenter = Rect.new(8, 8, 9, 9) }

local v6 = { Image = "LuaApp/buttons/buttonStroke", SliceCenter = Rect.new(8, 8, 9, 9) }

local extended = Roact.Component:extend("DropDownList")

extended.defaultProps = {
	height = 38,
	itemHeight = 54,
	itemTextColor = GRAY1_2,
	itemFont = sourceSans2,
	itemTextSize = 23,
	size = UDim2.new(1, 0, 0, 38),
	textColor = GRAY1,
	font = sourceSans,
	textSize = 18
}

function extended:init()
	self.state = { isOpen = false }

	function self.onActivated(instance)
		local screenGui = instance:FindFirstAncestorOfClass("ScreenGui")
		local v7, v8

		if screenGui == nil then
			v7 = 0
			v8 = 0
		else
			v8 = screenGui.AbsoluteSize.x
			v7 = screenGui.AbsoluteSize.y
		end

		local v11 = {
			x = instance.AbsolutePosition.x,
			y = instance.AbsolutePosition.y,
			width = instance.AbsoluteSize.x,
			height = instance.AbsoluteSize.y,
			parentWidth = 0,
			parentHeight = 0
		}

		if isVRAppBuild() then
			v8 = vrConstants.MainScreenResolution.x
		end

		v11.parentWidth = v8

		if isVRAppBuild() then
			v7 = vrConstants.MainScreenResolution.y
		end

		v11.parentHeight = v7
		self:setState({ isOpen = true, screenShape = v11 })
	end

	function self.callbackCancel()
		self:setState({ isOpen = false })
	end

	function self.callbackSelect(p2, p3)
		self:setState({ isOpen = false })

		if self.props.onSelected then
			self.props.onSelected(p2, p3)
		end
	end
end

function extended.render(props)
	local position = props.props.position
	local anchorPoint = props.props.anchorPoint
	local height = props.props.height
	local items = props.props.items
	local itemSelected = props.props.itemSelected
	local layoutOrder = props.props.layoutOrder
	local screenShape = props.state.screenShape
	local size = props.props.size
	local v7

	if props.state.isOpen then
		v7 = Roact.createElement(module2, {
			menuItems = items,
			screenShape = screenShape,
			callbackCancel = props.callbackCancel,
			callbackSelect = props.callbackSelect
		})
	else
		v7 = nil
	end

	return withStyle(function(props2)
		local createElement = Roact.createElement
		local onActivatedsByActivated = {
			Size = size,
			Position = position,
			AnchorPoint = anchorPoint,
			LayoutOrder = layoutOrder,
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			Image = v5.Image,
			ImageColor3 = props2.Theme.BackgroundDefault.Color,
			ImageTransparency = props2.Theme.BackgroundDefault.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = v5.SliceCenter,
			[Roact.Event.Activated] = props.onActivated
		}
		local children = {
			Border = Roact.createElement(module3, {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Image = v6.Image,
				ImageColor3 = props2.Theme.SecondaryDefault.Color,
				ImageTransparency = props2.Theme.SecondaryDefault.Transparency,
				LayoutOrder = layoutOrder,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = v6.SliceCenter
			}),
			Text = 0,
			Arrow = 0,
			Items = 0
		}

		local createElement2 = Roact.createElement
		local v10 = {
			BackgroundColor3 = module.Color.WHITE,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -47, 0, height),
			Text = itemSelected.displayName,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			Position = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			ClipsDescendants = true,
			TextTruncate = 0
		}
		local v11 = if not foundationFontFaceMigration then props2.Font.Body.Font else nil
		v10.Font = v11

		local v12 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font) else nil
		v10.FontFace = v12

		v10.TextSize = props2.Font.BaseSize * props2.Font.Body.RelativeSize
		v10.TextColor3 = props2.Theme.TextDefault.Color
		v10.TextTransparency = props2.Theme.TextDefault.Transparency
		v10.Position = UDim2.new(0, 10, 0, 0)
		v10.TextXAlignment = Enum.TextXAlignment.Left
		v10.TextYAlignment = Enum.TextYAlignment.Center

		v10.TextTruncate = Enum.TextTruncate.AtEnd
		children.Text = createElement2("TextLabel", v10)

		children.Arrow = Roact.createElement(module3, {
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = "LuaApp/icons/dropdown_arrowDown",
			ImageColor3 = props2.Theme.IconDefault.Color,
			ImageTransparency = props2.Theme.IconDefault.Transparency,
			Position = UDim2.new(1, -7, 0.5, 0),
			Size = UDim2.new(0, 20, 0, 20)
		})

		children.Items = v7
		return createElement(module4, onActivatedsByActivated, children)
	end)
end

return extended
