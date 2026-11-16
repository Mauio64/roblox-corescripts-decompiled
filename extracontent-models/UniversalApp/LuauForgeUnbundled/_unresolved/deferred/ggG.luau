local CorePackages = game:GetService("CorePackages")

local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Roact = require(CorePackages.Packages.Roact)

return (Roact.createContext(RoactGamepad.createRefCache()))
