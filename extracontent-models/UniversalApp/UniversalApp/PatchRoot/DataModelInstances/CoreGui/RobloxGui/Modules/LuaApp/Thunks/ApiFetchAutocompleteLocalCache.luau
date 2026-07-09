local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local AutocompleteSuggestionTable = require(Modules.LuaApp.Models.AutocompleteSuggestionTable)
local AutocompleteGetLocalCache = require(Modules.LuaApp.Http.Requests.AutocompleteGetLocalCache)
local AddAutocompleteSuggestionTable = require(Modules.LuaApp.Actions.AddAutocompleteSuggestionTable)
local Promise = require(Modules.LuaApp.Promise)

local function getFetchName(p1, p2) -- line: 10
	return "luaapp.autocomplete.getlocalcache." .. p1 .. "." .. (p2 or "none")
end

local t1 = {}

function t1.Fetch(p3, p4, p5, p6) -- line: 16
	-- upvalues: PerformFetch (copy), AutocompleteGetLocalCache (copy), AutocompleteSuggestionTable (copy), AddAutocompleteSuggestionTable (copy), t1 (copy), Promise (copy)
	return PerformFetch.Single("luaapp.autocomplete.getlocalcache." .. p4 .. "." .. (p5 or "none"), function(p7) -- line: 17
		-- upvalues: AutocompleteGetLocalCache (copy), p3 (copy), p4 (copy), p5 (copy), p6 (copy), AutocompleteSuggestionTable (copy), AddAutocompleteSuggestionTable (copy), t1 (copy), Promise (copy)
		return AutocompleteGetLocalCache(p3, p4, p5, p6):andThen(function(p8) -- line: 18
			-- upvalues: AutocompleteSuggestionTable (copy), p7 (copy), AddAutocompleteSuggestionTable (copy), t1 (copy), p3 (copy), p5 (copy), p6 (copy), Promise (copy)
			if p8 and p8.responseBody then
				local responseBody = p8.responseBody

				AutocompleteSuggestionTable.fromJsonData(responseBody):match(function(p9) -- line: 23
					-- upvalues: p7 (copy), AddAutocompleteSuggestionTable (copy)
					p7:dispatch(AddAutocompleteSuggestionTable(p9))
				end):matchError(function(p10) -- line: 26
					warn(p10)
				end)

				if responseBody.hasNextPage and responseBody.pageNumber then
					p7:dispatch(t1.Fetch(p3, responseBody.pageNumber + 1, p5, p6))
				end

				return Promise.resolve()
			end

			return Promise.reject()
		end, function(p11) -- line: 39
			-- upvalues: Promise (copy)
			return Promise.reject(p11)
		end)
	end)
end

return t1
