local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Constants = require(Foundation.Constants)
require(Foundation.Providers.StudioPanels.Types)
require(Foundation.Enums.PopoverAlign)
require(Foundation.Enums.PopoverSide)
local React = require(parent.React)
local positioning = require(script.Parent.Parent.positioning)

local SHADOW_SIZE = Constants.SHADOW_SIZE

local function useConnectSignals(instance, items, ref) -- 1 equivalent call inferred from this helper
	React.useLayoutEffect(function()
		local connections = {}

		if instance ~= nil then
			for _, propertyName in items do
				local propertyChangedSignal = instance:GetPropertyChangedSignal(propertyName)
				local v

				if type(ref) == "table" then
					v = function()
						ref.current()
					end
				else
					v = ref
				end

				connections[propertyName] = propertyChangedSignal:Connect(v)
			end
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { instance, ref })
end

local function usePanelSizing(p, p2, instance, value: number?, p3)
	local v, v2 = React.useBinding(UDim2.new())
	local v3, v4 = React.useBinding(UDim2.new())

	local ref = React.useRef(nil)
	local ref2 = React.useRef(function() end)

	local current = React.useCallback(function()
		if not instance then
			return
		end

		local absoluteSize = instance.AbsoluteSize

		local v5 = if type(p) == "table" then p.position else p
		local v6 = type(p) ~= "table" and 0 or p.offset

		local v7 = type(p2) ~= "table" and 0 or p2.offset

		local v8 = positioning.calculatePopoverBounds(v5, v6, v7, value or 0, absoluteSize) + Vector2.new(SHADOW_SIZE * 2, SHADOW_SIZE * 2)

		v4(UDim2.fromOffset(absoluteSize.X, absoluteSize.Y))
		v2(UDim2.fromOffset(v8.X, v8.Y))

		local _absolutePosition = instance.AbsolutePosition

		if p3 then
			if ref.current then
				task.cancel(ref.current)
			end

			ref.current = task.spawn(function()
				p3.setSizeAsync(v8)
			end)
		end
	end, { instance, p, p2, value, p3 })

	ref2.current = current
	useConnectSignals(instance, { "AbsoluteSize" }, ref2) -- inferred equivalent call

	React.useLayoutEffect(function()
		current()
	end, { current })

	React.useEffect(function()
		return function()
			if ref.current then
				task.cancel(ref.current)
			end
		end
	end, {})

	return v, v3
end

return usePanelSizing
