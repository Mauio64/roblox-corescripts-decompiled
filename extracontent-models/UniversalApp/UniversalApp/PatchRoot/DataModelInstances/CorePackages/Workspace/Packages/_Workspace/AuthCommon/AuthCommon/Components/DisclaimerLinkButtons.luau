local Parent = script:FindFirstAncestor("AuthCommon").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useDesignTokens = require(Parent.Style).useDesignTokens
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local function v11(p1, p2, p3) -- line: 40
	if p1 == Enum.FillDirection.Horizontal then
		return {
			CellSize = UDim2.new(0.5, -p3, 0, p2)
		}
	end

	return {
		CellSize = UDim2.new(1, 0, 0, p2)
	}
end
local function v12(t1: {[any]: any}) -- line: 52
	-- upvalues: useStyle (copy), useDesignTokens (copy), useSelectionCursor (copy), CursorKind (copy), React (copy), StyledTextLabel (copy), ImageSetLabel (copy), Images (copy)
	local v17 = useStyle()
	local v18 = useDesignTokens()
	local v19 = useSelectionCursor(CursorKind.RoundedRect)
	local v20 = v18.Size.Size_1400 or 80
	local v21 = v18.Size.Size_700 or 42

	return React.createElement("ImageButton", {
		AutoButtonColor = false,
		Size = UDim2.new(1, 0, 0, v20),
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		[React.Event.Activated] = t1.activated,
		SelectionImageObject = v19
	}, {
		padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 36),
			PaddingRight = UDim.new(0, 36)
		}),
		ButtonText = React.createElement(StyledTextLabel, {
			layoutOrder = 1,
			text = t1.text,
			automaticSize = Enum.AutomaticSize.X,
			size = UDim2.new(1, 0, 0, v20),
			textXAlignment = Enum.TextXAlignment.Left,
			fontStyle = v17.Font.Header1,
			colorStyle = v17.Theme.TextDefault
		}),
		LinkIconImage = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			ImageTransparency = 0,
			Size = UDim2.new(0, v21, 0, v21),
			Position = UDim2.new(1, 0, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			ScaleType = Enum.ScaleType.Fit,
			Image = Images["icons/navigation/externallink_medium"],
			ImageColor3 = v17.Theme.UIEmphasis.Color
		})
	})
end

return function(t2: {[any]: any}) -- line: 95
	-- upvalues: useDesignTokens (copy), v11 (copy), React (copy), v12 (copy)
	local v23 = useDesignTokens()
	local v24 = v23.Size.Size_1400 or 80
	local v25 = v23.Size.Size_300 or 18
	local v26 = t2.fillDirection or Enum.FillDirection.Vertical
	local v27 = v11(v26, v24, v25)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Selectable = false,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		LayoutOrder = t2.layoutOrder
	}, {
		gridlayout = React.createElement("UIGridLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = v26,
			CellPadding = UDim2.new(0, v25, 0, v25),
			CellSize = v27.CellSize
		}),
		ButtonTos = React.createElement(v12, {
			layoutOrder = 1,
			text = t2.textTos,
			activated = t2.activatedTos
		}),
		ButtonPrivacy = React.createElement(v12, {
			layoutOrder = 2,
			text = t2.textPrivacy,
			activated = t2.activatedPrivacy
		})
	})
end
