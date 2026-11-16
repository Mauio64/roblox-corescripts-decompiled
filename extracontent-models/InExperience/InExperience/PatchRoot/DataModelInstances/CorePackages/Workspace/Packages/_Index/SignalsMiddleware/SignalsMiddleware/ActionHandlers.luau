local parent = script.Parent.Parent
local SignalsExperimental = require(parent.SignalsExperimental)
local ActionHandlers = {}

function ActionHandlers.create()
	return {}
end

function ActionHandlers.register(p, p2: string, callback)
	if not p[p2] then
		p[p2] = {}
	end

	table.insert(p[p2], callback)
end

function ActionHandlers.handleAction(p, p2)
	local v = p[p2.type]

	if v and #v > 0 then
		SignalsExperimental.batch(function()
			for _, v2 in v do
				v2(p2)
			end
		end)
	end
end

return ActionHandlers
