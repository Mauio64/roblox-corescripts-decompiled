local function getProperty(p, k) -- 1 equivalent call inferred from this helper
	local success, result = pcall(function()
		return p[k]
	end)

	return success == true and result or nil
end

local function propertyMatch(descendant, items): boolean
	for k, item in pairs(items) do
		if getProperty(descendant, k) ~= item then -- inferred equivalent call
			return false
		end
	end

	return true
end

local function findFirstInstance(folder, p)
	for _, descendant in ipairs(folder:GetDescendants()) do
		if propertyMatch(descendant, p) then
			return descendant
		end
	end

	return nil
end

return findFirstInstance
