local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/Rodux")
local createInternalPersistManager = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Persists/PersistManager").createInternalPersistManager
local createPersistManager = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Persists/PersistManager").createPersistManager
local createPause = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Persists/Actions").createPause
local createPersistAndUpdateState = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Persists/Actions").createPersistAndUpdateState

local v5 = { isPaused = false }

return function(p2, callback)
	local v6 = false
	local pause = createPause(p2)
	local persistAndUpdateState = createPersistAndUpdateState(p2)

	local internalPersistManager = createInternalPersistManager(p2)
	local persistManager = createPersistManager(p2, internalPersistManager)

	local v7 = v5.isPaused

	local v8 = nil

	if internalPersistManager then
		internalPersistManager.bindToStorage(function(p3)
			v8 = p3
		end)
		v8 = internalPersistManager.get()
	end

	local function fn(p3, p4)
		p3 = internalPersistManager and not v6 and v8 or p3
		v6 = true

		if persistAndUpdateState.name == p4.type then
			return v8
		end

		local v9

		if v7 then
			v9 = p3
		else
			v9 = callback(p3, p4)

			if internalPersistManager and v9 ~= p3 then
				internalPersistManager.update(v9)
			end
		end

		return v9
	end

	return fn, Rodux.createReducer(v5, {
		[persistAndUpdateState.name] = function(p3, p4)
			v7 = false
			return { isPaused = v7 }
		end,
		[pause.name] = function(p3, p4)
			v7 = true
			return { isPaused = v7 }
		end
	}), persistManager
end
