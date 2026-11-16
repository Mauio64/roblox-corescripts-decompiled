local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local OverlayContext = require(Foundation.Providers.Overlay.OverlayContext)
require(Foundation.Utility.Plugin.StudioUri)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useUniqueWidget = require(Foundation.Providers.StudioWidgets.useUniqueWidget)

local function usePluginAnchor(current, p)
	local v = React.useContext(OverlayContext)
	local isVirtual

	if current == nil then
		isVirtual = false
	else
		isVirtual = typeof(current) ~= "Instance"
	end

	local forwardRef = React.useRef(nil)

	if not isVirtual and typeof(current) == "Instance" then
		forwardRef.current = current
	end

	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	ref.current = state

	local ref2 = React.useCallback(function(p2)
		setState(p2)
	end, { setState })

	if isVirtual then
		forwardRef = ref
	end

	local v2 = useUniqueWidget({ forwardRef = forwardRef })

	local state2, setState2 = React.useState(Vector2.zero)
	local state3, setState3 = React.useState(Vector2.one)
	local state4, setState4 = React.useState(Vector2.zero)

	React.useLayoutEffect(function()
		if not isVirtual or current == nil then
			return
		end

		local current2 = current
		local function updateFromAnchor() -- 1 equivalent call inferred from this helper
			setState2(current2.AbsolutePosition)
			setState3(current2.AbsoluteSize)
		end

		updateFromAnchor() -- inferred equivalent call
		local absolutePositionChangedConnection = current2:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateFromAnchor)
		local absoluteSizeChangedConnection = current2:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateFromAnchor)

		return function()
			absolutePositionChangedConnection:Disconnect()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { current, isVirtual })

	React.useLayoutEffect(function()
		if isVirtual then
			v.requestOverlay()
		end
	end, { v.requestOverlay, isVirtual })

	React.useLayoutEffect(function()
		if not isVirtual then
			return
		end

		local instance = v.instance

		if instance == nil or not instance:IsA("GuiObject") then
			setState4(Vector2.zero)
			return
		end

		local function updateOffset() -- 1 equivalent call inferred from this helper
			setState4(instance.AbsolutePosition)
		end

		updateOffset() -- inferred equivalent call
		local absolutePositionChangedConnection = instance:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateOffset)
		return function()
			absolutePositionChangedConnection:Disconnect()
		end
	end, { v.instance, isVirtual })
	local v3

	if current == nil then
		v3 = false
	else
		v3 = not isVirtual or v.instance ~= nil
	end

	local element2

	if isVirtual and v.instance then
		local element = React.createElement(View, {
			Position = UDim2.fromOffset(state2.X - state4.X, state2.Y - state4.Y),
			Size = UDim2.fromOffset(state3.X, state3.Y),
			Visible = true,
			ref = ref2
		})

		element2 = ReactRoblox.createPortal(element, v.instance)
	end

	local uri = if p == nil then v2.uri else p
	return {
		uri = uri,
		element = element2,
		isVirtual = isVirtual,
		isReady = p ~= nil or v3
	}
end

return usePluginAnchor
