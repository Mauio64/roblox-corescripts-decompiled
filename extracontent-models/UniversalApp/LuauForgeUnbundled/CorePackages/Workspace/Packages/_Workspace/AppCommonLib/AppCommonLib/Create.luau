local function create(className)
	return function(items)
		local instance = Instance.new(className)
		local v5 = nil

		for k, item in pairs(items) do
			if type(k) == "number" and typeof(item) == "Instance" then
				item.Parent = instance
			elseif type(k) == "string" then
				if k == "Parent" then
					v5 = item
				else
					instance[k] = item
				end
			end
		end

		instance.Parent = v5

		return instance
	end
end

return create
