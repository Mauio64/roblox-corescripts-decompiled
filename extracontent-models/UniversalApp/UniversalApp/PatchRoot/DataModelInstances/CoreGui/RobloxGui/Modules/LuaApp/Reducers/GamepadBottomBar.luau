local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local SetBoundInputs = require(Modules.LuaApp.Actions.SetBoundInputs)
local MaybeClearBoundInputs = require(Modules.LuaApp.Actions.MaybeClearBoundInputs)
local t1 = {
	focusController = nil,
	boundInputs = {}
}

return Rodux.createReducer(t1, {
	[SetBoundInputs.name] = function(_: {[any]: any}, p1) -- line: 18
		return {
			boundInputs = p1.boundInputs or {},
			focusController = p1.focusController
		}
	end,
	[MaybeClearBoundInputs.name] = function(p2, p3) -- line: 24
		if p2.focusController ~= p3.focusController then
			return p2
		end

		return {
			focusController = nil,
			boundInputs = {}
		}
	end
})
