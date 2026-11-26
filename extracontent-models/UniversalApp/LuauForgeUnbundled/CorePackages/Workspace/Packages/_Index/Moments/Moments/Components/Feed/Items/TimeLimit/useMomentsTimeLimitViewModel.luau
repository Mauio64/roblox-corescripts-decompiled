local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RealtimeDelivery")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local GetMomentsUsageStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsUsageStore")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/TimeLimit/MomentsTimeLimitView")

local useLocalization = Localization.Hooks.useLocalization

local v5 = {
	title = "Feature.Moments.Label.TimeLimitReachedTitle",
	description = "Feature.Moments.Description.TimeLimitReachedBody"
}

local v6 = {
	title = "Feature.Moments.Label.MomentsOffTitle",
	description = "Feature.Moments.Description.MomentsOffBody"
}

local function isLimitChange(p2): boolean
	local settingsChanged = if type(p2) == "table" then p2.SettingsChanged else nil
	return type(settingsChanged) == "table" and table.find(settingsChanged, "MomentsUsageLimit") ~= nil
end

local function useMomentsTimeLimitViewModel()
	local v7 = GetMomentsUsageStore(false)
	local v10 = if SignalsReact.useSignalState(v7.getLimitSeconds) == 0 then v6 else v5
	local v11 = useLocalization(v10)

	RealtimeDelivery.useRealtimeNamespace("UserSettingsChanged", function(p2)
		local settingsChanged = if type(p2) == "table" then p2.SettingsChanged else nil
		local v12

		if type(settingsChanged) == "table" then
			v12 = table.find(settingsChanged, "MomentsUsageLimit") ~= nil
		else
			v12 = false
		end

		if v12 then
			v7.checkForMoreTime()
		end
	end, { v7 })

	RealtimeDelivery.useRealtimeConnectionStateChanged("UserSettingsChanged", function(p2, p3)
		if p3 then
			v7.checkForMoreTime()
		end
	end, { v7 })

	return { title = v11.title, description = v11.description }
end

return useMomentsTimeLimitViewModel
