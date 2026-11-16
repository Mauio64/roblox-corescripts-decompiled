local count = 0

local function generatedKey() -- 1 equivalent call inferred from this helper
	count += 1
	return `view-recycler:{count}`
end

local function createItemKeyRegistry(callback, p: string)
	local v = {}
	local formatted = `{p}: keys must be strings`
	local formatted2 = `{p}: setItem must preserve the existing key`

	local function resolve(p2, p3: number) -- 4 equivalent calls inferred from this helper
		local v2

		if callback == nil then
			v2 = generatedKey() -- inferred equivalent call
		else
			v2 = callback(p2, p3)
		end

		assert(type(v2) == "string", formatted)
		return v2
	end

	return {
		claim = function(p2, p3: number)
			local v2 = resolve(p2, p3) -- inferred equivalent call

			if v[v2] ~= nil then
				assert(false, `{p}: duplicate key "{v2}"`)
			end

			v[v2] = true
			return v2
		end,
		assertPreserved = function(p2, p3, p4)
			if callback ~= nil then
				assert(resolve(p3, p4) == p2, formatted2) -- inferred equivalent call
			end
		end,
		release = function(p2)
			if v[p2] == nil then
				assert(false, `{p}: cannot release missing key "{p2}"`)
			end

			v[p2] = nil
		end,
		adopt = function(p2)
			v[p2] = true
		end,
		replace = function(p2: string, p3, p4: number)
			local v2 = resolve(p3, p4) -- inferred equivalent call

			if v[p2] == nil then
				assert(false, `{p}: cannot replace missing key "{p2}"`)
			end

			if v2 ~= p2 and v[v2] ~= nil then
				assert(false, `{p}: duplicate key "{v2}"`)
			end

			if v2 ~= p2 then
				v[p2] = nil
				v[v2] = true
			end

			return v2
		end,
		rebuild = function(list)
			local result = table.create(#list)
			local set = {}

			for k, item in list do
				local v2 = resolve(item, k) -- inferred equivalent call

				if set[v2] ~= nil then
					assert(false, `{p}: duplicate key "{v2}"`)
				end

				result[k] = v2
				set[v2] = true
			end

			v = set
			return result
		end,
		clear = function()
			v = {}
		end,
		snapshot = function()
			return table.clone(v)
		end,
		restore = function(p2)
			v = table.clone(p2)
		end
	}
end

return { create = createItemKeyRegistry, generatedKey = generatedKey }
