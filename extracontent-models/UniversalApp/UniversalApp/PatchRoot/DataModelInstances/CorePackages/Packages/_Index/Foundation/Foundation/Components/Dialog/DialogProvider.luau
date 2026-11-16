local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Enums.DialogSize)

local getResponsiveSize = require(script.Parent.getResponsiveSize)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local useTokens = require(Foundation.Providers.Style.useTokens)

local DialogContext = require(script.Parent.DialogContext)

local function DialogProvider(props)
	local v = useOverlay()
	local v2 = useTokens()

	local state, setState = React.useState(function()
		if v then
			return getResponsiveSize(v.AbsoluteSize.X, props.size, v2)
		end

		return props.responsiveSize or props.size
	end)

	local state2, setState2 = React.useState(props.hasHeroMedia)

	local ref = React.useRef(nil)
	local state3, setState3 = React.useState(nil)

	local v3 = React.useMemo(function()
		return {
			size = props.size,
			responsiveSize = state,
			setResponsiveSize = setState,
			hasHeroMedia = state2,
			setHasHeroMedia = setState2,
			testId = props.testId,
			closeAffordanceRef = ref,
			contentStartRef = state3,
			setContentStartRef = setState3
		}
	end, { props.size, state, state2, props.testId, state3 })

	return React.createElement(DialogContext.Provider, { value = v3 }, props.children)
end

return DialogProvider
