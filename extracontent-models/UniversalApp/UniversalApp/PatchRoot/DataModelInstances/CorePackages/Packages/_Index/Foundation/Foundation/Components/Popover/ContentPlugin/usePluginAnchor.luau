local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactRoblox = require(FoundationParent.ReactRoblox)
local OverlayContext = require(Foundation.Providers.Overlay.OverlayContext)

require(Foundation.Utility.Plugin.StudioUri)
require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useUniqueWidget = require(Foundation.Providers.StudioWidgets.useUniqueWidget)

local function usePluginAnchor(p1, p2) -- line: 19
	-- upvalues: React (copy), OverlayContext (copy), useUniqueWidget (copy), View (copy), ReactRoblox (copy)
	local v11 = React.useContext(OverlayContext)
	local v12 = p1 ~= nil and typeof(p1) ~= "Instance"
	local v13 = React.useRef(nil)

	if not v12 and typeof(p1) == "Instance" then
		v13.current = p1
	end

	local v14, v15 = React.useState(nil)
	local v16 = React.useRef(nil)

	v16.current = v14

	local v17 = React.useCallback(function(p3) -- line: 38
		-- upvalues: v15 (copy)
		v15(p3)
	end, { v15 })
	local v18 = useUniqueWidget({
		forwardRef = if not v12 then v13 else v16
	})
	local v19, v20 = React.useState(Vector2.zero)
	local v21, v22 = React.useState(Vector2.one)
	local v23, v24 = React.useState(Vector2.zero)

	React.useLayoutEffect(function() -- line: 50
		-- upvalues: v12 (copy), p1 (copy), v20 (copy), v22 (copy)
		if not v12 or p1 == nil then
			return
		end

		local v29 = p1

		local function updateFromAnchor() -- line: 56
			-- upvalues: v20 (copy), v29 (copy), v22 (copy)
			v20(v29.AbsolutePosition)
			v22(v29.AbsoluteSize)
		end

		v20(v29.AbsolutePosition)
		v22(v29.AbsoluteSize)

		local connection = v29:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateFromAnchor)
		local connection2 = v29:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateFromAnchor)

		return function() -- line: 66
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, {
		p1,
		v12
	})
	React.useLayoutEffect(function() -- line: 72
		-- upvalues: v12 (copy), v11 (copy)
		if v12 then
			v11.requestOverlay()
		end
	end, {
		v11.requestOverlay,
		v12
	})
	React.useLayoutEffect(function() -- line: 78
		-- upvalues: v12 (copy), v11 (copy), v24 (copy)
		if not v12 then
			return
		end

		local instance = v11.instance

		if instance == nil or not instance:IsA("GuiObject") then
			v24(Vector2.zero)

			return
		end

		local function updateOffset() -- line: 89
			-- upvalues: v24 (copy), instance (copy)
			v24(instance.AbsolutePosition)
		end

		v24(instance.AbsolutePosition)

		local connection = instance:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateOffset)

		return function() -- line: 95
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v11.instance,
		v12
	})

	local v25 = p1 ~= nil and (not v12 or v11.instance ~= nil)
	local v26 = nil

	if v12 and v11.instance then
		local v27 = React.createElement(View, {
			Visible = true,
			Position = UDim2.fromOffset(v19.X - v23.X, v19.Y - v23.Y),
			Size = UDim2.fromOffset(v21.X, v21.Y),
			ref = v17
		})

		v26 = ReactRoblox.createPortal(v27, v11.instance)
	end

	return {
		uri = if p2 == nil then v18.uri else p2,
		element = v26,
		isVirtual = v12,
		isReady = p2 ~= nil or v25
	}
end

return usePluginAnchor
