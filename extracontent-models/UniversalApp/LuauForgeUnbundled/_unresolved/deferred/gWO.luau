local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local module = require("@luauforge/deferred/gWP")

local module2 = require("@luauforge/deferred/gqf")

local module3 = require("@luauforge/deferred/gmV")

return (require("@luauforge/deferred/gfb")((module3((RoactRodux.connect(function(p2, p3)
	return { searchParameters = p2.SearchesParameters[p3.detail] }
end)(function(p2)
	local detail = p2.detail
	local searchParameters = p2.searchParameters

	return Roact.createFragment({
		SearchPage = Roact.createElement(module, {
			searchUuid = detail,
			searchParameters = searchParameters
		}),
		OnFocusExperimentExposureLogger = Roact.createElement(module2, { ixpTests = {} })
	})
end))))))
