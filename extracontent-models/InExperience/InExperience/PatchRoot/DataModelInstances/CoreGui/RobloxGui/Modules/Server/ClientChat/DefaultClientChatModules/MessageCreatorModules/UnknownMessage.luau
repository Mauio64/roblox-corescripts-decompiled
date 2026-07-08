local ParentParent = script.Parent.Parent

require(ParentParent:WaitForChild("ChatSettings"))

local Util = require(script.Parent:WaitForChild("Util"))

function CreateUnknownMessageLabel(p1) -- line: 13
	print("No message creator for message: " .. p1.Message)
end

return {
	[Util.KEY_MESSAGE_TYPE] = "UnknownMessage",
	[Util.KEY_CREATOR_FUNCTION] = CreateUnknownMessageLabel
}
