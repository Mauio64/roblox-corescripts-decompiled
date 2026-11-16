local CoreGui = game:GetService("CoreGui")
local ExpChat = script:FindFirstAncestor("ExpChat")
local TextChatService = game:GetService("TextChatService")
local TextService = game:GetService("TextService")

local getAbsolutePaddingbyDimension = require(ExpChat.BubbleChat.Helpers.getAbsolutePaddingbyDimension)
local SharedFlags = require(ExpChat.Parent.SharedFlags)
local getFFlagExpChatAlwaysRunTCS = SharedFlags.getFFlagExpChatAlwaysRunTCS

local function fn(text: string, data)
	local richTextSizingLabel = Instance.new("ScreenGui")
	richTextSizingLabel.Enabled = false
	richTextSizingLabel.Name = "RichTextSizingLabel"
	richTextSizingLabel.Parent = CoreGui

	local textLabel = Instance.new("TextLabel")
	textLabel.TextWrapped = true
	textLabel.RichText = true
	textLabel.Parent = richTextSizingLabel
	textLabel.Text = text
	textLabel.TextSize = data.TextSize

	if data.FontFace then
		textLabel.FontFace = data.FontFace
	else
		textLabel.Font = data.Font
	end

	textLabel.Size = UDim2.fromOffset(data.MaxWidth, 10000)

	local textBounds = textLabel.TextBounds

	richTextSizingLabel:Destroy()
	local vector2

	if data.UIPadding then
		local absolutePaddingbyDimension = getAbsolutePaddingbyDimension(data.UIPadding.PaddingLeft, textBounds.X)
		local absolutePaddingbyDimension2 = getAbsolutePaddingbyDimension(data.UIPadding.PaddingRight, textBounds.X)
		local absolutePaddingbyDimension3 = getAbsolutePaddingbyDimension(data.UIPadding.PaddingTop, textBounds.Y)
		local absolutePaddingbyDimension4 = getAbsolutePaddingbyDimension(data.UIPadding.PaddingBottom, textBounds.Y)

		vector2 = Vector2.new(
			(absolutePaddingbyDimension + absolutePaddingbyDimension2) * 2,
			absolutePaddingbyDimension3 + absolutePaddingbyDimension4
		)
	else
		local padding = data.Padding
		vector2 = Vector2.new(padding * 4, padding * 2)
	end

	return vector2 + textBounds
end

return function(text: string, data, p)
	if p == nil then
		p = TextChatService
	end

	if getFFlagExpChatAlwaysRunTCS() or p.ChatVersion == Enum.ChatVersion.TextChatService then
		return fn(text, data)
	end

	return TextService:GetTextSize(text, data.TextSize, data.Font, Vector2.new(data.MaxWidth, 10000)) + Vector2.new(data.Padding * 4, data.Padding * 2)
end
