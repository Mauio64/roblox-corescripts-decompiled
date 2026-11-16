local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)

require(Foundation.Enums.DialogSize)

local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local useTokens = require(Foundation.Providers.Style.useTokens)

local getResponsiveSize = require(script.Parent.getResponsiveSize)
local useDialog = require(script.Parent.useDialog)

local function useDialogResponsiveSize(p)
	local v = useTokens()
	local v2 = useOverlay()
	local v3 = useDialog()

	local v4 = React.useCallback(function()
		if not v2 then
			return
		end

		v3.setResponsiveSize(getResponsiveSize(v2.AbsoluteSize.X, p, v))
	end, { v2, p, v, v3.size })

	React.useLayoutEffect(function()
		if not v2 then
			return
		end

		v4()

		local absoluteSizeChangedConnection = v2:GetPropertyChangedSignal("AbsoluteSize"):Connect(v4)

		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { v2, p, v4 })
end

return useDialogResponsiveSize
