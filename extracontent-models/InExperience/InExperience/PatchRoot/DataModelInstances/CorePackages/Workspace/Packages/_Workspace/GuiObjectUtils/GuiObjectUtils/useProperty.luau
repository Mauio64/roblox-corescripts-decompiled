local Parent = script:FindFirstAncestor("GuiObjectUtils").Parent
local React = require(Parent.React)

local function getRefValue(p1) -- line: 10
	if typeof(p1) == "table" then
		return p1.current
	end

	return p1
end
local function useProperty(p2, s1: string) -- line: 47
	-- upvalues: React (copy)
	local v8 = if typeof(p2) ~= "table" then p2 else p2.current
	local v9, v10 = React.useState(function() -- line: 50
		-- upvalues: v8 (copy), s1 (copy)
		if v8 then
			return v8[s1]
		end

		return nil
	end)
	local v11 = React.useCallback(function() -- line: 55
		-- upvalues: p2 (copy), s1 (copy), v10 (copy)
		local v12 = p2
		local v13 = if typeof(v12) ~= "table" then v12 else v12.current

		if v13 then
			local v14 = v13[s1]

			v10(v14)
		end
	end, {
		p2,
		s1
	})

	React.useEffect(function() -- line: 66
		-- upvalues: p2 (copy), s1 (copy), v11 (copy)
		local connection = nil
		local v16 = p2
		local v17 = if typeof(v16) ~= "table" then v16 else v16.current

		if v17 then
			connection = v17:GetPropertyChangedSignal(s1):Connect(v11)
			v11()
		end

		return function() -- line: 76
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, {
		v8,
		s1,
		v11
	})

	return v9
end

return useProperty
