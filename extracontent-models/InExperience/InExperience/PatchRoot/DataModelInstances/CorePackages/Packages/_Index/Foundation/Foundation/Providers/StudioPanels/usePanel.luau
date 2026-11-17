local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

local Flags = require(Foundation.Utility.Flags)
require(Foundation.Utility.Plugin.StudioUri)

require(script.Parent.Types)

local function usePanel(data)
	local ref = React.useRef(nil)
	local useRefToState = ReactUtils.useRefToState
	local v = {
		anchorUri = data.anchorUri,
		position = data.position,
		depth = data.depth,
		parentPopoverId = data.parentPopoverId,
		isFocusable = 0,
		initialSize = 0
	}
	local isFocusable2

	if Flags.FoundationPopoverPluginFocusable then
		isFocusable2 = data.isFocusable
	end

	v.isFocusable = isFocusable2
	local initialSize

	if Flags.FoundationPopoverPluginPoolReclaim then
		initialSize = data.initialSize
	end

	v.initialSize = initialSize
	local v2 = useRefToState(v)

	local ref2 = React.useRef(data.onClose)
	ref2.current = data.onClose

	local ref3 = React.useRef(data.registerPanelAsync)
	ref3.current = data.registerPanelAsync

	local state, setState = React.useState(false)

	local v3 = React.useCallback(function()
		setState(true)
		ref2.current()
	end, {})

	local v4 = ReactUtils.useAsync(function()
		if data.isOpen and not state then
			local current = ref3.current
			local anchorUri = v2.current.anchorUri
			local position = v2.current.position

			local depth = v2.current.depth
			local parentPopoverId = v2.current.parentPopoverId
			local isFocusable

			if Flags.FoundationPopoverPluginFocusable then
				isFocusable = v2.current.isFocusable
			end

			local v4

			if Flags.FoundationPopoverPluginPoolReclaim then
				v4 = v2.current.initialSize
			end

			local v5, current2 = current(anchorUri, position, v3, depth, parentPopoverId, isFocusable, v4)

			ref.current = current2
			return v5
		end

		if ref.current then
			ref.current()
			ref.current = nil
		end

		return nil
	end, { data.isOpen, v2, state })
	local value

	if state or v4.status ~= "ok" then
		value = nil
	else
		value = v4.value
	end

	React.useEffect(function()
		if not data.isOpen then
			setState(false)
		end
	end, { data.isOpen })

	ReactUtils.useAsync(function(): nil
		if not value then
			return nil
		end

		value.updateAsync({
			targetWidgetUri = data.anchorUri,
			targetAnchorPoint = data.position.targetAnchorPoint,
			subjectAnchorPoint = data.position.subjectAnchorPoint,
			offset = data.position.offset
		})

		return nil
	end, { value, data.anchorUri, data.position })

	React.useEffect(function()
		return function()
			if ref.current then
				ref.current()
			end
		end
	end, {})

	return value
end

return usePanel
