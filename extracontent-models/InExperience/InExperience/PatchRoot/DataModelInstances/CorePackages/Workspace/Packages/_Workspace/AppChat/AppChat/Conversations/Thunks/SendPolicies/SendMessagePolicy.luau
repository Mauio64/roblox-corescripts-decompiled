local Parent = script:FindFirstAncestor("AppChat").Parent
local Promise = require(Parent.Promise)
local t1 = {}

t1.__index = t1

function t1.onBeforeSendingMessage(_, _) -- line: 9
end
function t1.sendMessage(_, _) -- line: 11
	-- upvalues: Promise (copy)
	return Promise.reject("Not implemented")
end
function t1.onSuccess(_, _, p7) -- line: 15
	return p7
end
function t1.onFailure(_, _, p10) -- line: 19
	return p10
end

return t1
