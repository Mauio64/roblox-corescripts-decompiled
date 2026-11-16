local MemStorageService = game:GetService("MemStorageService")
local HttpService = game:GetService("HttpService")

return function(p2)
	local v5 = {
		persist = function(p3, p4)
			local success, result = pcall(function()
				MemStorageService:SetItem(p2.storeKey, HttpService:JSONEncode(p4))
			end)

			if not success then
				print("PersistenceMiddleware - failed to update the store", p2.storeKey)
			end

			return success
		end,
		restore = function()
			local success, result = pcall(function()
				local item = MemStorageService:GetItem(p2.storeKey)

				if item and item ~= "" then
					return HttpService:JSONDecode(item)
				end

				return nil
			end)

			if success then
				return result
			end

			return nil
		end,
		clean = function()
			local success, result = pcall(function()
				MemStorageService:SetItem(p2.storeKey, "")
			end)

			if not success then
				print("PersistenceMiddleware - failed to clean the store", p2.storeKey)
			end

			return success
		end
	}

	function v5.getMiddleware(p3)
		return function(callback, p4)
			p4.changed:connect(function(p5, p6)
				v5.persist(p4, p5)
			end)
			return function(p5)
				return callback(p5)
			end
		end
	end

	return v5
end
