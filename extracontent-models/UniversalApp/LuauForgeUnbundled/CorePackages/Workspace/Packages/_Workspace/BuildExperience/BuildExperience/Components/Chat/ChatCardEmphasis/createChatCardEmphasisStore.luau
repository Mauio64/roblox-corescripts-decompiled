local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/ChatCardEmphasisPositionContext")

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
	local signal, v5 = Signals.createSignal({})

	return {
		register = function(p2, p3, p4, p5)
			local v6 = {
				priority = p3,
				order = p4,
				position = p5 or { messageOrder = p4, segmentOrder = 0, childOrder = 0 }
			}

			v5(function(p6)
				local clone = table.clone(p6)
				clone[p2] = v6
				return clone
			end)
		end,
		unregister = function(p2)
			v5(function(p3)
				if p3[p2] == nil then
					return p3
				end

				local clone = table.clone(p3)
				clone[p2] = nil
				return clone
			end)
		end,
		getEmphasizedKey = Signals.createComputed(function(p2)
			local v6 = nil
			local v7 = nil

			for k, v8 in signal(p2) do
				if not (v6 == nil or outranks(v8, v6)) then
					continue
				end

				v7 = k
				v6 = v8
			end

			return v7
		end)
	}
end

return createChatCardEmphasisStore
