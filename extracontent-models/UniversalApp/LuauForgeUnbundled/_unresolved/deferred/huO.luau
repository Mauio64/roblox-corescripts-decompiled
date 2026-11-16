local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local module = require("@luauforge/deferred/huP")
local module2 = require("@luauforge/deferred/huQ")
local module3 = require("@luauforge/deferred/huR")

local module4 = require("@luauforge/deferred/huT")
local useSignalState

if module4 then
	local SignalsReact = require(CorePackages.Packages.SignalsReact)
	useSignalState = SignalsReact.useSignalState
else
	useSignalState = nil
end

local v5 = if module4 then require("@luauforge/deferred/huU") else nil

local memo = React.memo(function(p2)
	local v6 = v5(false)
	local v7 = useSignalState(v6.getRequest)

	return React.createElement(
		module,
		Cryo.Dictionary.join(p2, v7, {
			completeExternalNavigation = v6.completeExternalNavigation
		})
	)
end)

if module4 then
	return memo
end

return (RoactRodux.connect(module2, module3)(module))
