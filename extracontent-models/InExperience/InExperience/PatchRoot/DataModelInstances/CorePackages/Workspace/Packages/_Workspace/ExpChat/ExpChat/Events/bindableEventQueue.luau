local ExpChat = script:FindFirstAncestor("ExpChat")
local DispatchBindableEvent = require(ExpChat.DispatchBindableEvent)

local BindableEventQueue = { queue = {} }

function BindableEventQueue.add(p, p2)
	p.queue[#p.queue + 1] = p2
end

function BindableEventQueue.flush(p)
	if #p.queue then
		for _, v in pairs(p.queue) do
			DispatchBindableEvent:Fire(v)
		end
	end
end

return BindableEventQueue
