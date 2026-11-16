local CorePackages = game:GetService("CorePackages")

local Signals = require(CorePackages.Packages.Signals)
local module = require("@luauforge/bundled/fBo")
local module2 = require("@luauforge/bundled/dPI")
local module3 = require("@luauforge/bundled/bXh")

local module4 = require("@luauforge/bundled/fBI")

local dataStatus = module2.DataStatus

local function launchContextToTrigger(p2): string
	if p2 == module.Startup then
		return "SessionStart"
	end

	return "Auth"
end

local function publishAdConsentAttribution(p2, p3, options)
	local v5 = options or {}
	local adapter = v5.adapter or module3.AdConsentAttributionAdapter
	local linkingProtocol = v5.linkingProtocol or module3.LinkingProtocol.default
	local userSettingsStore = v5.userSettingsStore or module2.UserSettings.getUserSettingsStore(false)
	local v6 = p2 == module.Startup and "SessionStart" or "Auth"

	local function publish(p4)
		adapter.resolveAndPublish(linkingProtocol, v6, function()
			return p4
		end, p3)
	end

	local data = userSettingsStore.getUserSettings(false).data(false)
	local allowSellShareData = data and data.allowSellShareData

	if allowSellShareData == nil then
		if module4 then
			(v5.fetchUserSettings or module2.UserSettings.fetchSettingsAndOptions)():andThen(function(p4)
				local allowSellShareData2 = p4 and p4.allowSellShareData
				local currentValue = allowSellShareData2 and allowSellShareData2.currentValue
				adapter.resolveAndPublish(linkingProtocol, v6, function()
					return currentValue
				end, p3)
			end):catch(function() end)
			return
		end

		local userSettings = userSettingsStore.fetchUserSettings()
		local flag = false
		local v7 = nil
		v7 = Signals.createEffect(function(p4)
			if flag then
				return
			end

			local status = userSettings.status(p4)

			if status == dataStatus.NotReady then
				return
			end

			flag = true

			if status == dataStatus.Ready then
				local data2 = userSettings.data(p4)
				local allowSellShareData2 = data2 and data2.allowSellShareData
				local currentValue = allowSellShareData2 and allowSellShareData2.currentValue
				adapter.resolveAndPublish(linkingProtocol, v6, function()
					return currentValue
				end, p3)
			end

			task.defer(function()
				if v7 then
					v7()
				end
			end)
		end)
	else
		local currentValue = allowSellShareData.currentValue
		adapter.resolveAndPublish(linkingProtocol, v6, function()
			return currentValue
		end, p3)
	end
end

return publishAdConsentAttribution
