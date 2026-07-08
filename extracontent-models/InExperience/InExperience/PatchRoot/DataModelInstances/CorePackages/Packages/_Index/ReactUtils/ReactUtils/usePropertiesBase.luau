local Parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(Parent.React)
local Array = require(Parent.LuauPolyfill).Array
local useForwardRef = require(script.Parent.useForwardRef)

local function usePropertiesBase(p1, p2: ((...any) -> ...any), b1: boolean, ...) -- line: 15
	-- upvalues: Array (copy), React (copy), useForwardRef (copy)
	local v9 = Array.concat({}, ...)
	local v10 = React.useCallback(function(p3) -- line: 23
		-- upvalues: p2 (copy), Array (copy), v9 (copy), b1 (copy)
		local function onPropChange() -- line: 24
			-- upvalues: p2 (copy), Array (copy), v9 (copy), p3 (copy)
			p2(table.unpack(Array.map(v9, function(p4) -- line: 25
				-- upvalues: p3 (copy)
				return p3[p4]
			end)))
		end

		local u13 = nil

		local function v14() -- line: 31
			-- upvalues: u13 (ref), p2 (copy), Array (copy), v9 (copy), p3 (copy)
			if not u13 then
				u13 = task.defer(function() -- line: 33
					-- upvalues: u13 (ref), p2 (copy), Array (copy), v9 (copy), p3 (copy)
					u13 = nil
					p2(table.unpack(Array.map(v9, function(p5) -- line: 25
						-- upvalues: p3 (copy)
						return p3[p5]
					end)))
				end)
			end
		end

		local v15 = Array.map(v9, function(p6) -- line: 39
			-- upvalues: p3 (copy), b1 (copy), v14 (copy), onPropChange (copy)
			return p3:GetPropertyChangedSignal(p6):Connect(if not b1 then onPropChange else v14)
		end)

		p2(table.unpack(Array.map(v9, function(p7) -- line: 25
			-- upvalues: p3 (copy)
			return p3[p7]
		end)))

		return function() -- line: 45
			-- upvalues: v15 (copy), u13 (ref)
			for _, v19 in v15 do
				v19:Disconnect()
			end

			if u13 then
				task.cancel(u13)
			end
		end
	end, {
		p2,
		table.concat(v9, ",")
	})

	return useForwardRef(p1, v10)
end

return usePropertiesBase
