local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useCursorByType = UIBlox.App.SelectionCursor.useCursorByType
local CursorType = UIBlox.App.SelectionCursor.CursorType

return function(t1: {[any]: any}) -- line: 30
	-- upvalues: useStyle (copy), useCursorByType (copy), CursorType (copy), React (copy), Focusable (copy)
	local v9 = useStyle()
	local Font = v9.Font
	local Theme = v9.Theme
	local isSelected = t1.isSelected
	local Header2Font = Font.Header2.Font
	local v14 = Font.BaseSize * Font.Header2.RelativeSize
	local tabTitle = t1.tabTitle
	local v16 = isSelected and Theme.TextEmphasis.Color or Theme.TextMuted.Color
	local v17 = isSelected and Theme.TextEmphasis.Transparency or Theme.TextMuted.Transparency
	local ref = t1.ref
	local frameRef = t1.frameRef
	local v20 = useCursorByType(CursorType.NavHighlight)
	local tabsLength = t1.tabsLength
	local n1 = 1

	if tabsLength > 0 then
		n1 = 1 / tabsLength
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(n1, 0, 1, 0),
		LayoutOrder = t1.layoutOrder,
		ref = frameRef
	}, {
		Button = React.createElement(Focusable.TextButton, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = tabTitle,
			TextSize = v14,
			TextColor3 = v16,
			TextTransparency = v17,
			Font = Header2Font,
			[React.Event.Activated] = function() -- line: 77
				-- upvalues: t1 (copy)
				t1.onActivate(t1.tabIndex)
			end,
			ref = ref,
			NextSelectionLeft = t1.NextSelectionLeft,
			NextSelectionRight = t1.NextSelectionRight,
			NextSelectionUp = t1.NextSelectionUp,
			NextSelectionDown = t1.NextSelectionDown,
			SelectionImageObject = v20
		}),
		Frame = React.createElement("Frame", {
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 0, not isSelected and 1 or 3),
			BackgroundColor3 = if not isSelected then Theme.Divider.Color else Theme.IconEmphasis.Color,
			BackgroundTransparency = if not isSelected then Theme.Divider.Transparency else Theme.IconEmphasis.Transparency
		})
	})
end
