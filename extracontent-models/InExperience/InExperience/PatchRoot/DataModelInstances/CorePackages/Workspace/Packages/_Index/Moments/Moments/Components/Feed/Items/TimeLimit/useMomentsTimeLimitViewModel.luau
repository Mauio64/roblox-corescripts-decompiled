local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Localization = require(parent.Localization)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local SignalsReact = require(parent.SignalsReact)

local GetMomentsUsageStore = require(Moments.Stores.GetMomentsUsageStore)
require(script.Parent.MomentsTimeLimitView)

local useLocalization = Localization.Hooks.useLocalization

local v = {
	title = "Feature.Moments.Label.TimeLimitReachedTitle",
	description = "Feature.Moments.Description.TimeLimitReachedBody"
}

local v2 = {
	title = "Feature.Moments.Label.MomentsOffTitle",
	description = "Feature.Moments.Description.MomentsOffBody"
}

local function isLimitChange(p): boolean -- 1 equivalent call inferred from this helper
	local settingsChanged

	if type(p) == "table" then
		settingsChanged = p.SettingsChanged
	end

	return type(settingsChanged) == "table" and table.find(settingsChanged, "MomentsUsageLimit") ~= nil
end

local function useMomentsTimeLimitViewModel()
	local momentsUsageStore = GetMomentsUsageStore(false)
	local v3

	if SignalsReact.useSignalState(momentsUsageStore.getLimitSeconds) == 0 then
		v3 = v2
	else
		v3 = v
	end

	local v4 = useLocalization(v3)

	RealtimeDelivery.useRealtimeNamespace("UserSettingsChanged", function(p)
		if isLimitChange(p) then -- inferred equivalent call
			momentsUsageStore.checkForMoreTime()
		end
	end, { momentsUsageStore })

	RealtimeDelivery.useRealtimeConnectionStateChanged("UserSettingsChanged", function(_, p)
		if p then
			momentsUsageStore.checkForMoreTime()
		end
	end, { momentsUsageStore })

	return { title = v4.title, description = v4.description }
end

return useMomentsTimeLimitViewModel
