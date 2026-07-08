local ParentParent = script:FindFirstAncestor("Components").Parent.Parent
local InlineLayoutElements = script:FindFirstAncestor("InlineLayoutElements")
local Dash = require(ParentParent.Dash)
local Foundation = require(ParentParent.Foundation)
local BaseTextElement = require(InlineLayoutElements.BaseTextElement)
local FoundationText = Foundation.Text
local t1 = {}

function mapProps(p1) -- line: 17
	-- upvalues: Dash (copy)
	return Dash.omit(p1, {
		"id",
		"EngineTags"
	})
end
function t1.new(p2) -- line: 21
	-- upvalues: BaseTextElement (copy), FoundationText (copy)
	return BaseTextElement.new(FoundationText, p2, mapProps)
end

return t1
