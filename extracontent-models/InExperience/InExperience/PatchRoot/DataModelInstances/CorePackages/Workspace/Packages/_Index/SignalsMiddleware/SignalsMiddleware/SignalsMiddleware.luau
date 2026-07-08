local ParentParent = script.Parent.Parent
local SignalsExperimental = require(ParentParent.SignalsExperimental)

local function createSignalsMiddleware(t1: {[any]: any}) -- line: 4
	-- upvalues: SignalsExperimental (copy)
	return function(p1, _) -- line: 5
		-- upvalues: t1 (copy), SignalsExperimental (copy)
		return function(p3) -- line: 6
			-- upvalues: t1 (copy), SignalsExperimental (copy), p1 (copy)
			local v8 = t1[p3.type]

			if v8 and #v8 > 0 then
				SignalsExperimental.batch(function() -- line: 10
					-- upvalues: v8 (copy), p3 (copy), p1 (copy)
					local v9 = true

					for _, v11 in v8 do
						v9 = v11(p3) and v9
					end

					if not v9 then
						return p1(p3)
					end

					return nil
				end)

				return nil
			end

			return p1(p3)
		end
	end
end

return createSignalsMiddleware
