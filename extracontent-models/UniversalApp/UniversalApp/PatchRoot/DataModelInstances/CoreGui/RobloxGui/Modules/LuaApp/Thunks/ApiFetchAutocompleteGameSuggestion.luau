local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(Modules.LuaApp.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local AutocompleteSuggestion = require(Modules.LuaApp.Models.AutocompleteSuggestion)
local AutocompleteGameGetSuggestion = require(Modules.LuaApp.Http.Requests.AutocompleteGameGetSuggestion)
local AddAutocompleteSuggestion = require(Modules.LuaApp.Actions.AddAutocompleteSuggestion)
local ApiFetchGameIcons = require(CorePackages.Workspace.Packages.GameIconRodux).GameIcons.ApiFetchGameIcons

local function getFetchName(p1) -- line: 11
	return "luaapp.autocomplete.game.suggestion." .. p1
end

return {
	Fetch = function(p2, p3, t1: {[any]: any}?) -- line: 17
		-- upvalues: PerformFetch (copy), AutocompleteGameGetSuggestion (copy), AutocompleteSuggestion (copy), AddAutocompleteSuggestion (copy), ApiFetchGameIcons (copy), Promise (copy), Logging (copy)
		return PerformFetch.Single("luaapp.autocomplete.game.suggestion." .. p3, function(p4) -- line: 18
			-- upvalues: AutocompleteGameGetSuggestion (copy), p2 (copy), p3 (copy), t1 (copy), AutocompleteSuggestion (copy), AddAutocompleteSuggestion (copy), ApiFetchGameIcons (copy), Promise (copy), Logging (copy)
			return AutocompleteGameGetSuggestion(p2, p3, t1):andThen(function(p5) -- line: 19
				-- upvalues: p3 (copy), AutocompleteSuggestion (copy), p4 (copy), AddAutocompleteSuggestion (copy), ApiFetchGameIcons (copy), p2 (copy), Promise (copy), Logging (copy)
				if p5 and p5.responseBody then
					local responseBody = p5.responseBody
					local v20 = nil

					if p3 == responseBody.prefix then
						v20 = AutocompleteSuggestion.fromJsonData(responseBody)
					end

					if v20 then
						v20:match(function(p6) -- line: 29
							-- upvalues: p4 (copy), AddAutocompleteSuggestion (copy), p3 (copy), AutocompleteSuggestion (copy), ApiFetchGameIcons (copy), p2 (copy)
							p4:dispatch(AddAutocompleteSuggestion(p3, p6))

							local t2 = {}

							for i = 1, #p6.entries do
								local v24 = p6.entries[i]

								if v24.type == AutocompleteSuggestion.EntryType.Rich then
									table.insert(t2, v24.universeId)
								end
							end

							if #t2 > 0 then
								p4:dispatch(ApiFetchGameIcons(p2, t2))
							end
						end):matchError(function(p7) -- line: 43
							warn(p7)
						end)

						return Promise.resolve(p5)
					end

					Logging.warn("Response from AutocompleteGameGetSuggestion is malformed!")

					return Promise.reject({
						HttpError = Enum.HttpError.OK
					})
				end

				return Promise.reject()
			end)
		end)
	end,
	GetFetchingStatus = function(p8, p9) -- line: 58
		-- upvalues: PerformFetch (copy)
		return PerformFetch.GetStatus(p8, "luaapp.autocomplete.game.suggestion." .. p9)
	end
}
