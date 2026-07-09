local RoduxSquads = script:FindFirstAncestor("RoduxSquads")

require(RoduxSquads.Persists.PersistStorage.PersistStorage)

return function(p1) -- line: 11
	local storage = p1.storage

	if not storage then
		return nil
	end

	return {
		update = function(p2) -- line: 18
			-- upvalues: storage (copy)
			return storage:setItem(p2)
		end,
		get = function() -- line: 22
			-- upvalues: storage (copy)
			return storage:getItem()
		end,
		bindToStorage = function(p3) -- line: 26
			-- upvalues: storage (copy)
			return storage:bindAndFire(p3)
		end
	}
end
