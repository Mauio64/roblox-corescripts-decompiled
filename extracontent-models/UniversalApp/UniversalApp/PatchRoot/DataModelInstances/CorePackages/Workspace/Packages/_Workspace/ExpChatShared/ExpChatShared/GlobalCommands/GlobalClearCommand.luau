require(script.Parent.types)

local RBXClearCommand = require(script.Parent.Parent.Commands.RBXClearCommand)

return {
	name = script.Name,
	alias = RBXClearCommand.alias,
	clientRun = RBXClearCommand.clientRun
}
