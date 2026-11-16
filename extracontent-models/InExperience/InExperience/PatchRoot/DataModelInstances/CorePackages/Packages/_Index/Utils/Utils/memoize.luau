local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local WeakMap = LuauPolyfill.WeakMap

local Memoize = {
	memoize1 = function(callback)
		local v = WeakMap.new()

		return function(p)
			local v2 = v:get(p)

			if v2 ~= nil then
				return v2
			end

			local v3 = callback(p)

			v:set(p, v3)
			return v3
		end
	end,
	memoize2 = function(callback)
		local v = WeakMap.new()

		return function(p, p2)
			local v2 = v:get(p)

			if Boolean.toJSBoolean(v2) then
				local v3 = v2:get(p2)

				if v3 ~= nil then
					return v3
				end

				local v4 = callback(p, p2)

				v2:set(p2, v4)
				return v4
			else
				local v3 = WeakMap.new()
				v:set(p, v3)

				local v4 = callback(p, p2)

				v3:set(p2, v4)
				return v4
			end
		end
	end,
	memoize3 = function(callback)
		local v = WeakMap.new()

		return function(p, p2, p3)
			local v2 = v:get(p)

			if Boolean.toJSBoolean(v2) then
				local v3 = v2:get(p2)

				if Boolean.toJSBoolean(v3) then
					local v4 = v3:get(p3)

					if v4 ~= nil then
						return v4
					end

					local v5 = callback(p, p2, p3)

					v3:set(p3, v5)
					return v5
				else
					local v4 = WeakMap.new()
					v2:set(p2, v4)

					local v5 = callback(p, p2, p3)

					v4:set(p3, v5)
					return v5
				end
			else
				local v3 = WeakMap.new()
				v:set(p, v3)
				local v4 = WeakMap.new()
				v3:set(p2, v4)

				local v5 = callback(p, p2, p3)

				v4:set(p3, v5)
				return v5
			end
		end
	end,
	memoize4 = function(callback)
		local v = WeakMap.new()

		return function(p, p2, p3, p4)
			local v2 = v:get(p)

			if Boolean.toJSBoolean(v2) then
				local v3 = v2:get(p2)

				if Boolean.toJSBoolean(v3) then
					local v4 = v3:get(p3)

					if Boolean.toJSBoolean(v4) then
						local v5 = v4:get(p4)

						if v5 ~= nil then
							return v5
						end

						local v6 = callback(p, p2, p3, p4)

						v4:set(p4, v6)
						return v6
					else
						local v5 = WeakMap.new()

						v3:set(p3, v5)

						local v6 = callback(p, p2, p3, p4)

						v5:set(p4, v6)
						return v6
					end
				else
					local v4 = WeakMap.new()
					v2:set(p2, v4)
					local v5 = WeakMap.new()
					v4:set(p3, v5)

					local v6 = callback(p, p2, p3, p4)

					v5:set(p4, v6)
					return v6
				end
			else
				local v3 = WeakMap.new()
				v:set(p, v3)
				local v4 = WeakMap.new()
				v3:set(p2, v4)
				local v5 = WeakMap.new()
				v4:set(p3, v5)

				local v6 = callback(p, p2, p3, p4)

				v5:set(p4, v6)
				return v6
			end
		end
	end,
	memoize5 = function(callback)
		local v = WeakMap.new()

		return function(p, p2, p3, p4, p5)
			local v2 = v:get(p)

			if Boolean.toJSBoolean(v2) then
				local v3 = v2:get(p2)

				if Boolean.toJSBoolean(v3) then
					local v4 = v3:get(p3)

					if Boolean.toJSBoolean(v4) then
						local v5 = v4:get(p4)

						if Boolean.toJSBoolean(v5) then
							local v6 = v5:get(p5)

							if v6 ~= nil then
								return v6
							end

							local v7 = callback(p, p2, p3, p4, p5)

							v5:set(p5, v7)
							return v7
						else
							local v6 = WeakMap.new()
							v4:set(p4, v6)

							local v7 = callback(p, p2, p3, p4, p5)

							v6:set(p5, v7)
							return v7
						end
					else
						local v5 = WeakMap.new()
						v3:set(p3, v5)
						local v6 = WeakMap.new()
						v5:set(p4, v6)

						local v7 = callback(p, p2, p3, p4, p5)

						v6:set(p5, v7)
						return v7
					end
				else
					local v4 = WeakMap.new()
					v2:set(p2, v4)
					local v5 = WeakMap.new()
					v4:set(p3, v5)
					local v6 = WeakMap.new()
					v5:set(p4, v6)

					local v7 = callback(p, p2, p3, p4, p5)

					v6:set(p5, v7)
					return v7
				end
			else
				local v3 = WeakMap.new()
				v:set(p, v3)
				local v4 = WeakMap.new()
				v3:set(p2, v4)
				local v5 = WeakMap.new()
				v4:set(p3, v5)
				local v6 = WeakMap.new()
				v5:set(p4, v6)

				local v7 = callback(p, p2, p3, p4, p5)

				v6:set(p5, v7)
				return v7
			end
		end
	end
}

local v = WeakMap.new()
function Memoize.memoize2of4(callback)
	return function(p, p2, p3, p4)
		local v2 = v:get(p)

		if Boolean.toJSBoolean(v2) then
			local v3 = v2:get(p2)

			if v3 ~= nil then
				return v3
			end

			local v4 = callback(p, p2, p3, p4)

			v2:set(p2, v4)
			return v4
		else
			local v3 = WeakMap.new()
			v:set(p, v3)

			local v4 = callback(p, p2, p3, p4)

			v3:set(p2, v4)
			return v4
		end
	end
end
return Memoize
