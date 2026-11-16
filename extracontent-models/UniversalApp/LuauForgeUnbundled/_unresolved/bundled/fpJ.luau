local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local module = require("@luauforge/bundled/ecV")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module2 = require("@luauforge/bundled/fpt")
local module3 = require("@luauforge/bundled/fpK")

local module4 = require("@luauforge/bundled/dTq")

local fFlagAXUnifiedAutocompleteEndpoint = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUnifiedAutocompleteEndpoint

local fStringAXUnifiedAutocompleteVariant = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FStringAXUnifiedAutocompleteVariant

local autocompleteUnifiedSuggest = require("@luauforge/bundled/fpM").Api.autocompleteUnifiedSuggest

local function getFetchName(p2)
	return "luaapp.autocomplete.avatar.suggestion." .. p2
end

return {
	Fetch = function(p2, p3)
		return performFetch.Single("luaapp.autocomplete.avatar.suggestion." .. p3, function(object)
			local v5

			if fFlagAXUnifiedAutocompleteEndpoint then
				v5 = autocompleteUnifiedSuggest(p2, p3)
			else
				v5 = module3(p2, p3)
			end

			return v5:andThen(function(p4)
				if not (p4 and p4.responseBody) then
					return module.reject()
				end

				local responseBody = p4.responseBody
				local v6 = nil

				if fFlagAXUnifiedAutocompleteEndpoint then
					if p3 == responseBody.prefix then
						v6 = module2.fromJsonDataUnifiedAutocomplete(
							responseBody,
							fStringAXUnifiedAutocompleteVariant
						)
					end
				elseif responseBody.Args ~= nil and p3 == responseBody.Args.Prefix then
					v6 = module2.fromJsonDataAvatar(responseBody)
				end

				if v6 then
					v6:match(function(p5)
						object:dispatch(module4(p3, p5))
					end):matchError(function(p5)
						warn(p5)
					end)
					return module.resolve(p4)
				end

				logging.warn("Response from AutocompleteAvatarSuggest is malformed!")
				return module.reject({ HttpError = Enum.HttpError.OK })
			end)
		end)
	end,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.autocomplete.avatar.suggestion." .. p3)
	end
}
