local Rodux = require(script.Parent.Rodux)
local Cryo = require(script.Parent.Parent.Cryo)
local buildActionName = require(script.Parent.buildActionName)

return function(p)
	return function()
		return Rodux.createReducer({}, {
			[buildActionName(p)] = function(p2, data)
				local statuses = {}

				if #data.ids == 0 then
					statuses[data.keymapper()] = data.status
				else
					for _, id in ipairs(data.ids) do
						statuses[data.keymapper(id)] = data.status
					end
				end

				return Cryo.Dictionary.join(p2, statuses)
			end
		})
	end
end
