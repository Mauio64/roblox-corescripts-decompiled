local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

return function(n1: number, n2: number, n3: number?, b1: boolean?, _: number?) -- line: 32
	-- upvalues: React (copy)
	local u8 = n3 or n2
	local v9, v10 = React.useState(b1 or false)
	local v11, v12 = React.useState(false)
	local v13 = React.useRef(b1 or 0)
	local v14 = React.useRef(false)

	React.useEffect(function() -- line: 48
		-- upvalues: v13 (copy), v12 (copy), v11 (copy), v9 (copy), n2 (copy), n1 (copy), v14 (copy), u8 (ref)
		local timestamp = tick()
		local u16 = nil
		local u17 = false

		if v9 then
			local v18 = n2 - v13.current
			local v19 = n2

			if v18 > 0 then
				local v20 = true

				u16 = task.delay(v18, function() -- line: 55
					-- upvalues: u17 (ref), u16 (ref), v13 (copy), v19 (copy), v12 (copy), v20 (copy)
					u17 = true
					u16 = nil
					v13.current = v19
					v12(v20)
				end)
			elseif v11 ~= true then
				u17 = true
				v12(true)
			end
		else
			local v21 = v13.current - n1
			local v22 = n1

			if v21 > 0 then
				local v23 = false

				u16 = task.delay(v21, function() -- line: 55
					-- upvalues: u17 (ref), u16 (ref), v13 (copy), v22 (copy), v12 (copy), v23 (copy)
					u17 = true
					u16 = nil
					v13.current = v22
					v12(v23)
				end)
			elseif v11 ~= false then
				u17 = true
				v12(false)
			end
		end

		local v24 = v9

		return function() -- line: 74
			-- upvalues: u17 (ref), u16 (ref), v14 (copy), timestamp (copy), v24 (copy), v13 (copy), u8 (ref)
			if not u17 then
				if u16 then
					task.cancel(u16)
				end

				if not v14.current then
					local v30 = tick() - timestamp

					if not v24 then
						v30 *= -1
					end

					v13.current = math.clamp(v13.current + v30, 0, u8)
				end
			end

			v14.current = false
		end
	end, {
		v9,
		v11,
		n1,
		n2,
		u8
	})

	return v11, (React.useCallback(function(b2: boolean, b3: boolean?) -- line: 91
		-- upvalues: v14 (copy), v13 (copy), u8 (ref), v10 (copy)
		v14.current = b3

		if b3 then
			if b2 then
				v13.current = u8
			else
				v13.current = 0
			end
		end

		v10(b2)
	end, { v10 }))
end
