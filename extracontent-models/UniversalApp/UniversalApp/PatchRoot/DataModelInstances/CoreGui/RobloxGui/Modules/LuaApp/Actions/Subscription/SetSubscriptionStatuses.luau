local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator

require(Modules.LuaApp.Models.SubscriptionApi.SubscriptionStatusModel)

return makeActionCreator(script.Name, function(t1: {[any]: any}?) -- line: 11
	return {
		subscriptionStatuses = t1
	}
end)
