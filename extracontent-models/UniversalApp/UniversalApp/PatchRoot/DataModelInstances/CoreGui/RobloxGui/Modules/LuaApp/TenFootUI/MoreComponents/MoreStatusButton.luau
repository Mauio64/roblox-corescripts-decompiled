local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Interactable = UIBlox.Core.Control.Interactable
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local MoreText = require(script.Parent.MoreText)
local SubheaderText = MoreText.SubheaderText
local BodyText = MoreText.BodyText

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 25
	-- upvalues: useDesignTokens (copy), useSelectionCursor (copy), CursorKind (copy), React (copy), Interactable (copy), Dash (copy), SubheaderText (copy), ImageSetLabel (copy), BodyText (copy)
	local v15 = useDesignTokens()
	local Size_600 = v15.Size.Size_600
	local Size_800 = v15.Size.Size_800
	local v18 = useSelectionCursor(CursorKind.RoundedRect)

	return React.createElement(Interactable, {
		ref = p1,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, v15.Size.Size_1400),
		BackgroundTransparency = 1,
		SelectionImageObject = v18,
		[React.Event.Activated] = t1.onActivated,
		onStateChanged = Dash.noop
	}, {
		TitleFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			Title = React.createElement(SubheaderText, {
				layoutOrder = 1,
				text = t1.title
			})
		}),
		StatusFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -Size_600, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			Icon = if not t1.icon then nil else React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = t1.icon,
				ImageColor3 = v15.Color.Content.Default.Color3,
				ImageTransparency = v15.Color.Content.Default.Transparency,
				Size = UDim2.fromOffset(Size_800, Size_800)
			}),
			Status = if not t1.status then nil else React.createElement(BodyText, {
				text = t1.status,
				TextXAlignment = Enum.TextXAlignment.Right
			})
		})
	})
end))
