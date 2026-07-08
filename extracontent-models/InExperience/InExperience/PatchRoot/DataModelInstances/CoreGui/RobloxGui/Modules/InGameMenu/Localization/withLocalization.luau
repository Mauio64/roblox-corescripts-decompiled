local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local LocalizationConsumer = require(script.Parent.LocalizationConsumer)

local function withLocalization(p1) -- line: 9
	-- upvalues: t (copy), Roact (copy), LocalizationConsumer (copy)
	assert(t.table(p1))

	return function(p2) -- line: 12
		-- upvalues: t (copy), Roact (copy), LocalizationConsumer (copy), p1 (copy)
		assert(t.callback(p2))

		return Roact.createElement(LocalizationConsumer, {
			render = p2,
			stringsToBeLocalized = p1
		})
	end
end

return withLocalization
