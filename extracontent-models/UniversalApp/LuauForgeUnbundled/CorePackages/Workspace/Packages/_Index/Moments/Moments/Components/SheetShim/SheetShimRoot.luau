local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactUtils")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/SheetShim/SheetShimTypes")
local getSheetStructure = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/SheetShim/getSheetStructure")
local useHiddenBackdrop = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/SheetShim/useHiddenBackdrop")
local useSheetContentInsets = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/SheetShim/useSheetContentInsets")

local useComposedRef = ReactUtils.useComposedRef

local function SheetShimRoot(props, p2)
	local state, setState = React.useState(nil)
	local v5 = React.useMemo(function()
		if state == nil then
			return nil
		end

		return (getSheetStructure(state))
	end, { state })
	local v6 = useSheetContentInsets(v5, props.onContentInsetChanged)
	useHiddenBackdrop(v5, props.hideBackdrop == true)

	local onClose = props.onClose
	local v7 = React.useCallback(function()
		v6()
		onClose()
	end, { v6, onClose })
	local v8 = useComposedRef(setState, p2)

	local clone = table.clone(props)
	clone.onContentInsetChanged = nil
	clone.hideBackdrop = nil
	clone.onClose = v7
	clone.ref = v8
	return React.createElement(Foundation.Sheet.Root, clone)
end

return React.forwardRef(SheetShimRoot)
