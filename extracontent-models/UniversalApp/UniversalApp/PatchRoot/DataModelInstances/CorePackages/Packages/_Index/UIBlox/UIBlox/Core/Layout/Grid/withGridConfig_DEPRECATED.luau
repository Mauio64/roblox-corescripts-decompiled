local parent = script.Parent
local responsive = parent.Parent.Responsive
local parent2 = parent.Parent.Parent.Parent.Parent

local Roact = require(parent2.Roact)

local ResponsiveLayoutContext = require(responsive.ResponsiveLayoutContext)
local ResponsiveLayoutConfigReader = require(responsive.ResponsiveLayoutConfigReader)

return function(items, p)
	return function(callback)
		return Roact.createElement(ResponsiveLayoutContext.Consumer, {
			render = function(data)
				local v = {}

				for k, item in pairs(items) do
					v[k] = ResponsiveLayoutConfigReader.getValue({
						config = data.config,
						breakpoint = data.breakpoint,
						kind = p or data.kind
					}, k)

					if v[k] == nil then
						v[k] = item
					end
				end

				return callback(v)
			end
		})
	end
end
