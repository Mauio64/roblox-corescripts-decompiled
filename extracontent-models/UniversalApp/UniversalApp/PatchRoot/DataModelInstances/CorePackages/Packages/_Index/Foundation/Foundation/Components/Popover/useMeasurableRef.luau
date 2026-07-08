local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(Foundation.Components.Types)

local React = require(FoundationParent.React)
local Signal = require(FoundationParent.Signal)

local function createSignal() -- line: 34
	-- upvalues: Signal (copy)
	local v7, v8 = Signal.createSignal()

	return {
		signal = {
			Connect = function(_, p2: ((...any) -> ...any)) -- line: 39
				-- upvalues: v7 (copy)
				local v23 = v7:subscribe(p2)

				return {
					Disconnect = function() -- line: 43
						-- upvalues: v23 (copy)
						v23:unsubscribe()
					end
				}
			end
		},
		fire = v8
	}
end

local t1 = {}

t1.__index = t1

function t1.new(vector2: Vector2, vector2_2: Vector2) -- line: 57
	-- upvalues: t1 (copy), createSignal (copy)
	local v11 = setmetatable({
		AbsolutePosition = vector2,
		AbsoluteSize = vector2_2,
		_signals = {}
	}, t1)

	v11._signals.AbsolutePosition = createSignal()
	v11._signals.AbsoluteSize = createSignal()

	return v11
end
function t1.GetPropertyChangedSignal(t2: {[any]: any}, s1: string) -- line: 70
	if t2._signals[s1] then
		return t2._signals[s1].signal
	end

	error(`{ s1 } is not a valid property name.`)
end
function t1.SetPosition(t3: {[any]: any}, vector2: Vector2) -- line: 77
	if vector2 ~= t3.AbsolutePosition then
		t3.AbsolutePosition = vector2
		t3._signals.AbsolutePosition.fire(vector2)
	end
end
function t1.SetSize(t4: {[any]: any}, vector2: Vector2) -- line: 84
	if vector2 ~= t4.AbsoluteSize then
		t4.AbsoluteSize = vector2
		t4._signals.AbsoluteSize.fire(vector2)
	end
end
function useMeasurableRef(vector2: Vector2, vector2_3: Vector2?) -- line: 91
	-- upvalues: React (copy), t1 (copy)
	local v20 = React.useRef(nil)

	if v20.current == nil then
		v20.current = t1.new(vector2, vector2_3 or Vector2.one)
	end

	React.useEffect(function() -- line: 97
		-- upvalues: v20 (copy), vector2 (copy)
		v20.current:SetPosition(vector2)
	end, { vector2 })
	React.useEffect(function() -- line: 101
		-- upvalues: v20 (copy), vector2_3 (copy)
		v20.current:SetSize(vector2_3 or Vector2.one)
	end, { vector2_3 })

	return v20
end

return useMeasurableRef
