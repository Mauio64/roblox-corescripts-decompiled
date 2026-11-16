local parent = script:FindFirstAncestor("Components").Parent.Parent
local InlineLayoutElements = script:FindFirstAncestor("InlineLayoutElements")

local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)

local BaseTextElement = require(InlineLayoutElements.BaseTextElement)
local Text = Foundation.Text

local TextElement = {}

function mapProps(p)
	return Dash.join(Dash.omit(p, { "id", "EngineTags" }), {
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	})
end

function TextElement.new(p)
	return BaseTextElement.new(Text, p, mapProps)
end

return TextElement
