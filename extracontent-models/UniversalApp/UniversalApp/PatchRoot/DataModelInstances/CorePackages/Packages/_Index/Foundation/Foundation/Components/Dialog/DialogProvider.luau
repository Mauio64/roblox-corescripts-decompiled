local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Enums.DialogSize)

local getResponsiveSize = require(script.Parent.getResponsiveSize)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local useTokens = require(Foundation.Providers.Style.useTokens)
local DialogContext = require(script.Parent.DialogContext)

local function DialogProvider(t1: {[any]: any}) -- line: 23
	-- upvalues: useOverlay (copy), useTokens (copy), React (copy), getResponsiveSize (copy), DialogContext (copy)
	local v10 = useOverlay()
	local v11 = useTokens()
	local v12, v13 = React.useState(function() -- line: 27
		-- upvalues: v10 (copy), getResponsiveSize (copy), t1 (copy), v11 (copy)
		if v10 then
			return getResponsiveSize(v10.AbsoluteSize.X, t1.size, v11)
		end

		return t1.responsiveSize or t1.size
	end)
	local v14, v15 = React.useState(t1.hasHeroMedia)
	local v16 = React.useRef(nil)
	local v17, v18 = React.useState(nil)

	return React.createElement(DialogContext.Provider, {
		value = {
			size = t1.size,
			responsiveSize = v12,
			setResponsiveSize = v13,
			hasHeroMedia = v14,
			setHasHeroMedia = v15,
			testId = t1.testId,
			closeAffordanceRef = v16,
			contentStartRef = v17,
			setContentStartRef = v18
		}
	}, t1.children)
end

return DialogProvider
