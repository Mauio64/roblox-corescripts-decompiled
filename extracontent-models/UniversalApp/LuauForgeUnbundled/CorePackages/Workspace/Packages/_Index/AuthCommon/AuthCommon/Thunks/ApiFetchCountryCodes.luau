local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").PerformFetch

local GetCountryCodes = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/GetCountryCodes")
local CountryCode = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Models/CountryCode")
local SetCountryCodeList = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Actions/SetCountryCodeList")
local fFlagUseSignalsForCountryCodeList = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagUseSignalsForCountryCodeList
local GetCountryCodeListStore = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Stores/GetCountryCodeListStore")

local v5 = {}

function v5._updateStoreWithCountryCodes(object, p2)
	local v6 = {}

	for k, v7 in pairs(p2.responseBody) do
		v6[k] = CountryCode.fromJSON(v7)
	end

	if fFlagUseSignalsForCountryCodeList then
		GetCountryCodeListStore(false).setCountryCodeList(v6)
	else
		object:dispatch(SetCountryCodeList(v6))
	end

	return Promise.resolve()
end

function v5.Fetch(p2)
	return performFetch.Single("luaapp.countriesapi.countrycodes", function(p3)
		return GetCountryCodes(p2):andThen(function(p4)
			if p4 and p4.responseBody then
				return v5._updateStoreWithCountryCodes(p3, p4)
			end

			return Promise.reject()
		end)
	end)
end

function v5.GetFetchingStatus(p2)
	return performFetch.GetStatus(p2, "luaapp.countriesapi.countrycodes")
end

return v5
