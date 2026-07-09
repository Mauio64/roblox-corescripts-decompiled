local function create(s1: string) -- line: 21
	return function(t1: {[any]: any}) -- line: 22
		-- upvalues: s1 (copy)
		local v4 = Instance.new(s1)
		local v5 = nil

		for k, v in pairs(t1) do
			if type(k) == "number" and typeof(v) == "Instance" then
				v.Parent = v4
			elseif type(k) == "string" then
				if k == "Parent" then
					v5 = v
				else
					v4[k] = v
				end
			end
		end

		v4.Parent = v5

		return v4
	end
end

return create
