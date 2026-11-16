require(script.Parent.types)

local v = {}
local StatusCodeActions = {}

function StatusCodeActions.add(p: number, callback)
	local v2 = v[p]

	if v2 == nil then
		v2 = {}
		v[p] = v2
	end

	table.insert(v2, callback)
end

function StatusCodeActions.remove(p: number, callback)
	local v2 = v[p]

	if v2 == nil then
		return
	end

	for k, v3 in v2 do
		if v3 == callback then
			table.remove(v2, k)
			break
		end
	end

	if #v2 == 0 then
		v[p] = nil
	end
end

function StatusCodeActions.clear()
	v = {}
end

function StatusCodeActions.snapshot()
	if next(v) == nil then
		return nil
	end

	local result = {}

	for k, v2 in v do
		local v3 = {}

		for i = #v2, 1, -1 do
			table.insert(v3, v2[i])
		end

		result[k] = v3
	end

	return result
end

return StatusCodeActions
