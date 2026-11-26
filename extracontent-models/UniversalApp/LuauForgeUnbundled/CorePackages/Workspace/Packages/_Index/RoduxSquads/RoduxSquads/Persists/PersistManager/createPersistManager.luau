require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Persists/PersistManager/createInternalPersistManager")

local createPause = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Persists/Actions").createPause
local createPersistAndUpdateState = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Persists/Actions").createPersistAndUpdateState

return function(p2, p3)
	if p3 then
		return {
			reset = function()
				p3.update(nil)
			end,
			persistAndUpdateState = function(callback)
				local persistAndUpdateState = createPersistAndUpdateState(p2)

				if persistAndUpdateState then
					callback(persistAndUpdateState())
				end
			end,
			pause = function(callback)
				local pause = createPause(p2)

				if pause then
					callback(pause())
				end
			end
		}
	end

	return nil
end
