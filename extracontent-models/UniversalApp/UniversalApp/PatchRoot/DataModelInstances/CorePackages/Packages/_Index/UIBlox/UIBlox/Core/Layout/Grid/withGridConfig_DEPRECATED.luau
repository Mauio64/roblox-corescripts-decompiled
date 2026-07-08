local scriptParent = script.Parent
local Responsive = scriptParent.Parent.Responsive
local ParentParent = scriptParent.Parent.Parent.Parent.Parent
local Roact = require(ParentParent.Roact)
local ResponsiveLayoutContext = require(Responsive.ResponsiveLayoutContext)
local ResponsiveLayoutConfigReader = require(Responsive.ResponsiveLayoutConfigReader)

return function(p1, p2) -- line: 27
	-- upvalues: Roact (copy), ResponsiveLayoutContext (copy), ResponsiveLayoutConfigReader (copy)
	return function(p3) -- line: 28
		-- upvalues: Roact (copy), ResponsiveLayoutContext (copy), p1 (copy), ResponsiveLayoutConfigReader (copy), p2 (copy)
		return Roact.createElement(ResponsiveLayoutContext.Consumer, {
			render = function(p4) -- line: 30
				-- upvalues: p1 (copy), ResponsiveLayoutConfigReader (copy), p2 (copy), p3 (copy)
				local t1 = {}

				for k, v in pairs(p1) do
					t1[k] = ResponsiveLayoutConfigReader.getValue({
						config = p4.config,
						breakpoint = p4.breakpoint,
						kind = p2 or p4.kind
					}, k)

					if t1[k] == nil then
						t1[k] = v
					end
				end

				return p3(t1)
			end
		})
	end
end
