local __DEV__ = _G.__DEV__

local function instanceof(p, p2): boolean
	if __DEV__ then
		assert(typeof(p2) == "table", "Received a non-table as the second argument for instanceof")
	end

	if typeof(p) ~= "table" then
		return false
	end

	local success, result = pcall(function(): boolean
		return p2.new ~= nil and p.new == p2.new
	end)

	if success and result then
		return true
	end

	local v = { [p] = true }

	while p and typeof(p) == "table" do
		p = getmetatable(p)

		if typeof(p) == "table" then
			p = p.__index

			if p == p2 then
				return true
			end
		end

		if typeof(p) ~= "table" then
			continue
		end

		if v[p] then
			return false
		end

		v[p] = true
	end

	return false
end

return instanceof
