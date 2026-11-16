local v = {}

local parent = script.Parent

local class = {}
class.__index = class

function class.SendMessage(p, p2, p3)
	p.SayMessageRequest:FireServer(p2, p3)
end

function class:RegisterSayMessageFunction(sayMessageRequest)
	self.SayMessageRequest = sayMessageRequest
end

function v.new()
	local self = setmetatable({}, class)
	self.SayMessageRequest = nil

	return self
end

return v.new()
