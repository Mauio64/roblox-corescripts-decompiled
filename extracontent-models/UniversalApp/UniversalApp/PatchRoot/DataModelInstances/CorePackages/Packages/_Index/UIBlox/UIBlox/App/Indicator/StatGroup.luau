local parent = script.Parent.Parent
local parent2 = parent.Parent
local core = parent2.Core
local parent3 = parent2.Parent

local React = require(parent3.React)
local Foundation = require(parent3.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local Images = require(parent.ImageSet.Images)

local ImageSetComponent = require(core.ImageSet.ImageSetComponent)
local useStyle = require(core.Style.useStyle)
require(parent.Style.Fonts)

local function renderStatItem(p, p2, text, p3)
	local tokens = p3.Tokens
	local font = p3.Font
	local textSize = font.BaseSize * font.Body.RelativeSize
	local maxTextSize = textSize + tokens.Size.Size_200

	local size_50 = tokens.Size.Size_50
	local size_400 = tokens.Size.Size_400
	local default = tokens.Color.Content.Default
	local default2 = tokens.Color.Content.Default

	return React.createElement("Frame", p, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, size_50)
		}),
		Icon = React.createElement(ImageSetComponent.Label, {
			Size = UDim2.fromOffset(size_400, size_400),
			Image = Images[p2],
			BackgroundTransparency = 1,
			ImageTransparency = default.Transparency,
			ImageColor3 = default.Color3,
			LayoutOrder = 1,
			AnchorPoint = Vector2.new(0, 0.5)
		}),
		Label = React.createElement("TextLabel", {
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			Text = text,
			FontFace = normalizeFontFace(font.Body.Font),
			TextSize = textSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextWrapped = false,
			TextColor3 = default2.Color3,
			TextTransparency = default2.Transparency,
			LayoutOrder = 2
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(tokens.Size.Size_1400, 1e999)
			}),
			UiTextSizeConstraint = React.createElement("UITextSizeConstraint", {
				MaxTextSize = maxTextSize
			})
		})
	})
end

local function StatGroup(p)
	local v = useStyle()

	local size_200 = v.Tokens.Size.Size_200

	local createElement = React.createElement
	local v2 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.X
	}
	local v3 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, size_200)
		}),
		RatingStats = renderStatItem(
			{
				Size = UDim2.fromScale(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				LayoutOrder = 1
			},
			"icons/status/games/rating_small",
			p.ratingText,
			v
		),
		PlayingStats = 0
	}
	local playingStats

	if p.playingText ~= nil then
		playingStats = renderStatItem(
			{
				Size = UDim2.fromScale(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				LayoutOrder = 2
			},
			"icons/status/games/people-playing_small",
			p.playingText,
			v
		)
	end

	v3.PlayingStats = playingStats
	return createElement("Frame", v2, v3)
end

return StatGroup
