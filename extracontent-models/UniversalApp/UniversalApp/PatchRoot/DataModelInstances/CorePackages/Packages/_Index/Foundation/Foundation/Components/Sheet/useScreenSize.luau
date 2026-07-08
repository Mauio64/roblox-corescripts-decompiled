local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Flags = require(Foundation.Utility.Flags)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local useScreen = require(Foundation.Providers.Overlay.useScreen)

local function useScreenSize() -- line: 9
	-- upvalues: Flags (copy), useScreen (copy), useOverlay (copy), React (copy)
	local v8 = if not Flags.FoundationOverlayKeyboardAwarenessHardened then useOverlay() else useScreen()
	local v9, v10 = React.useState(v8 and v8.AbsoluteSize or Vector2.new(0, 0))

	React.useLayoutEffect(function() -- line: 13
		-- upvalues: v8 (copy), v10 (copy)
		local connection = nil

		if v8 then
			v10(v8.AbsoluteSize)
			connection = v8:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 18
				-- upvalues: v10 (copy), v8 (copy)
				v10(v8.AbsoluteSize)
			end)
		end

		return function() -- line: 23
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { v8 })

	return v9
end

return useScreenSize
