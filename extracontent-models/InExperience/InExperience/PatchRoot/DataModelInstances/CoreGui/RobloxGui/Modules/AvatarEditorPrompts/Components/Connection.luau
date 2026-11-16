local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local ContextActionsBinder = require(script.ContextActionsBinder)

local extended = Roact.PureComponent:extend("Connection")

function extended.render(_)
	return Roact.createFragment({
		ContextActionsBinder = Roact.createElement(ContextActionsBinder)
	})
end

return extended
