local RoduxSquads = script:FindFirstAncestor("RoduxSquads")

require(RoduxSquads.Persists.PersistManager.createInternalPersistManager)

local Actions = require(RoduxSquads.Persists.Actions)
local createPause = Actions.createPause
local Actions2 = require(RoduxSquads.Persists.Actions)
local createPersistAndUpdateState = Actions2.createPersistAndUpdateState

return function(p, p2)
	if p2 then
		return {
			reset = function()
				p2.update(nil)
			end,
			persistAndUpdateState = function(callback)
				local persistAndUpdateState = createPersistAndUpdateState(p)

				if persistAndUpdateState then
					callback(persistAndUpdateState())
				end
			end,
			pause = function(callback)
				local pause = createPause(p)

				if pause then
					callback(pause())
				end
			end
		}
	end

	return nil
end
