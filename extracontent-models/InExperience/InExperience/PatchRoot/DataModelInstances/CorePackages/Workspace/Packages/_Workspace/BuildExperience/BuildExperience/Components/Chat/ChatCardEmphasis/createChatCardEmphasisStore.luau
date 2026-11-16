local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)
require(script.Parent.ChatCardEmphasisPositionContext)

local function outranks(data, data2): boolean
	if data.priority ~= data2.priority then
		return data.priority > data2.priority
	end

	local position = data.position
	local position2 = data2.position

	if position == nil or position2 == nil then
		return data.order > data2.order
	end

	if position.messageOrder ~= position2.messageOrder then
		return position.messageOrder > position2.messageOrder
	end

	if position.segmentOrder == position2.segmentOrder then
		return position.childOrder > position2.childOrder
	end

	return position.segmentOrder > position2.segmentOrder
end

local function createChatCardEmphasisStore()
	local signal, v = Signals.createSignal({})

	return {
		register = function(p, priority: number, p2: number, p3)
			local v2 = {
				priority = priority,
				order = p2,
				position = p3 or { messageOrder = p2, segmentOrder = 0, childOrder = 0 }
			}

			v(function(p4)
				local clone = table.clone(p4)
				clone[p] = v2
				return clone
			end)
		end,
		unregister = function(p)
			v(function(p2)
				if p2[p] == nil then
					return p2
				end

				local clone = table.clone(p2)
				clone[p] = nil
				return clone
			end)
		end,
		getEmphasizedKey = Signals.createComputed(function(p)
			local v2 = nil
			local v3 = nil

			for k, v4 in signal(p) do
				if not (v2 == nil or outranks(v4, v2)) then
					continue
				end

				v3 = k
				v2 = v4
			end

			return v3
		end)
	}
end

return createChatCardEmphasisStore
