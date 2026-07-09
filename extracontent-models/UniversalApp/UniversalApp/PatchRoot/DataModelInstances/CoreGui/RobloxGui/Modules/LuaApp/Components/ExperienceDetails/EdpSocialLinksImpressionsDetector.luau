local TelemetryService = game:GetService("TelemetryService")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

require(CorePackages.Workspace.Packages.AppCommonLib)

local ScreenSizeImpressionsTracker = require(CorePackages.Workspace.Packages.Impressions).ScreenSizeImpressionsTracker
local sendSocialLinksImpressionsEvent = require(CorePackages.Workspace.Packages.DiscoveryAnalytics).Events.sendSocialLinksImpressionsEvent
local v6 = game:DefineFastFlag("FFlagLuaAppMoveSocialLinksImpressions", false)
local v7 = if not v6 then game:DefineFastInt("SocialLinksImpressionsEventHundredthsPercent", 10000) else nil
local v8 = if not v6 then {
	eventName = "EdpSocialLinksImpressions",
	description = "Impressions for social links on EDP",
	lastUpdated = {
		25,
		12,
		10
	},
	backends = { "EventIngest" },
	throttlingPercentage = v7
} else nil

return function(t1: {[any]: any}) -- line: 37
	-- upvalues: React (copy), v6 (copy), sendSocialLinksImpressionsEvent (copy), TelemetryService (copy), v8 (copy), ScreenSizeImpressionsTracker (copy)
	local v10 = React.useCallback(function(t2: {[any]: any}) -- line: 38
		-- upvalues: t1 (copy), v6 (copy), sendSocialLinksImpressionsEvent (copy), TelemetryService (copy), v8 (copy)
		if #t2 == 0 or t1.socialLinks == nil then
			return
		end

		local t3 = {}
		local t4 = {}
		local t5 = {}

		for i = 1, #t2 do
			local v16 = t1.socialLinks[i]

			if v16 then
				table.insert(t3, i)
				table.insert(t4, v16.url or "")
				table.insert(t5, v16.type or "")
			end
		end

		local t6 = {
			social_link_display_type = "badge",
			assignment_type = "game",
			item_positions = table.concat(t3, ","),
			social_link_urls = table.concat(t4, ","),
			social_link_types = table.concat(t5, ","),
			assignment_id = tonumber(t1.universeId),
			page = t1.pageContext
		}

		if v6 then
			sendSocialLinksImpressionsEvent(t6)

			return
		end

		TelemetryService:LogEvent(v8, {
			customFields = t6,
			standardizedFields = { "addSessionInfo" }
		})
	end, {
		t1.socialLinks,
		t1.universeId,
		t1.pageContext
	})

	return React.createElement(ScreenSizeImpressionsTracker, {
		parentRef = t1.parentRef,
		pageContext = t1.pageContext,
		impressionsTag = t1.impressionsTag,
		scrollViewPositionChangedSignal = t1.scrollViewPositionChangedSignal,
		sendImpressions = v10
	})
end
