local class = {}
class.__index = class

function class.new(p2)
	local v5 = { log = p2, lastContext = nil }

	setmetatable(v5, class)
	return v5
end

function class:newSink(p2)
	return {
		maxLevel = p2,
		log = function(p3, p4, lastContext)
			if lastContext ~= self.lastContext then
				self.lastContext = lastContext
				self.log(p3, p4, lastContext)
			end
		end
	}
end

return class
