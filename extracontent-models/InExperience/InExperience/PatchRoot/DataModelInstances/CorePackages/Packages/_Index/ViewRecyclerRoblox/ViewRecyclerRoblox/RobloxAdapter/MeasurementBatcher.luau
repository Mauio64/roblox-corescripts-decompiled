local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
require(ViewRecyclerRoblox.Parent.ViewRecycler)

return {
	new = function(callback, callback2)
		local v = callback2 or task.defer
		local v2 = nil
		local v3 = true

		local function cancelPending() -- 1 equivalent call inferred from this helper
			v2 = nil
		end

		return {
			add = function(p)
				if not v3 then
					return
				end

				local v4 = v2

				if v4 == nil then
					v4 = {}
					v2 = v4
					v(function()
						if v3 and v2 == v4 then
							v2 = nil
							callback(v4)
						end
					end)
				end

				table.insert(v4, p)
			end,
			flush = function()
				local v4 = v2

				if not v3 or v4 == nil then
					return nil
				end

				v2 = nil
				callback(v4)
				return v4
			end,
			cancelPending = cancelPending,
			destroy = function()
				v3 = false
				cancelPending() -- inferred equivalent call
			end
		}
	end
}
