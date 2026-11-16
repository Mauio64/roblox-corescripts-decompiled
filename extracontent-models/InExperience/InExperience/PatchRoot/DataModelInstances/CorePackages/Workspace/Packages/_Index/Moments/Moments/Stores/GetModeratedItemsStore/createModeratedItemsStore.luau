local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)
local Cryo = require(parent.Cryo)

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createModeratedItemsStore()
	local signal, v = createSignal({})
	local v2 = {}

	local function getIsModerated(p: string)
		if v2[p] == nil then
			v2[p] = createComputed(function(p2): boolean
				return table.find(signal(p2), p) ~= nil
			end)
		end

		return v2[p]
	end

	local function markReported(p: string)
		local v3 = signal(false)

		if not table.find(v3, p) then
			v((Cryo.List.join(v3, { p })))
		end
	end

	local function addModeratedItems(items)
		local v3 = signal(false)
		local v4 = {}

		for _, item in items do
			if not table.find(v3, item) then
				table.insert(v4, item)
			end
		end

		if #v4 > 0 then
			v((Cryo.List.join(v3, v4)))
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
