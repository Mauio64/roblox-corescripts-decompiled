local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local AddUsersSearchResults = require(script.Parent.Parent.Actions.AddUsersSearchResults)
local RemoveUsersSearchResults = require(script.Parent.Parent.Actions.RemoveUsersSearchResults)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local PaginationMethod = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Enum.PaginationMethod

return function(p1, p2) -- line: 12
	-- upvalues: AddUsersSearchResults (copy), Cryo (copy), PaginationMethod (copy), ArgCheck (copy), RemoveUsersSearchResults (copy)
	local v9 = p1 or {}

	if p2.type == AddUsersSearchResults.name then
		local v10 = if not p2.searchUuid then p2.keyword else p2.searchUuid
		local v11 = v9[v10] or {}
		local nextPageCursor = v11.nextPageCursor
		local v13 = if not nextPageCursor or (nextPageCursor == "" or nextPageCursor ~= p2.curPageCursor) then p2.entries else Cryo.List.join(v11.entries or {}, p2.entries)

		if p2.paginationMethod then
			local v14 = PaginationMethod[p2.paginationMethod]

			ArgCheck.assert(v14, `Unknown pagination method: { v14 }`)
		end

		return (Cryo.Dictionary.join(v9, {
			[v10] = Cryo.Dictionary.join(v11, {
				nextPageCursor = p2.nextPageCursor or Cryo.None,
				keyword = p2.keyword,
				entries = v13,
				paginationMethod = p2.paginationMethod
			})
		}))
	end

	if p2.type == RemoveUsersSearchResults.name then
		local v15 = if not p2.searchUuid then p2.keyword else p2.searchUuid

		v9 = Cryo.Dictionary.join(v9, {
			[v15] = Cryo.None
		})
	end

	return v9
end
