local CorePackages = game:GetService("CorePackages")
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

return (require(CorePackages.Packages.Roact).createContext(RoactGamepad.createRefCache()))
