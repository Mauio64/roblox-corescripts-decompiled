local Parent = script:FindFirstAncestor("ExpChat").Parent
local Promise = require(Parent.Promise)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 7
	-- upvalues: t1 (copy)
	return (setmetatable({
		goalTime = p1
	}, t1))
end
function t1.start(p2) -- line: 15
	-- upvalues: Promise (copy)
	p2:stop()
	p2.promise = Promise.delay(p2.goalTime)

	return p2.promise
end
function t1.stop(p3) -- line: 24
	if p3.promise then
		p3.promise:cancel()
	end
end

return t1
