local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Wrappers = require(Foundation.Utility.Wrappers)
local Signal = Wrappers.Signal
local Connection = Wrappers.Connection

local function usePointerPosition(data)
	local v, v2 = React.useBinding(Vector2.zero)

	React.useEffect(function()
		if not data then
			return
		end

		local function setPositionFromInput(p)
			if p.Position.X > 0 or p.Position.Y > 0 then
				v2(Vector2.new(p.Position.X, p.Position.Y))
			end
		end

		local v3 = {
			Signal.Connect(data.InputBegan, setPositionFromInput),
			Signal.Connect(data.InputChanged, setPositionFromInput),
			Signal.Connect(data.InputEnded, setPositionFromInput)
		}

		return function()
			for _, v4 in v3 do
				Connection.Disconnect(v4)
			end
		end
	end, { data })

	return v
end

return usePointerPosition
