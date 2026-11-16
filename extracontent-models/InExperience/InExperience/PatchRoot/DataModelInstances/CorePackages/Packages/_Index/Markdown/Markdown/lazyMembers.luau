local function lazyMembers(p, items)
	local function load(p2: string) -- 1 equivalent call inferred from this helper
		local v = items[p2]()
		rawset(p, p2, v)
		return v
	end

	setmetatable(p, {
		__index = function(_, p2)
			if items[p2] == nil then
				return nil
			end

			return load(p2) -- inferred equivalent call
		end,
		__iter = function(p2)
			for k in items do
				if rawget(p2, k) == nil then
					rawset(p, k, (items[k]()))
				end
			end

			return next, p2
		end
	})
end

return lazyMembers
