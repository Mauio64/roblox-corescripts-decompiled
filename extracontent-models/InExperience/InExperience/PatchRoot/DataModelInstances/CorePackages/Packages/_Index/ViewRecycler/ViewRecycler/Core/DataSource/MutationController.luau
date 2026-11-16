local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

require(ViewRecycler.Core.Types)
local createEvent = require(ViewRecycler.Internal.createEvent)

local function createMutationController(callback, callback2, callback3, callback4)
	local event = createEvent()
	local v = 0
	local v2 = {}
	local v3 = nil

	local function flush()
		local previousItemCount = v3
		local changes = v2
		v2 = {}
		v3 = nil
		event.fire({
			changes = changes,
			previousItemCount = previousItemCount,
			itemCount = callback()
		})
	end

	local function queueChanges(items, p: number) -- 2 equivalent calls inferred from this helper
		if #v2 == 0 then
			v3 = p
		end

		for _, item in items do
			table.insert(v2, item)
		end
	end

	local function emitMany(items, p: number)
		queueChanges(items, p) -- inferred equivalent call

		if v == 0 then
			flush()
		end
	end

	local function emit(p, p2: number)
		queueChanges({ p }, p2) -- inferred equivalent call

		if v == 0 then
			flush()
		end
	end

	local function transaction(callback5)
		local v4 = callback2()
		local clone = table.clone(v2)
		local v5 = v3
		v += 1
		local v6 = table.pack(pcall(function(): boolean
			callback5()
			return true
		end))

		v -= 1

		if not v6[1] then
			callback3(v4)
			v2 = clone
			v3 = v5
			error(v6[2], 0)
		end

		if callback4 ~= nil then
			callback4(v4)
		end

		if v == 0 and #v2 > 0 then
			flush()
		end
	end

	return {
		subscribe = event.connect,
		emit = emit,
		emitMany = emitMany,
		transaction = transaction
	}
end

return createMutationController
