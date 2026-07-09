local CoreGui = game:GetService("CoreGui")
local ExpChat = script:FindFirstAncestor("ExpChat")
local TextChatService = game:GetService("TextChatService")
local TextService = game:GetService("TextService")
local getAbsolutePaddingbyDimension = require(ExpChat.BubbleChat.Helpers.getAbsolutePaddingbyDimension)
local getFFlagExpChatAlwaysRunTCS = require(ExpChat.Parent.SharedFlags).getFFlagExpChatAlwaysRunTCS

local function v7(s1: string, p1) -- line: 9
	-- upvalues: CoreGui (copy), getAbsolutePaddingbyDimension (copy)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Enabled = false
	ScreenGui.Name = "RichTextSizingLabel"
	ScreenGui.Parent = CoreGui

	local TextLabel = Instance.new("TextLabel")

	TextLabel.TextWrapped = true
	TextLabel.RichText = true
	TextLabel.Parent = ScreenGui
	TextLabel.Text = s1
	TextLabel.TextSize = p1.TextSize

	if p1.FontFace then
		TextLabel.FontFace = p1.FontFace
	else
		TextLabel.Font = p1.Font
	end

	TextLabel.Size = UDim2.fromOffset(p1.MaxWidth, 10000)

	local TextBounds = TextLabel.TextBounds

	ScreenGui:Destroy()

	local vector2

	if p1.UIPadding then
		local v13 = getAbsolutePaddingbyDimension(p1.UIPadding.PaddingLeft, TextBounds.X)
		local v14 = getAbsolutePaddingbyDimension(p1.UIPadding.PaddingRight, TextBounds.X)
		local v15 = getAbsolutePaddingbyDimension(p1.UIPadding.PaddingTop, TextBounds.Y)
		local v16 = getAbsolutePaddingbyDimension(p1.UIPadding.PaddingBottom, TextBounds.Y)

		vector2 = Vector2.new((v13 + v14) * 2, v15 + v16)
	else
		local p1Padding = p1.Padding

		vector2 = Vector2.new(p1Padding * 4, p1Padding * 2)
	end

	return vector2 + TextBounds
end

return function(s2: string, p2, p3) -- line: 51
	-- upvalues: TextChatService (copy), getFFlagExpChatAlwaysRunTCS (copy), v7 (copy), TextService (copy)
	if p3 == nil then
		p3 = TextChatService
	end

	if getFFlagExpChatAlwaysRunTCS() or p3.ChatVersion == Enum.ChatVersion.TextChatService then
		return (v7(s2, p2))
	end

	return TextService:GetTextSize(s2, p2.TextSize, p2.Font, Vector2.new(p2.MaxWidth, 10000)) + Vector2.new(p2.Padding * 4, p2.Padding * 2)
end
