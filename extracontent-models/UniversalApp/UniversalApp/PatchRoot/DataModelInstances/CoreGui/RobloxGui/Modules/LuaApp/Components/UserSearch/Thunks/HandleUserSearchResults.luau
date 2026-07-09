local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local OmniFeedConstants = require(CorePackages.Workspace.Packages.DiscoveryTypes).OmniFeedConstants
local Modules2 = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local AddTextSearchResults = Modules2.LuaApp.Actions.AddTextSearchResults
local getFormattedTextSearchEntry = Modules2.LuaApp.Models.DiscoveryApi.getFormattedTextSearchEntry
local AddUsersSearchResults = require(script.Parent.Parent.Actions.AddUsersSearchResults)
local UserSearchEntry = require(script.Parent.Parent.Models.UserSearchEntry)

return function(_, t1: {[any]: any}, p2) -- line: 23
	-- upvalues: Promise (copy), OmniFeedConstants (copy), getFormattedTextSearchEntry (copy), AddTextSearchResults (copy), UserSearchEntry (copy), AddUsersSearchResults (copy)
	return function(p3) -- line: 24
		-- upvalues: p2 (copy), Promise (copy), OmniFeedConstants (copy), getFormattedTextSearchEntry (copy), AddTextSearchResults (copy), t1 (copy), UserSearchEntry (copy), AddUsersSearchResults (copy)
		if not p2 or not p2.responseBody then
			return Promise.reject()
		end

		local nextPageToken = p2.responseBody.nextPageToken

		if not nextPageToken or nextPageToken == "" then
			nextPageToken = "EndOfPlayerSearch"
		end

		local v15 = p2.responseBody.searchResults and p2.responseBody.searchResults[1]

		if v15 and v15.contentGroupType == OmniFeedConstants.ContentGroupType.Text then
			local topicId = v15.topicId
			local v17 = getFormattedTextSearchEntry(v15.contents)

			if v17 then
				p3:dispatch(AddTextSearchResults({
					searchUuid = t1.searchUuid,
					topicId = topicId,
					entry = v17
				}))
			end

			return Promise.resolve(p2)
		end

		local t2 = {}
		local v19 = p2.responseBody.searchResults and (p2.responseBody.searchResults[1] and p2.responseBody.searchResults[1].contents)

		if v19 then
			for i = 1, #v19 do
				local v21 = v19[i]

				UserSearchEntry.fromOmniJsonData(v21):match(function(p4) -- line: 67
					-- upvalues: t2 (copy)
					table.insert(t2, p4)
				end):matchError(function(_) -- line: 70
					warn("Failure in parsing UserSearchEntry")
				end)
			end
		end

		p3:dispatch(AddUsersSearchResults({
			keyword = t1.searchKeyword,
			entries = t2,
			nextPageCursor = nextPageToken,
			curPageCursor = t1.curPageCursor,
			paginationMethod = p2.responseBody.paginationMethod
		}))

		return Promise.resolve(p2)
	end
end
