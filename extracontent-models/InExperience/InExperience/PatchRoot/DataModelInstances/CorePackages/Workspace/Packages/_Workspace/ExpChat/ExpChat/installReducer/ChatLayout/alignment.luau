local GuiService = game:GetService("GuiService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local Dictionary = require(ExpChatParent.llama).Dictionary
local Actions = ExpChat.Actions
local ChatLayoutHorizontalAlignmentChanged = require(Actions.ChatLayoutHorizontalAlignmentChanged)
local ChatLayoutVerticalAlignmentChanged = require(Actions.ChatLayoutVerticalAlignmentChanged)
local Y = GuiService:GetGuiInset().Y
local t1 = {
	Position = UDim2.new(0, 8, 0, 4),
	AnchorPoint = Vector2.new(0, 0),
	UIListLayoutVerticalAlignment = Enum.VerticalAlignment.Top
}

return Rodux.createReducer(t1, {
	[ChatLayoutHorizontalAlignmentChanged.name] = function(p1, p2) -- line: 22
		-- upvalues: Dictionary (copy)
		local p1Position = p1.Position
		local p1AnchorPoint = p1.AnchorPoint

		if p2.value == Enum.HorizontalAlignment.Left then
			p1Position = UDim2.new(0, 8, p1Position.Y.Scale, p1Position.Y.Offset)
			p1AnchorPoint = Vector2.new(0, p1AnchorPoint.Y)
		elseif p2.value == Enum.HorizontalAlignment.Center then
			p1Position = UDim2.new(0.5, 0, p1Position.Y.Scale, p1Position.Y.Offset)
			p1AnchorPoint = Vector2.new(0.5, p1AnchorPoint.Y)
		elseif p2.value == Enum.HorizontalAlignment.Right then
			p1Position = UDim2.new(1, -8, p1Position.Y.Scale, p1Position.Y.Offset)
			p1AnchorPoint = Vector2.new(1, p1AnchorPoint.Y)
		end

		return Dictionary.join(p1, {
			Position = p1Position,
			AnchorPoint = p1AnchorPoint
		})
	end,
	[ChatLayoutVerticalAlignmentChanged.name] = function(p3, p4) -- line: 43
		-- upvalues: Y (copy), Dictionary (copy)
		local p3Position = p3.Position
		local p3AnchorPoint = p3.AnchorPoint

		if p4.value == Enum.VerticalAlignment.Top then
			p3Position = UDim2.new(p3Position.X.Scale, p3Position.X.Offset, 0, 4)
			p3AnchorPoint = Vector2.new(p3AnchorPoint.X, 0)
		elseif p4.value == Enum.VerticalAlignment.Center then
			p3Position = UDim2.new(p3Position.X.Scale, p3Position.X.Offset, 0.5, -Y)
			p3AnchorPoint = Vector2.new(p3AnchorPoint.X, 0.5)
		elseif p4.value == Enum.VerticalAlignment.Bottom then
			p3Position = UDim2.new(p3Position.X.Scale, p3Position.X.Offset, 1, -4)
			p3AnchorPoint = Vector2.new(p3AnchorPoint.X, 1)
		end

		return Dictionary.join(p3, {
			Position = p3Position,
			AnchorPoint = p3AnchorPoint,
			UIListLayoutVerticalAlignment = p4.value
		})
	end
})
