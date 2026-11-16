local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local module = require("@luauforge/bundled/ecV")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module2 = require("@luauforge/bundled/fpt")
local module3 = require("@luauforge/bundled/fpI")
local module4 = require("@luauforge/bundled/dBX")
local module5 = require("@luauforge/bundled/dPI")

local function getFetchName(p2)
	return "luaapp.autocomplete.game.suggestion." .. p2
end

return {
	Fetch = function(p2, p3, p4)
		return performFetch.Single("luaapp.autocomplete.game.suggestion." .. p3, function(object)
			return module3(p2, p3, p4):andThen(function(p5)
				if not (p5 and p5.responseBody) then
					return module.reject()
				end

				local responseBody = p5.responseBody

				local v5 = if p3 == responseBody.prefix then module2.fromJsonData(responseBody) else nil

				if v5 then
					v5:match(function(p6)
						object:dispatch(module4(p3, p6))

						local universeIds = {}

						for i = 1, #p6.entries do
							local entry = p6.entries[i]

							if entry.type == module2.EntryType.Rich then
								table.insert(universeIds, entry.universeId)
							end
						end

						if #universeIds > 0 then
							module5.Game.getGameIconStore(false).getAndFetchGameIcons(universeIds)
						end
					end):matchError(function(p6)
						warn(p6)
					end)
					return module.resolve(p5)
				end

				logging.warn("Response from AutocompleteGameGetSuggestion is malformed!")
				return module.reject({ HttpError = Enum.HttpError.OK })
			end)
		end)
	end,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.autocomplete.game.suggestion." .. p3)
	end
}
