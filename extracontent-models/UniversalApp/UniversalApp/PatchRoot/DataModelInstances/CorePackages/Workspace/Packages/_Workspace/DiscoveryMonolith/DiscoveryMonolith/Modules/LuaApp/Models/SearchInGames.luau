local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local tutils = require(DiscoveryMonolithParent.tutils)
local Modules = DiscoveryMonolith.Modules
local GameSearchEntry = require(Modules.LuaApp.Models.GamesApi.GameSearchEntry)
local ArgCheck = require(DiscoveryMonolithParent.ArgCheck)
local PaginationMethod = require(Modules.LuaApp.Enum.PaginationMethod)
local t1 = {
	new = function() -- line: 36
		return {}
	end
}

function t1.mock() -- line: 42
	-- upvalues: t1 (copy), GameSearchEntry (copy), PaginationMethod (copy)
	local v9 = t1.new()

	v9.keyword = "Meepcity"
	v9.entries = { GameSearchEntry.mock() }
	v9.emphasis = true
	v9.hasMoreRows = false
	v9.nextPageToken = nil
	v9.paginationMethod = PaginationMethod.Scroll

	return v9
end
function t1.fromOmniSearch(p1, p2, p3, p4, p5) -- line: 53
	-- upvalues: t1 (copy), PaginationMethod (copy), ArgCheck (copy)
	local v15 = t1.new()

	v15.keyword = p1
	v15.entries = p2
	v15.emphasis = p3
	v15.updatedTimestamp = tick()

	if p4 and p4 ~= "" then
		if p5 then
			v15.paginationMethod = PaginationMethod[p5]
			ArgCheck.assert(v15.paginationMethod, `Unknown pagination method: { p5 }`)
		else
			v15.paginationMethod = PaginationMethod.Scroll
		end

		v15.nextPageToken = p4
		v15.hasMoreRows = true

		return v15
	end

	v15.nextPageToken = nil
	v15.hasMoreRows = false

	return v15
end
function t1.IsEqual(p6, p7) -- line: 76
	-- upvalues: tutils (copy)
	if not tutils.shallowEqual(p6.entries, p7.entries) then
		return false
	end

	local t2 = {
		entries = true
	}

	return tutils.shallowEqual(p6, p7, t2)
end

return t1
