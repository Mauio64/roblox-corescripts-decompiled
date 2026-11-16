local RoduxSquads = script:FindFirstAncestor("RoduxSquads")
local parent = RoduxSquads.Parent
local Rodux = require(parent.Rodux)
local PersistManager = require(RoduxSquads.Persists.PersistManager)
local createInternalPersistManager = PersistManager.createInternalPersistManager
local PersistManager2 = require(RoduxSquads.Persists.PersistManager)
local createPersistManager = PersistManager2.createPersistManager
local Actions = require(RoduxSquads.Persists.Actions)
local createPause = Actions.createPause
local Actions2 = require(RoduxSquads.Persists.Actions)
local createPersistAndUpdateState = Actions2.createPersistAndUpdateState

local v = { isPaused = false }

return function(p, callback)
	local v2 = false
	local pause = createPause(p)
	local persistAndUpdateState = createPersistAndUpdateState(p)

	local internalPersistManager = createInternalPersistManager(p)
	local persistManager = createPersistManager(p, internalPersistManager)

	local isPaused = v.isPaused

	local v3 = nil

	if internalPersistManager then
		internalPersistManager.bindToStorage(function(p2)
			v3 = p2
		end)
		v3 = internalPersistManager.get()
	end

	local function fn(p2, p3)
		p2 = internalPersistManager and not v2 and v3 or p2
		v2 = true

		if persistAndUpdateState.name == p3.type then
			return v3
		end

		local v4

		if isPaused then
			return p2
		end

		v4 = callback(p2, p3)

		if internalPersistManager and v4 ~= p2 then
			internalPersistManager.update(v4)
		end

		return v4
	end

	return fn, Rodux.createReducer(v, {
		[persistAndUpdateState.name] = function(_, _)
			isPaused = false
			return { isPaused = isPaused }
		end,
		[pause.name] = function(_, _)
			isPaused = true
			return { isPaused = isPaused }
		end
	}), persistManager
end
