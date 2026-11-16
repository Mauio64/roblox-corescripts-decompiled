local Navigation = require("@game/CorePackages/Workspace/Packages/Navigation")
local module2 = require("@luauforge/bundled/dCu")
local module3 = require("@luauforge/bundled/dCv")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives
local v5

if SharedFlags.FFlagSignalsNavProjected then
	v5 = Navigation.createProjectedNavigationObject(module3.router)
else
	v5 = Navigation.createSignalsNavigationObject(module3.router)
end

if fFlagSignalsNavP2NavigationPrimitives then
	module2.AppNavigationRegistry.register(v5)
end

return v5
