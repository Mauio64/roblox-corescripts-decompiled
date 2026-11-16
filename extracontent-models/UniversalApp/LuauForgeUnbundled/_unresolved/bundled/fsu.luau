local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local module = require("@luauforge/bundled/edi")

local function TouchFriendlyIconButton(props)
	local zIndex = props.ZIndex
	local position = props.Position
	local anchorPoint = props.AnchorPoint
	local size = props.Size
	local layoutOrder = props.LayoutOrder
	local onActivated = props.onActivated
	local icon = props.icon
	local iconSize = props.iconSize
	local iconPosition = props.iconPosition or UDim2.new(0.5, 0, 0.5, 0)
	local iconAnchorPoint = props.iconAnchorPoint or Vector2.new(0.5, 0.5)
	local iconColor = props.iconColor
	local iconTransparency = props.iconTransparency
	local useUIBloxImageSet = props.useUIBloxImageSet
	local v5 = props[Roact.Children]
	local v6 = props[Roact.Change.AbsolutePosition]
	local v7 = useUIBloxImageSet and imageSetLabel or module
	local forwardRef = props.forwardRef

	return withSelectionCursorProvider(function(callback)
		return Roact.createElement(focusable.TextButton, {
			ZIndex = zIndex,
			Position = position,
			AnchorPoint = anchorPoint,
			Size = size,
			LayoutOrder = layoutOrder,
			BackgroundTransparency = 1,
			Text = "",
			[Roact.Event.Activated] = onActivated,
			[Roact.Change.AbsolutePosition] = v6,
			[Roact.Ref] = forwardRef,
			NextSelectionLeft = props.NextSelectionLeft,
			NextSelectionRight = props.NextSelectionRight,
			NextSelectionUp = props.NextSelectionUp,
			NextSelectionDown = props.NextSelectionDown,
			inputBindings = props.inputBindings,
			SelectionImageObject = callback(cursorKind.RoundedRectNoInset)
		}, {
			NavigationButton = Roact.createElement(v7, {
				Size = UDim2.new(0, iconSize, 0, iconSize),
				Position = iconPosition,
				AnchorPoint = iconAnchorPoint,
				Image = icon,
				ImageColor3 = iconColor,
				ImageTransparency = iconTransparency,
				BackgroundTransparency = 1
			}, v5)
		})
	end)
end

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(TouchFriendlyIconButton, Cryo.Dictionary.join(p2, {
		forwardRef = p3
	}))
end)
