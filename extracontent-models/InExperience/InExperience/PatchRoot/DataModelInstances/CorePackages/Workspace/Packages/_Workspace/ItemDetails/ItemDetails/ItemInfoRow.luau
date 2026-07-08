local Parent = script:FindFirstAncestor("ItemDetails").Parent
local React = require(Parent.React)
local Focusable = require(Parent.RoactGamepad).Focusable
local VerifiedBadges = require(Parent.VerifiedBadges)
local UIBlox = require(Parent.UIBlox)
local Skeleton = require(Parent.Foundation).Skeleton
local useStyle = UIBlox.Core.Style.useStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v12 = Images["icons/navigation/pushRight_small"] or "LuaApp/icons/GameDetails/navigation/pushRight_small"
local vector2 = Vector2.new(14, 14)
local uDim2 = UDim2.new(0.3, 0, 0.8, 0)

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 47
	-- upvalues: useStyle (copy), useSelectionCursor (copy), CursorKind (copy), vector2 (copy), Focusable (copy), React (copy), VerifiedBadges (copy), Skeleton (copy), uDim2 (copy), ImageSetLabel (copy), v12 (copy)
	local t1LayoutOrder = t1.LayoutOrder
	local infoName = t1.infoName
	local infoData = t1.infoData
	local onActivate = t1.onActivate
	local hasVerifiedBadge = t1.hasVerifiedBadge
	local isLoading = t1.isLoading
	local v23 = useStyle()
	local Theme = v23.Theme
	local Font = v23.Font
	local v26 = useSelectionCursor(CursorKind.RoundedRect)
	local TextEmphasisColor = Theme.TextEmphasis.Color
	local v28 = Font.BaseSize * Font.Body.RelativeSize
	local v29 = -11 - vector2.X
	local v30 = p1 ~= nil
	local v31 = not v30 and "ImageButton" or Focusable.ImageButton
	local v32 = not isLoading and not hasVerifiedBadge
	local v33 = not isLoading and hasVerifiedBadge

	return React.createElement(v31, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = t1LayoutOrder,
		Size = UDim2.new(1, 0, 0, not t1.hideDivider and 53 or 52),
		[React.Event.Activated] = onActivate,
		NextSelectionUp = t1.NextSelectionUp,
		NextSelectionDown = t1.NextSelectionDown,
		NextSelectionLeft = t1.NextSelectionLeft,
		NextSelectionRight = t1.NextSelectionRight,
		ref = p1,
		SelectionImageObject = v30 and v26 or nil,
		Selectable = t1.Selectable
	}, {
		Container = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, not t1.hideDivider and -1 or 0)
		}, {
			InfoNameTextLabel = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Font = Font.Body.Font,
				Size = UDim2.new(0.5, 0, 1, 0),
				Text = infoName,
				TextColor3 = Theme.TextDefault.Color,
				TextSize = v28,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			}),
			InfoDataWithEmoji = v33 and React.createElement(VerifiedBadges.EmojiWrapper, {
				emoji = VerifiedBadges.emoji.verified,
				font = if not onActivate then Font.Body.Font else Font.Header2.Font,
				anchorPoint = Vector2.new(1, 0),
				position = UDim2.new(1, not onActivate and 0 or v29, 0, 0),
				size = UDim2.new(0.5, 0, 1, 0),
				automaticSize = Enum.AutomaticSize.None,
				horizontalAlignment = Enum.HorizontalAlignment.Right,
				verticalAlignment = Enum.VerticalAlignment.Center
			}, {
				InfoDataTextLabel = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Font = onActivate and Font.Header2.Font or Font.Body.Font,
					Size = UDim2.new(0, 0, 1, 0),
					Text = infoData,
					TextColor3 = if not onActivate then Theme.TextDefault.Color else Theme.TextEmphasis.Color,
					TextSize = v28,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextScaled = t1.TextScaled,
					AutomaticSize = Enum.AutomaticSize.X,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			}),
			InfoDataTextLabel = v32 and React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, not onActivate and 0 or v29, 0, 0),
				Font = if not onActivate then Font.Body.Font else Font.Header2.Font,
				Size = UDim2.new(0.5, 0, 1, 0),
				Text = infoData,
				TextColor3 = if not onActivate then Theme.TextDefault.Color else Theme.TextEmphasis.Color,
				TextSize = v28,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextScaled = t1.TextScaled,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextYAlignment = Enum.TextYAlignment.Center
			}, {
				TextSizeConstraint = t1.TextScaled and React.createElement("UITextSizeConstraint", {
					MaxTextSize = v28
				})
			}),
			LoadingShimmer = isLoading and React.createElement(Skeleton, {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = uDim2
			}),
			LinkIcon = onActivate and React.createElement(ImageSetLabel, {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(vector2.X, vector2.Y),
				Image = v12,
				ImageColor3 = TextEmphasisColor
			})
		}),
		Divider = not t1.hideDivider and React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = Theme.Divider.Color,
			BackgroundTransparency = Theme.Divider.Transparency,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, -1)
		})
	})
end))
