local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local ChatUIPrimitivesParent = ChatUIPrimitives.Parent
local React = require(ChatUIPrimitivesParent.React)

require(ChatUIPrimitivesParent.Signals)
require(ChatUIPrimitives.Types)

local function BubbleEntry(_: {[any]: any}) -- line: 19
	return nil
end

return React.memo(BubbleEntry)
