local ExpChat = script:FindFirstAncestor("ExpChat")
local DispatchBindableEvent = require(ExpChat.DispatchBindableEvent)

return {
	queue = {},
	add = function(p1, p2) -- line: 8
		p1.queue[#p1.queue + 1] = p2
	end,
	flush = function(p3) -- line: 12
		-- upvalues: DispatchBindableEvent (copy)
		if #p3.queue then
			for _, v in pairs(p3.queue) do
				DispatchBindableEvent:Fire(v)
			end
		end
	end
}
