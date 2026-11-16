local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Cryo")

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createModeratedItemsStore()
	local signal, v5 = createSignal({})
	local v6 = {}

	local function getIsModerated(p2)
		if v6[p2] == nil then
			v6[p2] = createComputed(function(p3): boolean
				return table.find(signal(p3), p2) ~= nil
			end)
		end

		return v6[p2]
	end

	local function markReported(p2)
		local v7 = signal(false)

		if not table.find(v7, p2) then
			v5(Cryo.List.join(v7, { p2 }))
		end
	end

	local function addModeratedItems(items)
		local v7 = signal(false)
		local v8 = {}

		for k, item in items do
			if not table.find(v7, item) then
				table.insert(v8, item)
			end
		end

		if #v8 > 0 then
			v5(Cryo.List.join(v7, v8))
		end
	end

	return {
		getItems = signal,
		getIsModerated = getIsModerated,
		markReported = markReported,
		addModeratedItems = addModeratedItems
	}
end

return createModeratedItemsStore
