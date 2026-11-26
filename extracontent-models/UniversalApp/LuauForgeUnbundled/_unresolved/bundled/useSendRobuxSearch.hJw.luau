local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/hII")

local module2 = require("@luauforge/bundled/hHY")
local module3 = require("@luauforge/bundled/hHu")

local module4 = require("@luauforge/bundled/hHP")

local module5 = require("@luauforge/bundled/hJo")
require("@luauforge/bundled/hJp")
local module6 = require("@luauforge/bundled/hJx")

local v5 = { query = "", results = {} }

local function toResults(items)
	local v6 = tostring(module2.DataHydrationUtils.getLocalPlayerUserId())
	local results = {}

	for k, item in items do
		if item.userId == v6 then
			continue
		end

		table.insert(results, item)

		if #results >= module5.SearchMaxResults then
			break
		end
	end

	return results
end

local function useSendRobuxSearch(p2)
	local v6 = module3.useMemo(function()
		return HttpService:GenerateGUID(false)
	end, {})
	local state, setState = module3.useState("")
	local state2, setState2 = module3.useState(v5)
	local ref = module3.useRef(0)

	module3.useEffect(function()
		if p2 ~= "" then
			local thread = task.delay(module5.SearchDebounceSeconds, setState, p2)
			return function()
				task.cancel(thread)
			end
		end

		ref.current += 1
		setState("")
		setState2(v5)
		return nil
	end, { p2 })

	module3.useEffect(function()
		if state == "" then
			return
		end

		ref.current += 1
		local current = ref.current
		local v8 = state

		local v9 = module and (string.match(v8, "^%s*(.-)%s*$") or "") or v8

		if #v9 < module5.SearchMinCharacters then
			setState2({ query = state, results = {} })
			return
		end

		module4.trackCounter("UserSearchStarted")
		module6(v9, v6):andThen(function(p3)
			if ref.current == current then
				local v10 = toResults(p3)
				setState2({ query = state, results = v10 })

				if #v10 == 0 then
					module4.trackCounter("UserSearchNoResults")
				end
			end
		end):catch(function()
			if ref.current == current then
				setState2({ query = state, results = {} })
			end
		end)
	end, { state, v6 })

	return {
		settledQuery = state2.query,
		results = state2.results,
		isSearching = p2 ~= "" and state2.query ~= p2
	}
end

return useSendRobuxSearch
