require(script.Parent.types)

local function createSignal()
	local v = {}
	local v2 = {}

	local v3 = false

	local function fire(p)
		v3 = true

		for k, v4 in v do
			if not (v4.unsubscribed or v2[k]) then
				k(p)
			end
		end

		v3 = false

		for k, v4 in v2 do
			v[k] = v4
		end

		table.clear(v2)
	end

	return {
		subscribe = function(_, callback)
			local v4 = { callback = callback, unsubscribed = false }

			if v3 and not v[callback] then
				v2[callback] = v4
			else
				v[callback] = v4
			end

			return {
				unsubscribe = function(_)
					v4.unsubscribed = true
					v[callback] = nil
					v2[callback] = nil
				end
			}
		end
	}, fire
end

return createSignal
