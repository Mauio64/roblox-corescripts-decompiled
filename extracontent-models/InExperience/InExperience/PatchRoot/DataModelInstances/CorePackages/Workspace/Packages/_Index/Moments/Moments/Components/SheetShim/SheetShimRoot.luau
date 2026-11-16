local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

require(script.Parent.SheetShimTypes)
local getSheetStructure = require(script.Parent.getSheetStructure)
local useHiddenBackdrop = require(script.Parent.useHiddenBackdrop)
local useSheetContentInsets = require(script.Parent.useSheetContentInsets)

local useComposedRef = ReactUtils.useComposedRef

local function SheetShimRoot(props, p)
	local state, setState = React.useState(nil)
	local v = React.useMemo(function()
		if state == nil then
			return nil
		end

		return (getSheetStructure(state))
	end, { state })
	local v2 = useSheetContentInsets(v, props.onContentInsetChanged)
	useHiddenBackdrop(v, props.hideBackdrop == true)

	local onClose = props.onClose
	local onClose2 = React.useCallback(function()
		v2()
		onClose()
	end, { v2, onClose })
	local ref = useComposedRef(setState, p)

	local clone = table.clone(props)
	clone.onContentInsetChanged = nil
	clone.hideBackdrop = nil
	clone.onClose = onClose2
	clone.ref = ref
	return React.createElement(Foundation.Sheet.Root, clone)
end

return React.forwardRef(SheetShimRoot)
