local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Flags = require(Foundation.Utility.Flags)
local Wrappers = require(Foundation.Utility.Wrappers)
local Connection = Wrappers.Connection
local instance = Wrappers.Instance
local Signal = Wrappers.Signal

local function useClippingRect(p)
	local v, v2 = React.useBinding(Rect.new(Vector2.zero, Vector2.zero))

	local state, setState = React.useState(true)

	React.useEffect(function()
		local current = p.current

		if not (current and current:IsA("GuiObject")) then
			return
		end

		local parent2 = current.Parent
		local v3 = nil

		while parent2 do
			if parent2:IsA("GuiObject") and parent2.ClipsDescendants then
				v3 = parent2
				break
			end

			parent2 = parent2.Parent
		end

		if Flags.FoundationUnifiedScrimScrolling then
			setState(v3 ~= nil)
		end

		if not v3 then
			if Flags.FoundationUnifiedScrimScrolling then
				v3 = current
			else
				local layerCollector = current:FindFirstAncestorWhichIsA("LayerCollector")

				if layerCollector and layerCollector:IsA("GuiBase2d") then
					v3 = layerCollector
				end
			end
		end

		local function update() -- 1 equivalent call inferred from this helper
			if v3 then
				local absolutePosition = current.AbsolutePosition
				v2(Rect.new(
					v3.AbsolutePosition - absolutePosition,
					v3.AbsolutePosition + v3.AbsoluteSize - absolutePosition
				))
			end
		end

		local v4 = { Signal.Connect(instance.GetPropertyChangedSignal(current, "AbsolutePosition"), update) }

		if v3 then
			table.insert(v4, Signal.Connect(instance.GetPropertyChangedSignal(v3, "AbsolutePosition"), update))

			table.insert(v4, Signal.Connect(instance.GetPropertyChangedSignal(v3, "AbsoluteSize"), update))
		end

		update() -- inferred equivalent call
		return function()
			for _, v5 in v4 do
				Connection.Disconnect(v5)
			end
		end
	end, {})

	return v, state
end

return useClippingRect
