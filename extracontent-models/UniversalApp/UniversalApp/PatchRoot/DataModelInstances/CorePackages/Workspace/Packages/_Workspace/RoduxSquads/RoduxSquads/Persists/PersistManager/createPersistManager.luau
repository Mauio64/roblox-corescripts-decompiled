local RoduxSquads = script:FindFirstAncestor("RoduxSquads")

require(RoduxSquads.Persists.PersistManager.createInternalPersistManager)

local createPause = require(RoduxSquads.Persists.Actions).createPause
local createPersistAndUpdateState = require(RoduxSquads.Persists.Actions).createPersistAndUpdateState

return function(p1, p2) -- line: 15
	-- upvalues: createPersistAndUpdateState (copy), createPause (copy)
	if not p2 then
		return nil
	end

	return {
		reset = function() -- line: 21
			-- upvalues: p2 (copy)
			p2.update(nil)
		end,
		persistAndUpdateState = function(p3) -- line: 25
			-- upvalues: createPersistAndUpdateState (copy), p1 (copy)
			local v7 = createPersistAndUpdateState(p1)

			if v7 then
				p3(v7())
			end
		end,
		pause = function(p4) -- line: 32
			-- upvalues: createPause (copy), p1 (copy)
			local v9 = createPause(p1)

			if v9 then
				p4(v9())
			end
		end
	}
end
