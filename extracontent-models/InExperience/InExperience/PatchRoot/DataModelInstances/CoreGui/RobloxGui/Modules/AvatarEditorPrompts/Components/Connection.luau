local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local ContextActionsBinder = require(script.ContextActionsBinder)
local v4 = Roact.PureComponent:extend("Connection")

function v4.render(_) -- line: 9
	-- upvalues: Roact (copy), ContextActionsBinder (copy)
	return Roact.createFragment({
		ContextActionsBinder = Roact.createElement(ContextActionsBinder)
	})
end

return v4
