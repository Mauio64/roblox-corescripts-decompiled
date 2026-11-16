local parent = script:FindFirstAncestor("AppChat").Parent

local Promise = require(parent.Promise)

local SendMessagePolicy = {}
SendMessagePolicy.__index = SendMessagePolicy

function SendMessagePolicy.onBeforeSendingMessage(_, _) end

function SendMessagePolicy.sendMessage(_, _)
	return Promise.reject("Not implemented")
end

function SendMessagePolicy.onSuccess(_, _, p)
	return p
end

function SendMessagePolicy.onFailure(_, _, p)
	return p
end

return SendMessagePolicy
