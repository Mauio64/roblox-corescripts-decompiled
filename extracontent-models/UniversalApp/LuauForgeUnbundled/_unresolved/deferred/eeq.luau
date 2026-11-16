local module = require("@luauforge/bundled/ecV")

local omniFeedConstants = require("@luauforge/bundled/cyO").OmniFeedConstants
local modules = require("@luauforge/bundled/dpZ").Modules
local addTextSearchResults = modules.LuaApp.Actions.AddTextSearchResults
local getFormattedTextSearchEntry = modules.LuaApp.Models.DiscoveryApi.getFormattedTextSearchEntry

local module2 = require("@luauforge/bundled/dCb")
local module3 = require("@luauforge/bundled/dCc")

return function(p2, data, p3)
	return function(object)
		if not (p3 and p3.responseBody) then
			return module.reject()
		end

		local nextPageToken = p3.responseBody.nextPageToken
		local v5 = (not nextPageToken or nextPageToken == "") and "EndOfPlayerSearch" or nextPageToken
		local v6 = p3.responseBody.searchResults and p3.responseBody.searchResults[1]

		if v6 and v6.contentGroupType == omniFeedConstants.ContentGroupType.Text then
			local topicId = v6.topicId
			local formattedTextSearchEntry = getFormattedTextSearchEntry(v6.contents)

			if formattedTextSearchEntry then
				object:dispatch(addTextSearchResults({
					searchUuid = data.searchUuid,
					topicId = topicId,
					entry = formattedTextSearchEntry
				}))
			end

			return module.resolve(p3)
		else
			local v7 = {}

			local contents = p3.responseBody.searchResults
				and p3.responseBody.searchResults[1]
				and p3.responseBody.searchResults[1].contents

			if contents then
				for i = 1, #contents do
					local content = contents[i]
					module3.fromOmniJsonData(content):match(function(p4)
						table.insert(v7, p4)
					end):matchError(function(p4)
						warn("Failure in parsing UserSearchEntry")
					end)
				end
			end

			object:dispatch(module2({
				keyword = data.searchKeyword,
				entries = v7,
				nextPageCursor = v5,
				curPageCursor = data.curPageCursor,
				paginationMethod = p3.responseBody.paginationMethod
			}))

			return module.resolve(p3)
		end
	end
end
