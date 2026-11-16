local parent = script.Parent.Parent
require(parent:WaitForChild("ChatSettings"))
local Util = require(script.Parent:WaitForChild("Util"))

function CreateUnknownMessageLabel(p)
	print("No message creator for message: " .. p.Message)
end

return {
	[Util.KEY_MESSAGE_TYPE] = "UnknownMessage",
	[Util.KEY_CREATOR_FUNCTION] = CreateUnknownMessageLabel
}
