local RoduxSquads = script:FindFirstAncestor("RoduxSquads")
local RoduxSquadsParent = RoduxSquads.Parent
local Rodux = require(RoduxSquadsParent.Rodux)
local createInternalPersistManager = require(RoduxSquads.Persists.PersistManager).createInternalPersistManager
local createPersistManager = require(RoduxSquads.Persists.PersistManager).createPersistManager
local createPause = require(RoduxSquads.Persists.Actions).createPause
local createPersistAndUpdateState = require(RoduxSquads.Persists.Actions).createPersistAndUpdateState
local t1 = {
	isPaused = false
}

return function(p1, p2) -- line: 13
	-- upvalues: createPause (copy), createPersistAndUpdateState (copy), createInternalPersistManager (copy), createPersistManager (copy), t1 (copy), Rodux (copy)
	local u11 = false
	local v12 = createPause(p1)
	local v13 = createPersistAndUpdateState(p1)
	local v14 = createInternalPersistManager(p1)
	local v15 = createPersistManager(p1, v14)
	local isPaused = t1.isPaused
	local u17 = nil

	if v14 then
		v14.bindToStorage(function(p3) -- line: 27
			-- upvalues: u17 (ref)
			u17 = p3
		end)
		u17 = v14.get()
	end

	return function(p4, p5) -- line: 33
		-- upvalues: v14 (copy), u11 (ref), u17 (ref), v13 (copy), isPaused (ref), p2 (copy)
		if v14 and not u11 then
			p4 = u17 or p4
		end

		u11 = true

		local v21 = p4

		if v13.name == p5.type then
			return u17
		end

		if not isPaused then
			v21 = p2(p4, p5)

			if v14 and v21 ~= p4 then
				v14.update(v21)
			end
		end

		return v21
	end, Rodux.createReducer(t1, {
		[v13.name] = function(_, _) -- line: 55
			-- upvalues: isPaused (ref)
			isPaused = false

			return {
				isPaused = isPaused
			}
		end,
		[v12.name] = function(_, _) -- line: 59
			-- upvalues: isPaused (ref)
			isPaused = true

			return {
				isPaused = isPaused
			}
		end
	}), v15
end
