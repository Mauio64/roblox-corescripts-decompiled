local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v6 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local _NativeHandshakeWrapper = require(script.Parent._NativeHandshakeWrapper)
local v11 = RoactNavigation.withNavigation(_NativeHandshakeWrapper)

return (RoactRodux.connect(function(_, _) -- line: 48
	return {}
end, function(p3) -- line: 50
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v6 (copy), NavigateBack (copy), SetCurrentToastMessage (copy), ToastType (copy)
	return {
		navigateBack = function() -- line: 52
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v6 (copy), p3 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				return v6.back(true)
			end

			return p3(NavigateBack(true))
		end,
		onError = function(p4, p5) -- line: 59
			-- upvalues: p3 (copy), SetCurrentToastMessage (copy), ToastType (copy)
			return p3(SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = p4,
				toastSubMessage = p5,
				toastType = ToastType.NetworkingError
			}))
		end
	}
end)(v11))
