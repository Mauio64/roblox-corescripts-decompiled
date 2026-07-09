local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetShowBuyRobuxButtonBadge = require(Modules.LuaApp.Actions.Economy.SetShowBuyRobuxButtonBadge)
local SetBuyRobuxButtonClicked = require(Modules.LuaApp.Actions.Economy.SetBuyRobuxButtonClicked)
local SetHasFetchedRobuxBadge = require(Modules.LuaApp.Actions.Economy.SetHasFetchedRobuxBadge)
local Cryo = require(CorePackages.Packages.Cryo)

return function(t1: {[any]: any}?, p1) -- line: 13
	-- upvalues: SetShowBuyRobuxButtonBadge (copy), Cryo (copy), SetBuyRobuxButtonClicked (copy), SetHasFetchedRobuxBadge (copy)
	local v9 = t1 or {
		showBuyRobuxButtonBadge = false,
		buyRobuxButtonClicked = false,
		hasFetchedRobuxBadge = false
	}

	assert(v9, "")

	if p1.type == SetShowBuyRobuxButtonBadge.name then
		return Cryo.Dictionary.join(v9, {
			showBuyRobuxButtonBadge = p1.showBuyRobuxButtonBadge
		})
	end

	if p1.type == SetBuyRobuxButtonClicked.name then
		return Cryo.Dictionary.join(v9, {
			buyRobuxButtonClicked = p1.buyRobuxButtonClicked
		})
	end

	if p1.type == SetHasFetchedRobuxBadge.name then
		return Cryo.Dictionary.join(v9, {
			hasFetchedRobuxBadge = p1.hasFetchedRobuxBadge
		})
	end

	return v9
end
