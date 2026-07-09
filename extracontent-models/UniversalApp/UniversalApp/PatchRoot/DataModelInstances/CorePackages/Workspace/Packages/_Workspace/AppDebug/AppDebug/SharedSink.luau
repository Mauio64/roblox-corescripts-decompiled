local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 14
	-- upvalues: t1 (copy)
	local t2 = {
		lastContext = nil,
		log = p1
	}

	setmetatable(t2, t1)

	return t2
end
function t1.newSink(p2, p3) -- line: 23
	return {
		maxLevel = p3,
		log = function(p4, p5, p6) -- line: 26
			-- upvalues: p2 (copy)
			if p6 ~= p2.lastContext then
				p2.lastContext = p6
				p2.log(p4, p5, p6)
			end
		end
	}
end

return t1
