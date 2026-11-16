local GuiService = game:GetService("GuiService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Actions = ExpChat.Actions
local ChatLayoutHorizontalAlignmentChanged = require(Actions.ChatLayoutHorizontalAlignmentChanged)
local ChatLayoutVerticalAlignmentChanged = require(Actions.ChatLayoutVerticalAlignmentChanged)

local y = GuiService:GetGuiInset().Y

local v = {
	Position = UDim2.new(0, 8, 0, 4),
	AnchorPoint = Vector2.new(0, 0),
	UIListLayoutVerticalAlignment = Enum.VerticalAlignment.Top
}

return Rodux.createReducer(v, {
	[ChatLayoutHorizontalAlignmentChanged.name] = function(p, p2)
		local position = p.Position
		local anchorPoint = p.AnchorPoint

		if p2.value == Enum.HorizontalAlignment.Left then
			position = UDim2.new(0, 8, position.Y.Scale, position.Y.Offset)
			anchorPoint = Vector2.new(0, anchorPoint.Y)
		elseif p2.value == Enum.HorizontalAlignment.Center then
			position = UDim2.new(0.5, 0, position.Y.Scale, position.Y.Offset)
			anchorPoint = Vector2.new(0.5, anchorPoint.Y)
		elseif p2.value == Enum.HorizontalAlignment.Right then
			position = UDim2.new(1, -8, position.Y.Scale, position.Y.Offset)
			anchorPoint = Vector2.new(1, anchorPoint.Y)
		end

		return dictionary.join(p, { Position = position, AnchorPoint = anchorPoint })
	end,
	[ChatLayoutVerticalAlignmentChanged.name] = function(p, p2)
		local position = p.Position
		local anchorPoint = p.AnchorPoint

		if p2.value == Enum.VerticalAlignment.Top then
			position = UDim2.new(position.X.Scale, position.X.Offset, 0, 4)
			anchorPoint = Vector2.new(anchorPoint.X, 0)
		elseif p2.value == Enum.VerticalAlignment.Center then
			position = UDim2.new(position.X.Scale, position.X.Offset, 0.5, -y)
			anchorPoint = Vector2.new(anchorPoint.X, 0.5)
		elseif p2.value == Enum.VerticalAlignment.Bottom then
			position = UDim2.new(position.X.Scale, position.X.Offset, 1, -4)
			anchorPoint = Vector2.new(anchorPoint.X, 1)
		end

		return dictionary.join(p, {
			Position = position,
			AnchorPoint = anchorPoint,
			UIListLayoutVerticalAlignment = p2.value
		})
	end
})
