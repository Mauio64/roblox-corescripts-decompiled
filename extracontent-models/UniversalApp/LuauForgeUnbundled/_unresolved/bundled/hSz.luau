local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)

local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local interactable = UIBlox.Core.Control.Interactable
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local module = require("@luauforge/bundled/hSv")
local subheaderText = module.SubheaderText
local bodyText = module.BodyText

return (React.forwardRef(function(props, p2)
	local v5 = useDesignTokens()
	local size_600 = v5.Size.Size_600
	local size_800 = v5.Size.Size_800

	local v6 = useSelectionCursor(cursorKind.RoundedRect)

	local createElement = React.createElement
	local onActivatedsByActivated = {
		ref = p2,
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, v5.Size.Size_1400),
		BackgroundTransparency = 1,
		SelectionImageObject = v6,
		[React.Event.Activated] = props.onActivated,
		onStateChanged = Dash.noop
	}
	local v8 = {
		TitleFrame = React.createElement("Frame", {
			Position = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1
		}, {
			Title = React.createElement(subheaderText, {
				layoutOrder = 1,
				text = props.title
			})
		}),
		StatusFrame = 0
	}

	local createElement2 = React.createElement
	local v10 = {
		Position = UDim2.new(1, -size_600, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Size = UDim2.new(),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1
	}

	local v12 = if props.icon then React.createElement(imageSetLabel, {
		BackgroundTransparency = 1,
		Image = props.icon,
		ImageColor3 = v5.Color.Content.Default.Color3,
		ImageTransparency = v5.Color.Content.Default.Transparency,
		Size = UDim2.fromOffset(size_800, size_800)
	}) else nil

	local v13 = if props.status then React.createElement(bodyText, {
		text = props.status,
		TextXAlignment = Enum.TextXAlignment.Right
	}) else nil
	v8.StatusFrame = createElement2("Frame", v10, { Icon = v12, Status = v13 })
	return createElement(interactable, onActivatedsByActivated, v8)
end))
