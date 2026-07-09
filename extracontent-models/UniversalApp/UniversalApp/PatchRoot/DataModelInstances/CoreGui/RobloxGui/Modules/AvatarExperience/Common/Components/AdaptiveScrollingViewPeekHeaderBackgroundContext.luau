local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local t1 = {
	onPeekHeaderBackgroundActiveChanged = nil
}

return (React.createContext(t1))
