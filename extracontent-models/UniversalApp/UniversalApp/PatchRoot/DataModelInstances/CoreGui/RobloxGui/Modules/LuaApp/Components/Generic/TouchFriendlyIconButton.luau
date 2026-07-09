local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)

local function TouchFriendlyIconButton(p1) -- line: 17
	-- upvalues: Roact (copy), ImageSetLabel (copy), DEPRECATED_ImageSetLabel (copy), withSelectionCursorProvider (copy), Focusable (copy), CursorKind (copy)
	local p1ZIndex = p1.ZIndex
	local p1Position = p1.Position
	local p1AnchorPoint = p1.AnchorPoint
	local p1Size = p1.Size
	local p1LayoutOrder = p1.LayoutOrder
	local onActivated = p1.onActivated
	local icon = p1.icon
	local iconSize = p1.iconSize
	local v21 = p1.iconPosition or UDim2.new(0.5, 0, 0.5, 0)
	local v22 = p1.iconAnchorPoint or Vector2.new(0.5, 0.5)
	local iconColor = p1.iconColor
	local iconTransparency = p1.iconTransparency
	local useUIBloxImageSet = p1.useUIBloxImageSet
	local v26 = p1[Roact.Children]
	local v27 = p1[Roact.Change.AbsolutePosition]
	local v28 = useUIBloxImageSet and ImageSetLabel or DEPRECATED_ImageSetLabel
	local forwardRef = p1.forwardRef

	return withSelectionCursorProvider(function(p2) -- line: 38
		-- upvalues: Roact (copy), Focusable (copy), p1ZIndex (copy), p1Position (copy), p1AnchorPoint (copy), p1Size (copy), p1LayoutOrder (copy), onActivated (copy), v27 (copy), forwardRef (copy), p1 (copy), CursorKind (copy), v28 (copy), iconSize (copy), v21 (copy), v22 (copy), icon (copy), iconColor (copy), iconTransparency (copy), v26 (copy)
		return Roact.createElement(Focusable.TextButton, {
			ZIndex = p1ZIndex,
			Position = p1Position,
			AnchorPoint = p1AnchorPoint,
			Size = p1Size,
			LayoutOrder = p1LayoutOrder,
			BackgroundTransparency = 1,
			Text = "",
			[Roact.Event.Activated] = onActivated,
			[Roact.Change.AbsolutePosition] = v27,
			[Roact.Ref] = forwardRef,
			NextSelectionLeft = p1.NextSelectionLeft,
			NextSelectionRight = p1.NextSelectionRight,
			NextSelectionUp = p1.NextSelectionUp,
			NextSelectionDown = p1.NextSelectionDown,
			inputBindings = p1.inputBindings,
			SelectionImageObject = p2(CursorKind.RoundedRectNoInset)
		}, {
			NavigationButton = Roact.createElement(v28, {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, iconSize, 0, iconSize),
				Position = v21,
				AnchorPoint = v22,
				Image = icon,
				ImageColor3 = iconColor,
				ImageTransparency = iconTransparency
			}, v26)
		})
	end)
end

return Roact.forwardRef(function(p3, p4) -- line: 72
	-- upvalues: Roact (copy), TouchFriendlyIconButton (copy), Cryo (copy)
	return Roact.createElement(TouchFriendlyIconButton, Cryo.Dictionary.join(p3, {
		forwardRef = p4
	}))
end)
