local Rodux = require(script.Parent.Rodux)
local Cryo = require(script.Parent.Parent.Cryo)
local buildActionName = require(script.Parent.buildActionName)

return function(p1) -- line: 11
	-- upvalues: Rodux (copy), buildActionName (copy), Cryo (copy)
	return function() -- line: 12
		-- upvalues: Rodux (copy), buildActionName (copy), p1 (copy), Cryo (copy)
		return Rodux.createReducer({}, {
			[buildActionName(p1)] = function(p2, t1: {[any]: any}) -- line: 14
				-- upvalues: Cryo (copy)
				local t2 = {}

				if #t1.ids == 0 then
					t2[t1.keymapper()] = t1.status
				else
					for _, v in ipairs(t1.ids) do
						t2[t1.keymapper(v)] = t1.status
					end
				end

				return Cryo.Dictionary.join(p2, t2)
			end
		})
	end
end
