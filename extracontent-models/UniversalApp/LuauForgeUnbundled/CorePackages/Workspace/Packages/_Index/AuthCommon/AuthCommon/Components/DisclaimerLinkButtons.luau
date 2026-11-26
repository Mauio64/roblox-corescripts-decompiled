local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox")

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").useDesignTokens

local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind

local images = UIBlox.App.ImageSet.Images

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local function fn(fillDirection, size_1400, size_300)
	if fillDirection == Enum.FillDirection.Horizontal then
		return {
			CellSize = UDim2.new(0.5, -size_300, 0, size_1400)
		}
	end

	return { CellSize = UDim2.new(1, 0, 0, size_1400) }
end

local function fn2(props)
	local v5 = useStyle()
	local v6 = useDesignTokens()
	local v7 = useSelectionCursor(cursorKind.RoundedRect)

	local size_1400 = v6.Size.Size_1400 or 80
	local size_700 = v6.Size.Size_700 or 42

	return React.createElement("ImageButton", {
		AutoButtonColor = false,
		Size = UDim2.new(1, 0, 0, size_1400),
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		[React.Event.Activated] = props.activated,
		SelectionImageObject = v7
	}, {
		padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 36),
			PaddingRight = UDim.new(0, 36)
		}),
		ButtonText = React.createElement(styledTextLabel, {
			text = props.text,
			automaticSize = Enum.AutomaticSize.X,
			size = UDim2.new(1, 0, 0, size_1400),
			textXAlignment = Enum.TextXAlignment.Left,
			fontStyle = v5.Font.Header1,
			colorStyle = v5.Theme.TextDefault,
			layoutOrder = 1
		}),
		LinkIconImage = React.createElement(imageSetLabel, {
			Size = UDim2.new(0, size_700, 0, size_700),
			Position = UDim2.new(1, 0, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			ScaleType = Enum.ScaleType.Fit,
			Image = images["icons/navigation/externallink_medium"],
			ImageColor3 = v5.Theme.UIEmphasis.Color,
			ImageTransparency = 0
		})
	})
end

return function(props)
	local v5 = useDesignTokens()
	local size_1400 = v5.Size.Size_1400 or 80
	local size_300 = v5.Size.Size_300 or 18
	local fillDirection = props.fillDirection or Enum.FillDirection.Vertical
	local v6 = fn(fillDirection, size_1400, size_300)
	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
		Selectable = false,
		LayoutOrder = props.layoutOrder
	}, {
		gridlayout = React.createElement("UIGridLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = fillDirection,
			CellPadding = UDim2.new(0, size_300, 0, size_300),
			CellSize = v6.CellSize
		}),
		ButtonTos = React.createElement(fn2, {
			text = props.textTos,
			activated = props.activatedTos,
			layoutOrder = 1
		}),
		ButtonPrivacy = React.createElement(fn2, {
			text = props.textPrivacy,
			activated = props.activatedPrivacy,
			layoutOrder = 2
		})
	})
end
