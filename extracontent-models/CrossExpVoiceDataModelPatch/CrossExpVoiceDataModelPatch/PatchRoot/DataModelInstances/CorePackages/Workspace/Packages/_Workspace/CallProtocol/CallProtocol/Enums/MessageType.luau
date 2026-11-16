local parent = script:FindFirstAncestor("CallProtocol").Parent

local enumerate = require(parent.enumerate)

return enumerate(script.Name, { CallError = "CallError" })
