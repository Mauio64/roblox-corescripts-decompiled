local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)

local function useInteraction(p1: ((...any) -> ...any)) -- line: 11
	-- upvalues: React (copy)
	local v5, v6 = React.useState(false)
	local v7, v8 = React.useState(false)

	return {
		onInputBegan = function(_, p3) -- line: 16
			-- upvalues: v6 (copy)
			if p3.UserInputType == Enum.UserInputType.MouseButton1 then
				v6(true)
			end
		end,
		onInputEnded = function(_, p5) -- line: 22
			-- upvalues: v5 (copy), v7 (copy), p1 (copy), v6 (copy)
			if p5.UserInputType == Enum.UserInputType.MouseButton1 then
				if v5 and v7 then
					p1()
				end

				v6(false)
			end
		end,
		onMouseEnter = function() -- line: 31
			-- upvalues: v8 (copy)
			v8(true)
		end,
		onMouseLeave = function() -- line: 35
			-- upvalues: v8 (copy), v6 (copy)
			v8(false)
			v6(false)
		end
	}, v5, v7
end

return useInteraction
