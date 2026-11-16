local parent = script.Parent.Parent.Parent
require(parent.ES7Types)

return function(list, value: number?, p: number?)
	if typeof(list) ~= "table" then
		error(string.format("Array.slice called on %s", (typeof(list))))
	end

	local count = #list

	local v = value or 1

	if p == nil or count + 1 < p then
		p = count + 1
	end

	if count + 1 < v then
		return {}
	end

	local result = {}

	if v < 1 then
		v = math.max(count - math.abs(v), 1)
	end

	if p < 1 then
		p = math.max(count - math.abs(p), 1)
	end

	local v2 = 1

	while v < p do
		result[v2] = list[v]
		v += 1
		v2 += 1
	end

	return result
end
