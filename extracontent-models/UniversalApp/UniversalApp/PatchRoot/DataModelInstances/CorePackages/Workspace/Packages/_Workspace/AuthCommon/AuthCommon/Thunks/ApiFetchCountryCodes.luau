local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Promise = require(AuthCommonParent.Promise)
local PerformFetch = require(AuthCommonParent.Http).PerformFetch
local GetCountryCodes = require(AuthCommon.Http.Requests.GetCountryCodes)
local CountryCode = require(AuthCommon.Models.CountryCode)
local SetCountryCodeList = require(AuthCommon.Actions.SetCountryCodeList)
local t2 = {
	_updateStoreWithCountryCodes = function(p1, p2) -- line: 13
		-- upvalues: CountryCode (copy), SetCountryCodeList (copy), Promise (copy)
		local t1 = {}

		for k, v in pairs(p2.responseBody) do
			t1[k] = CountryCode.fromJSON(v)
		end

		p1:dispatch(SetCountryCodeList(t1))

		return Promise.resolve()
	end
}

function t2.Fetch(p3) -- line: 22
	-- upvalues: PerformFetch (copy), GetCountryCodes (copy), t2 (copy), Promise (copy)
	return PerformFetch.Single("luaapp.countriesapi.countrycodes", function(p4) -- line: 23
		-- upvalues: GetCountryCodes (copy), p3 (copy), t2 (copy), Promise (copy)
		return GetCountryCodes(p3):andThen(function(p5) -- line: 24
			-- upvalues: t2 (copy), p4 (copy), Promise (copy)
			if p5 and p5.responseBody then
				return t2._updateStoreWithCountryCodes(p4, p5)
			end

			return Promise.reject()
		end)
	end)
end
function t2.GetFetchingStatus(p6) -- line: 34
	-- upvalues: PerformFetch (copy)
	return PerformFetch.GetStatus(p6, "luaapp.countriesapi.countrycodes")
end

return t2
