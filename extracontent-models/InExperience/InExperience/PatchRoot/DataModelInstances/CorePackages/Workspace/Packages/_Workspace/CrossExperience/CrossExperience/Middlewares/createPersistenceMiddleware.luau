local MemStorageService = game:GetService("MemStorageService")
local HttpService = game:GetService("HttpService")

return function(p)
	local v = {
		persist = function(_, p2)
			local success, _ = pcall(function()
				MemStorageService:SetItem(p.storeKey, HttpService:JSONEncode(p2))
			end)

			if not success then
				print("PersistenceMiddleware - failed to update the store", p.storeKey)
			end

			return success
		end,
		restore = function()
			local success, result = pcall(function()
				local item = MemStorageService:GetItem(p.storeKey)

				if item and item ~= "" then
					return HttpService:JSONDecode(item)
				end

				return nil
			end)
			return if success then result else nil
		end,
		clean = function()
			local success, _ = pcall(function()
				MemStorageService:SetItem(p.storeKey, "")
			end)

			if not success then
				print("PersistenceMiddleware - failed to clean the store", p.storeKey)
			end

			return success
		end
	}

	function v.getMiddleware(_)
		return function(callback, p2)
			p2.changed:connect(function(p3, _)
				v.persist(p2, p3)
			end)
			return function(p3)
				return callback(p3)
			end
		end
	end

	return v
end
