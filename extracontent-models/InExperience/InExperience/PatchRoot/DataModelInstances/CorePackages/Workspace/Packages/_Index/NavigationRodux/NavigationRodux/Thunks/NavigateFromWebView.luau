local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local parent = NavigationRodux.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives
local navigationCommands

if FFlagSignalsNavP2NavigationPrimitives then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local Cryo = require(parent.Cryo)
local ArgCheck = require(parent.ArgCheck)
local RoactNavigation = require(parent.RoactNavigation)

local SetNavigationLocked = require(NavigationRodux.Thunks.SetNavigationLocked)
local RNAdapterThunk = require(NavigationRodux.Thunks.RNAdapterThunk)

return function(p, flag: boolean?)
	ArgCheck.isType(p, "table", "page")
	ArgCheck.isTypeOrNil(flag, "boolean", "bypassNavigationLock")

	if FFlagSignalsNavP2NavigationPrimitives then
		return function()
			navigationCommands.fromWebView(navigationCommands.fromLegacyPage(p), flag)
		end
	end

	return RNAdapterThunk.new("NavigateFromWebView", function(object, callback)
		if object:getState().Navigation.lockNavigationActions and not flag then
			return
		end

		object:dispatch(SetNavigationLocked(true))
		callback(RoactNavigation.StackActions.replace({
			routeName = p.name,
			key = p.key,
			params = Cryo.Dictionary.join(p, { name = Cryo.None, rnKey = Cryo.None })
		}))
	end)
end
