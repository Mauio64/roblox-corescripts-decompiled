local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local extended = InGameMenuDependencies.Roact.PureComponent:extend("InitalPage")

function extended.render(_) end

return extended
