local t1 = {}
local _ = script.Parent
local t2 = {}

t2.__index = t2

function t2.SendMessage(p1, p2, p3) -- line: 15
	p1.SayMessageRequest:FireServer(p2, p3)
end
function t2.RegisterSayMessageFunction(p4, p5) -- line: 19
	p4.SayMessageRequest = p5
end
function t1.new() -- line: 26
	-- upvalues: t2 (copy)
	local self = setmetatable({}, t2)

	self.SayMessageRequest = nil

	return self
end

return t1.new()
