local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)
local Cryo = require(parent.Cryo)

local createSignal = Signals.createSignal

local function createDeletedMomentsStore()
	local signal, v = createSignal({})

	local function markDeleted(p: string)
		local v2 = signal(false)

		if not table.find(v2, p) then
			v((Cryo.List.join(v2, { p })))
		end
	end

	return { getDeletedIds = signal, markDeleted = markDeleted }
end

return createDeletedMomentsStore
