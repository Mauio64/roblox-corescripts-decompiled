local parent = script:FindFirstAncestor("Markdown").Parent
local CommonMark = require(parent.CommonMark)

local function Mention(id: string, name: string?)
	local mention = CommonMark.Node.CustomNode.new("Mention")
	mention.id = id
	mention.name = name
	return mention
end

return Mention
