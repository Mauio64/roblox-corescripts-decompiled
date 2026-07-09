local v1 = newproxy(true)

getmetatable(v1).__tostring = function() -- line: 3
	return "<removed>"
end

local function tableDiff(p1, p2, p3) -- line: 8
	-- upvalues: v1 (copy), tableDiff (copy)
	local v6 = p3 or 0

	if v6 == 10 then
		return nil
	end

	if p2 == nil then
		return v1
	end

	if typeof(p2) ~= "table" then
		return p2
	end

	local t1 = {}

	if typeof(p1) == "table" then
		for k, v in pairs(p1) do
			if v ~= p2[k] then
				t1[k] = tableDiff(v, p2[k], v6 + 1)
			end
		end
	end

	for k, v in pairs(p2) do
		if typeof(p1) ~= "table" or p1[k] == nil then
			t1[k] = tableDiff(nil, v, v6 + 1)
		end
	end

	if not next(t1) then
		return nil
	end

	return t1
end

return tableDiff
