local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)

local function useProgressiveRowCap(n1: number, n2: number?, n3: number?, n4: number?) -- line: 17
	-- upvalues: React (copy)
	local v8 = n2 ~= nil
	local v9 = math.max(1, n3 or 1)
	local v10, v11 = React.useState(function() -- line: 26
		-- upvalues: v8 (copy), n1 (copy), n2 (copy)
		if not v8 then
			return n1
		end

		return (math.min(math.max(0, n2), n1))
	end)
	local v12 = if not v8 then n1 else math.min(v10, n1)
	local v13 = v8 and v12 < n1

	React.useEffect(function() -- line: 36
		-- upvalues: v13 (copy), v11 (copy), v9 (copy), n4 (copy)
		if not v13 then
			return nil
		end

		local u14 = nil

		local function advance() -- line: 41
			-- upvalues: u14 (ref), v11 (copy), v9 (copy)
			if u14 then
				return
			end

			v11(function(n5: number) -- line: 45
				-- upvalues: v9 (copy)
				return n5 + v9
			end)
		end

		if n4 and n4 > 0 then
			task.delay(n4 / 1000, advance)
		else
			task.defer(advance)
		end

		return function() -- line: 56
			-- upvalues: u14 (ref)
			u14 = true
		end
	end, {
		v13,
		v9,
		v10,
		n4
	})

	return v12, v13
end

return useProgressiveRowCap
