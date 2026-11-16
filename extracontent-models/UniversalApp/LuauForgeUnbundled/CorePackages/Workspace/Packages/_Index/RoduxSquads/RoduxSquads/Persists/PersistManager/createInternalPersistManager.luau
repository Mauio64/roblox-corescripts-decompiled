require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Persists/PersistStorage/PersistStorage")

return function(p2)
	local storage = p2.storage

	if storage then
		return {
			update = function(p3)
				return storage:setItem(p3)
			end,
			get = function()
				return storage:getItem()
			end,
			bindToStorage = function(p3)
				return storage:bindAndFire(p3)
			end
		}
	end

	return nil
end
