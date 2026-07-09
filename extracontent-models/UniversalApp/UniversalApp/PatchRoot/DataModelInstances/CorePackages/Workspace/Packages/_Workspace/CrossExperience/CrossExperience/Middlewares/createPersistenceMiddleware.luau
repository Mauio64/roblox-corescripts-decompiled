local MemStorageService = game:GetService("MemStorageService")
local HttpService = game:GetService("HttpService")

return function(t1: {[any]: any}) -- line: 8
	-- upvalues: MemStorageService (copy), HttpService (copy)
	local t2 = {
		persist = function(_, p2) -- line: 10
			-- upvalues: MemStorageService (copy), t1 (copy), HttpService (copy)
			local ok, _ = pcall(function() -- line: 11
				-- upvalues: MemStorageService (copy), t1 (copy), HttpService (copy), p2 (copy)
				MemStorageService:SetItem(t1.storeKey, HttpService:JSONEncode(p2))
			end)

			if not ok then
				print("PersistenceMiddleware - failed to update the store", t1.storeKey)
			end

			return ok
		end,
		restore = function() -- line: 19
			-- upvalues: MemStorageService (copy), t1 (copy), HttpService (copy)
			local ok, result = pcall(function() -- line: 20
				-- upvalues: MemStorageService (copy), t1 (copy), HttpService (copy)
				local Item = MemStorageService:GetItem(t1.storeKey)

				if Item and Item ~= "" then
					return HttpService:JSONDecode(Item)
				end

				return nil
			end)

			if ok then
				return result
			end

			return nil
		end,
		clean = function() -- line: 32
			-- upvalues: MemStorageService (copy), t1 (copy)
			local ok, _ = pcall(function() -- line: 33
				-- upvalues: MemStorageService (copy), t1 (copy)
				MemStorageService:SetItem(t1.storeKey, "")
			end)

			if not ok then
				print("PersistenceMiddleware - failed to clean the store", t1.storeKey)
			end

			return ok
		end
	}

	function t2.getMiddleware(_: {[any]: any}) -- line: 43
		-- upvalues: t2 (copy)
		return function(p3, p4) -- line: 44
			-- upvalues: t2 (copy)
			p4.changed:connect(function(p5, _) -- line: 47
				-- upvalues: t2 (copy), p4 (copy)
				t2.persist(p4, p5)
			end)

			return function(p7) -- line: 50
				-- upvalues: p3 (copy)
				return p3(p7)
			end
		end
	end

	return t2
end
