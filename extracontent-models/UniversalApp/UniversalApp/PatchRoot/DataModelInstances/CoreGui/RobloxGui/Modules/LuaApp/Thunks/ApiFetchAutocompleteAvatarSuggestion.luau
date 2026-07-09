local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(Modules.LuaApp.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local AutocompleteSuggestion = require(Modules.LuaApp.Models.AutocompleteSuggestion)
local AutocompleteAvatarSuggest = require(Modules.LuaApp.Http.Requests.AutocompleteAvatarSuggest)
local AddAvatarAutocompleteSuggestion = require(Modules.AvatarExperience.Catalog.Actions.AddAvatarAutocompleteSuggestion)

local function getFetchName(p1) -- line: 11
	return "luaapp.autocomplete.avatar.suggestion." .. p1
end

return {
	Fetch = function(p2, p3) -- line: 17
		-- upvalues: PerformFetch (copy), AutocompleteAvatarSuggest (copy), AutocompleteSuggestion (copy), AddAvatarAutocompleteSuggestion (copy), Promise (copy), Logging (copy)
		return PerformFetch.Single("luaapp.autocomplete.avatar.suggestion." .. p3, function(p4) -- line: 18
			-- upvalues: AutocompleteAvatarSuggest (copy), p2 (copy), p3 (copy), AutocompleteSuggestion (copy), AddAvatarAutocompleteSuggestion (copy), Promise (copy), Logging (copy)
			return AutocompleteAvatarSuggest(p2, p3):andThen(function(p5) -- line: 19
				-- upvalues: p3 (copy), AutocompleteSuggestion (copy), p4 (copy), AddAvatarAutocompleteSuggestion (copy), Promise (copy), Logging (copy)
				if p5 and p5.responseBody then
					local responseBody = p5.responseBody
					local v18 = nil

					if responseBody.Args ~= nil and p3 == responseBody.Args.Prefix then
						v18 = AutocompleteSuggestion.fromJsonDataAvatar(responseBody)
					end

					if v18 then
						v18:match(function(p6) -- line: 29
							-- upvalues: p4 (copy), AddAvatarAutocompleteSuggestion (copy), p3 (copy)
							p4:dispatch(AddAvatarAutocompleteSuggestion(p3, p6))
						end):matchError(function(p7) -- line: 33
							warn(p7)
						end)

						return Promise.resolve(p5)
					end

					Logging.warn("Response from AutocompleteAvatarSuggest is malformed!")

					return Promise.reject({
						HttpError = Enum.HttpError.OK
					})
				end

				return Promise.reject()
			end)
		end)
	end,
	GetFetchingStatus = function(p8, p9) -- line: 48
		-- upvalues: PerformFetch (copy)
		return PerformFetch.GetStatus(p8, "luaapp.autocomplete.avatar.suggestion." .. p9)
	end
}
