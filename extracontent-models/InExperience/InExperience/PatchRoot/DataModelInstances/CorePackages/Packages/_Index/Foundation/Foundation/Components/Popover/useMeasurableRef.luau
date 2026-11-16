local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
require(Foundation.Components.Types)

local React = require(parent.React)
local Signal = require(parent.Signal)

local function createSignal()
	local signal, fire = Signal.createSignal()

	local signal2 = {}

	function signal2.Connect(_, callback)
		local v = signal:subscribe(callback)

		return {
			Disconnect = function()
				v:unsubscribe()
			end
		}
	end

	return { signal = signal2, fire = fire }
end

local class = {}
class.__index = class

function class.new(absolutePosition: Vector2, absoluteSize: Vector2)
	local self = setmetatable(
		{ AbsolutePosition = absolutePosition, AbsoluteSize = absoluteSize, _signals = {} },
		class
	)

	self._signals.AbsolutePosition = createSignal()
	self._signals.AbsoluteSize = createSignal()

	return self
end

function class:GetPropertyChangedSignal(p: string)
	if self._signals[p] then
		return self._signals[p].signal
	end

	error(`{p} is not a valid property name.`)
end

function class:SetPosition(absolutePosition: Vector2)
	if self.AbsolutePosition ~= absolutePosition then
		self.AbsolutePosition = absolutePosition
		self._signals.AbsolutePosition.fire(absolutePosition)
	end
end

function class:SetSize(absoluteSize: Vector2)
	if self.AbsoluteSize ~= absoluteSize then
		self.AbsoluteSize = absoluteSize
		self._signals.AbsoluteSize.fire(absoluteSize)
	end
end

function useMeasurableRef(vector2: Vector2, vector2_2: Vector2?)
	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = class.new(vector2, vector2_2 or Vector2.one)
	end

	React.useEffect(function()
		ref.current:SetPosition(vector2)
	end, { vector2 })

	React.useEffect(function()
		ref.current:SetSize(vector2_2 or Vector2.one)
	end, { vector2_2 })

	return ref
end

return useMeasurableRef
