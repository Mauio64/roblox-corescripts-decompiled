local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Core = ParentParentParent.Core
local ParentParentParentParent = ParentParentParent.Parent
local React = require(ParentParentParentParent.React)
local Images = require(ParentParent.ImageSet.Images)
local ImageSetComponent = require(Core.ImageSet.ImageSetComponent)
local useStyle = require(Core.Style.useStyle)

require(ParentParent.Style.Fonts)

local function renderStatItem(p1, p2, p3, p4) -- line: 26
	-- upvalues: React (copy), ImageSetComponent (copy), Images (copy)
	local Tokens = p4.Tokens
	local p4Font = p4.Font
	local v17 = p4Font.BaseSize * p4Font.Body.RelativeSize
	local v18 = v17 + Tokens.Global.Size_100
	local Space_25 = Tokens.Global.Space_25
	local Small = Tokens.Semantic.Icon.Size.Small
	local Default = Tokens.Semantic.Color.Text.Default
	local Default2 = Tokens.Semantic.Color.Text.Default

	return React.createElement("Frame", p1, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, Space_25)
		}),
		Icon = React.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(Small, Small),
			Image = Images[p2],
			ImageTransparency = Default.Transparency,
			ImageColor3 = Default.Color3,
			AnchorPoint = Vector2.new(0, 0.5)
		}),
		Label = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = false,
			LayoutOrder = 2,
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = p3,
			Font = p4Font.Body.Font,
			TextSize = v17,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextColor3 = Default2.Color3,
			TextTransparency = Default2.Transparency
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(Tokens.Global.Size_700, 1e999)
			}),
			UiTextSizeConstraint = React.createElement("UITextSizeConstraint", {
				MaxTextSize = v18
			})
		})
	})
end
local function StatGroup(t1: {[any]: any}) -- line: 78
	-- upvalues: useStyle (copy), React (copy), renderStatItem (copy)
	local v24 = useStyle()
	local Space_100 = v24.Tokens.Global.Space_100

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, Space_100)
		}),
		RatingStats = renderStatItem({
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, "icons/status/games/rating_small", t1.ratingText, v24),
		PlayingStats = if t1.playingText == nil then nil else renderStatItem({
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, "icons/status/games/people-playing_small", t1.playingText, v24)
	})
end

return StatGroup
