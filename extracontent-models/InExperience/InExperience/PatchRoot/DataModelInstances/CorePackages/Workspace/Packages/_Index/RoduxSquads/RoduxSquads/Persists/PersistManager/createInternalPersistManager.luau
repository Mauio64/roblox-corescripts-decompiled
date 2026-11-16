local RoduxSquads = script:FindFirstAncestor("RoduxSquads")
require(RoduxSquads.Persists.PersistStorage.PersistStorage)

return function(p)
	local storage = p.storage

	if storage then
		return {
			update = function(p2)
				return storage:setItem(p2)
			end,
			get = function()
				return storage:getItem()
			end,
			bindToStorage = function(p2)
				return storage:bindAndFire(p2)
			end
		}
	end

	return nil
end
