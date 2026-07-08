local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Enums.DialogSize)

local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local useTokens = require(Foundation.Providers.Style.useTokens)
local getResponsiveSize = require(script.Parent.getResponsiveSize)
local useDialog = require(script.Parent.useDialog)

local function useDialogResponsiveSize(p1) -- line: 16
	-- upvalues: useTokens (copy), useOverlay (copy), useDialog (copy), React (copy), getResponsiveSize (copy)
	local v10 = useTokens()
	local v11 = useOverlay()
	local v12 = useDialog()
	local v13 = React.useCallback(function() -- line: 21
		-- upvalues: v11 (copy), v12 (copy), getResponsiveSize (copy), p1 (copy), v10 (copy)
		if not v11 then
			return
		end

		v12.setResponsiveSize(getResponsiveSize(v11.AbsoluteSize.X, p1, v10))
	end, {
		v11,
		p1,
		v10,
		v12.size
	})

	React.useLayoutEffect(function() -- line: 28
		-- upvalues: v11 (copy), v13 (copy)
		if not v11 then
			return
		end

		v13()

		local connection = v11:GetPropertyChangedSignal("AbsoluteSize"):Connect(v13)

		return function() -- line: 37
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v11,
		p1,
		v13
	})
end

return useDialogResponsiveSize
