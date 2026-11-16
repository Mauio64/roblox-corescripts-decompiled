local Types = require(script.Parent.Types)
local MessageContracts = {}

function MessageContracts.isValidMessage(p): boolean
	return Types.isValidMessage(p) == true
end

function MessageContracts.isValidMessageDraft(p): boolean
	return Types.isValidMessageDraft(p) == true
end

return MessageContracts
