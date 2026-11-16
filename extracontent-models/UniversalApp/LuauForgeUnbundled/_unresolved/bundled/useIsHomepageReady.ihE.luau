local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local default = require("@luauforge/bundled/cyM").AppStartupSequence.default
local defineFastInt = game:DefineFastInt("HomepageReadyFailsafeTimeoutSeconds", 20)
local axPrefetchMarketplaceIXP = require("@luauforge/bundled/gNE").AXPrefetchMarketplaceIXP
local module = require("@luauforge/bundled/dMB")

local function useIsHomepageReady()
	local state, setState = React.useState(default.isInteractive)
	local state2, setState2 = React.useState(false)
	local v5

	if axPrefetchMarketplaceIXP.isEnabled() then
		v5 = module.readTestVariable(axPrefetchMarketplaceIXP.EnabledForUser)
	else
		v5 = nil
	end

	React.useEffect(function()
		if not v5 then
			return
		end

		setState(default.isInteractive)

		if state then
			return function() end
		end

		local changedConnection = default.changed:connect(function()
			setState(default.isInteractive)
		end)
		return function()
			changedConnection:disconnect()
		end
	end, { state, v5 })

	React.useEffect(function()
		if not v5 then
			return
		end

		if state then
			return function() end
		end

		local thread = task.delay(defineFastInt, function()
			setState2(true)
		end)

		return function()
			task.cancel(thread)
		end
	end, { state, v5 })

	return state or state2
end

return useIsHomepageReady
