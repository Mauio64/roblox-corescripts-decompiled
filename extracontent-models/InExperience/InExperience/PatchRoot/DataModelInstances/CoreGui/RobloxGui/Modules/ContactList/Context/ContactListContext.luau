local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)

return require(CorePackages.Packages.React).createContext({
	fireAnalyticsEvent = Dash.noop
})
