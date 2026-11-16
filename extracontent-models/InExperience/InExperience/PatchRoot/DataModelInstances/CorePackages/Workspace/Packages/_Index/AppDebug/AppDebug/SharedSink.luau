local SharedSink = {}
SharedSink.__index = SharedSink

function SharedSink.new(log)
	local v = { log = log, lastContext = nil }

	setmetatable(v, SharedSink)
	return v
end

function SharedSink:newSink(maxLevel)
	return {
		maxLevel = maxLevel,
		log = function(p, p2, lastContext)
			if lastContext ~= self.lastContext then
				self.lastContext = lastContext
				self.log(p, p2, lastContext)
			end
		end
	}
end

return SharedSink
