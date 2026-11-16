local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent
local Promise = require(parent.Promise)
local Http = require(parent.Http)
local PerformFetch = Http.PerformFetch

local GetCountryCodes = require(AuthCommon.Http.Requests.GetCountryCodes)
local CountryCode = require(AuthCommon.Models.CountryCode)
local SetCountryCodeList = require(AuthCommon.Actions.SetCountryCodeList)
local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForCountryCodeList = SharedFlags.FFlagUseSignalsForCountryCodeList
local GetCountryCodeListStore = require(AuthCommon.Stores.GetCountryCodeListStore)

local ApiFetchCountryCodes = {}

function ApiFetchCountryCodes._updateStoreWithCountryCodes(object, p)
	local v = {}

	for k, v2 in pairs(p.responseBody) do
		v[k] = CountryCode.fromJSON(v2)
	end

	if FFlagUseSignalsForCountryCodeList then
		GetCountryCodeListStore(false).setCountryCodeList(v)
	else
		object:dispatch(SetCountryCodeList(v))
	end

	return Promise.resolve()
end

function ApiFetchCountryCodes.Fetch(p)
	return PerformFetch.Single("luaapp.countriesapi.countrycodes", function(p2)
		return GetCountryCodes(p):andThen(function(p3)
			if p3 and p3.responseBody then
				return ApiFetchCountryCodes._updateStoreWithCountryCodes(p2, p3)
			end

			return Promise.reject()
		end)
	end)
end

function ApiFetchCountryCodes.GetFetchingStatus(p)
	return PerformFetch.GetStatus(p, "luaapp.countriesapi.countrycodes")
end

return ApiFetchCountryCodes
