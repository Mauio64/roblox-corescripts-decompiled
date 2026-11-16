local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

return React.createContext({ menuIconRef = nil, replacesAgeRating = false })
