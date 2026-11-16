local function create(className: string)
	return function(items)
		local instance = Instance.new(className)
		local parent = nil

		for k, item in pairs(items) do
			if type(k) == "number" and typeof(item) == "Instance" then
				item.Parent = instance
			elseif type(k) == "string" then
				if k == "Parent" then
					parent = item
				else
					instance[k] = item
				end
			end
		end

		instance.Parent = parent

		return instance
	end
end

return create
