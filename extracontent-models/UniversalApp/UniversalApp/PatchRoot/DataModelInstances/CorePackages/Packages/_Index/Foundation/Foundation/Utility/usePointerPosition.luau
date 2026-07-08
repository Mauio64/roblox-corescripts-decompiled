local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Wrappers = require(Foundation.Utility.Wrappers)
local Signal = Wrappers.Signal
local Connection = Wrappers.Connection

local function usePointerPosition(p1) -- line: 10
	-- upvalues: React (copy), Signal (copy), Connection (copy)
	local v9, v10 = React.useBinding(Vector2.zero)

	React.useEffect(function() -- line: 13
		-- upvalues: p1 (copy), v10 (copy), Signal (copy), Connection (copy)
		if not p1 then
			return
		end

		local function setPositionFromInput(p2) -- line: 18
			-- upvalues: v10 (copy)
			if p2.Position.X > 0 or p2.Position.Y > 0 then
				v10(Vector2.new(p2.Position.X, p2.Position.Y))
			end
		end

		local t1 = {
			Signal.Connect(p1.InputBegan, setPositionFromInput),
			Signal.Connect(p1.InputChanged, setPositionFromInput),
			Signal.Connect(p1.InputEnded, setPositionFromInput)
		}

		return function() -- line: 30
			-- upvalues: t1 (copy), Connection (copy)
			for _, v15 in t1 do
				Connection.Disconnect(v15)
			end
		end
	end, { p1 })

	return v9
end

return usePointerPosition
