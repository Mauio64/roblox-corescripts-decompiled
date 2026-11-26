local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Cryo")

local createSignal = Signals.createSignal

local function createDeletedMomentsStore()
	local signal, v5 = createSignal({})

	local function markDeleted(p2)
		local v6 = signal(false)

		if not table.find(v6, p2) then
			v5(Cryo.List.join(v6, { p2 }))
		end
	end

	return { getDeletedIds = signal, markDeleted = markDeleted }
end

return createDeletedMomentsStore
