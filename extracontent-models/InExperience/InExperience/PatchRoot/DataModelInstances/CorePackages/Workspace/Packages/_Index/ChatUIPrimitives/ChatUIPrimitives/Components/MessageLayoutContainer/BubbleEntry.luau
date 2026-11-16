local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent

local React = require(parent.React)
require(parent.Signals)
require(ChatUIPrimitives.Types)

local function BubbleEntry(_): nil
	return nil
end

return React.memo(BubbleEntry)
