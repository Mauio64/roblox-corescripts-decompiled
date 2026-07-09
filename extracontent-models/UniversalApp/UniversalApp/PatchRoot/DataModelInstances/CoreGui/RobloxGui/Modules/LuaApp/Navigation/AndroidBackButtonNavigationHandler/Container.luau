local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local mapStateToProps = require(script.Parent.mapStateToProps)
local mapDispatchToProps = require(script.Parent.mapDispatchToProps)
local AndroidBackButtonNavigationHandler = require(script.Parent.AndroidBackButtonNavigationHandler)
local FFlagSignalsNavP3hMisc = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3hMisc
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v10 = if not FFlagSignalsNavP3hMisc then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local v11 = RoactRodux.connect((if not FFlagSignalsNavP3hMisc then mapStateToProps else nil), mapDispatchToProps)(AndroidBackButtonNavigationHandler)

if FFlagSignalsNavP3hMisc then
	local v12 = v11

	function v11(p1) -- line: 24
		-- upvalues: v10 (copy), useSignalState (copy), React (copy), v12 (copy), Cryo (copy)
		local v14 = v10(false)
		local v15 = useSignalState(v14.getCurrentLegacyRoute)

		return React.createElement(v12, Cryo.Dictionary.union(p1, {
			canGoBackInAppRoute = #v15 > 1
		}))
	end
end

return v11
