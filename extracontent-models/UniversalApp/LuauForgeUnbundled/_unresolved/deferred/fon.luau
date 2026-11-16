local CorePackages = game:GetService("CorePackages")
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local module = require("@luauforge/deferred/foo")
local module2 = require("@luauforge/deferred/fop")
local module3 = require("@luauforge/deferred/foq")

local fFlagSignalsNavP3aWrapAppPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3aWrapAppPage

local connect = RoactRodux.connect

if fFlagSignalsNavP3aWrapAppPage then
	module = nil
end

return (connect(module, module2)(module3))
