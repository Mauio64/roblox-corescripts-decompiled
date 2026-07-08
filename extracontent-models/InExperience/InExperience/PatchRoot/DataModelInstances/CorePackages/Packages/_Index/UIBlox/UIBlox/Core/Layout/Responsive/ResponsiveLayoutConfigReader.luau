local ParentParent = script.Parent.Parent.Parent.Parent.Parent
local t = require(ParentParent.t)
local Array = require(ParentParent.LuauPolyfill).Array

local function hasValue(p1, p2) -- line: 28
	for _, v12 in p1 do
		if v12 == p2 then
			return true
		end
	end

	return false
end
local function matches(p3, p4) -- line: 37
	if p3 and p4 then
		if typeof(p4) == "table" then
			for _, v16 in p4 do
				if v16 == p3 then
					return true
				end
			end

			return false
		end

		return p4 == p3
	end

	return true
end
local function readValue(p5, p6, p7, p8, n1: number) -- line: 48
	-- upvalues: Array (copy), readValue (copy)
	local u22 = p5[p8]
	local u23 = u22 == nil and -1 or n1

	Array.forEach(p5, function(p9) -- line: 51
		-- upvalues: p6 (copy), p7 (copy), readValue (copy), p8 (copy), n1 (copy), u23 (ref), u22 (ref)
		local v41 = p6
		local breakpoint = p9.breakpoint
		local g52 = nil
		local v51 = nil
		local v45, g46

		if v41 and breakpoint then
			if typeof(breakpoint) == "table" then
				g46 = nil
				v45 = nil

				for _, v44 in breakpoint do
					if v44 == v41 then
						v45 = true
						g46 = true
					end

					if g46 then
						break
					end
				end

				if not g46 then
					v45 = false
				end
			else
				v45 = breakpoint == v41
			end
		else
			v45 = true
		end

		g46 = false

		if v45 then
			local v47 = p7
			local kind = p9.kind

			if v47 and kind then
				if typeof(kind) == "table" then
					for _, v50 in kind do
						if v50 == v47 then
							v51 = true
							g52 = true
						end

						if g52 then
							break
						end
					end

					if not g52 then
						v51 = false
					end
				else
					v51 = kind == v47
				end
			else
				v51 = true
			end

			g52 = false

			if v51 then
				local v53, v54 = readValue(p9, p6, p7, p8, n1 + 1)

				if v54 > u23 then
					u22 = v53
					u23 = v54
				end
			end
		end
	end)

	return u22, u23
end

local t1 = {
	name = "_default",
	min = 1e999,
	max = 0
}
local t2 = {
	[t.strictInterface({
		Scale = t.number,
		Offset = t.number
	})] = function(p10) -- line: 89
		return UDim.new(p10.Scale, p10.Offset)
	end
}

return {
	getValue = function(p11, p12) -- line: 95
		-- upvalues: Array (copy), readValue (copy), t2 (copy)
		local config = p11.config
		local breakpoint = p11.breakpoint
		local kind = p11.kind
		local u33 = config[p12]
		local u34 = u33 == nil and -1 or 0
		local n2 = 0

		Array.forEach(config, function(p13) -- line: 51
			-- upvalues: breakpoint (copy), kind (copy), readValue (copy), p12 (copy), n2 (copy), u34 (ref), u33 (ref)
			local v57 = breakpoint
			local breakpoint2 = p13.breakpoint
			local g68 = nil
			local v67 = nil
			local v61, g62

			if v57 and breakpoint2 then
				if typeof(breakpoint2) == "table" then
					g62 = nil
					v61 = nil

					for _, v60 in breakpoint2 do
						if v60 == v57 then
							v61 = true
							g62 = true
						end

						if g62 then
							break
						end
					end

					if not g62 then
						v61 = false
					end
				else
					v61 = breakpoint2 == v57
				end
			else
				v61 = true
			end

			g62 = false

			if v61 then
				local v63 = kind
				local kind2 = p13.kind

				if v63 and kind2 then
					if typeof(kind2) == "table" then
						for _, v66 in kind2 do
							if v66 == v63 then
								v67 = true
								g68 = true
							end

							if g68 then
								break
							end
						end

						if not g68 then
							v67 = false
						end
					else
						v67 = kind2 == v63
					end
				else
					v67 = true
				end

				g68 = false

				if v67 then
					local v69, v70 = readValue(p13, breakpoint, kind, p12, n2 + 1)

					if v70 > u34 then
						u33 = v69
						u34 = v70
					end
				end
			end
		end)

		local v36 = u33
		local _ = u34

		for v38, v39 in t2 do
			if v38(v36) then
				return v39(v36)
			end
		end

		return v36
	end,
	findBreakpoint = function(t3: {[any]: any}, p14) -- line: 69
		-- upvalues: Array (copy), t1 (copy)
		local v26 = Array.find(t3, function(p15) -- line: 70
			-- upvalues: p14 (copy)
			return type(p15) == "table" and (type(p15.breakpoint) == "string" and (p14 <= (p15.max or 1e999) and p14 >= (p15.min or 0)))
		end)

		if v26 then
			return {
				name = v26.breakpoint,
				min = v26.min or 0,
				max = v26.max or 1e999
			}
		end

		return t1
	end
}
