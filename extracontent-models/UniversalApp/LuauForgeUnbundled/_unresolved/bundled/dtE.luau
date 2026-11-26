local module = require("@luauforge/bundled/dtF")

local module2 = require("@luauforge/bundled/dtA")
local module3 = require("@luauforge/bundled/dtG")
local module4 = require("@luauforge/bundled/dtH")

local v5 = {}

function v5.new()
	return {}
end

function v5.mock()
	local v6 = v5.new()
	v6.keyword = "Meepcity"
	v6.entries = { module2.mock() }
	v6.emphasis = true
	v6.hasMoreRows = false
	v6.nextPageToken = nil
	v6.paginationMethod = module4.Scroll
	return v6
end

function v5.fromOmniSearch(keyword, entries, emphasis, nextPageToken, p2)
	local v6 = v5.new()
	v6.keyword = keyword
	v6.entries = entries
	v6.emphasis = emphasis
	v6.updatedTimestamp = tick()

	if nextPageToken and nextPageToken ~= "" then
		if p2 then
			v6.paginationMethod = module4[p2]
			module3.assert(v6.paginationMethod, `Unknown pagination method: {p2}`)
		else
			v6.paginationMethod = module4.Scroll
		end

		v6.nextPageToken = nextPageToken
		v6.hasMoreRows = true
	else
		v6.nextPageToken = nil
		v6.hasMoreRows = false
	end

	return v6
end

function v5.IsEqual(p2, p3)
	if module.shallowEqual(p2.entries, p3.entries) then
		return module.shallowEqual(p2, p3, { entries = true })
	end

	return false
end

return v5
