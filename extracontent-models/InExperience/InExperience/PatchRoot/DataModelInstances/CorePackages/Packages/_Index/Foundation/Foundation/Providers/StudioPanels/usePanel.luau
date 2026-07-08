local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactUtils = require(FoundationParent.ReactUtils)
local Flags = require(Foundation.Utility.Flags)

require(Foundation.Utility.Plugin.StudioUri)
require(script.Parent.Types)

local function usePanel(t1: {[any]: any}) -- line: 15
	-- upvalues: React (copy), ReactUtils (copy), Flags (copy)
	local v8 = React.useRef(nil)
	local v9 = ReactUtils.useRefToState({
		anchorUri = t1.anchorUri,
		position = t1.position,
		depth = t1.depth,
		parentPopoverId = t1.parentPopoverId
	})
	local v10 = React.useRef(t1.onClose)

	v10.current = t1.onClose

	local v11 = React.useRef(t1.registerPanelAsync)

	v11.current = t1.registerPanelAsync

	local u16

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		local v12, v13 = React.useState(false)
		local v14 = React.useCallback(function() -- line: 51
			-- upvalues: v13 (copy), v10 (copy)
			v13(true)
			v10.current()
		end, {})
		local v15 = ReactUtils.useAsync(function() -- line: 56
			-- upvalues: t1 (copy), v12 (copy), v11 (copy), v9 (copy), v14 (copy), v8 (copy)
			if t1.isOpen and not v12 then
				local v18, v19 = v11.current(v9.current.anchorUri, v9.current.position, v14, v9.current.depth, v9.current.parentPopoverId)

				v8.current = v19

				return v18
			end

			if v8.current then
				v8.current()
				v8.current = nil
			end

			return nil
		end, {
			t1.isOpen,
			v9,
			v12
		})

		u16 = if v12 or v15.status ~= "ok" then nil else v15.value
		React.useEffect(function() -- line: 81
			-- upvalues: t1 (copy), v13 (copy)
			if not t1.isOpen then
				v13(false)
			end
		end, { t1.isOpen })
	else
		local v17 = ReactUtils.useAsync(function() -- line: 87
			-- upvalues: t1 (copy), v11 (copy), v9 (copy), v10 (copy), v8 (copy)
			if t1.isOpen then
				local v20, v21 = v11.current(v9.current.anchorUri, v9.current.position, v10.current, v9.current.depth, v9.current.parentPopoverId)

				v8.current = v21

				return v20
			end

			if v8.current then
				v8.current()
				v8.current = nil
			end

			return nil
		end, {
			t1.isOpen,
			v9
		})

		u16 = if v17.status ~= "ok" then nil else v17.value
	end

	ReactUtils.useAsync(function() -- line: 111
		-- upvalues: u16 (ref), t1 (copy)
		if not u16 then
			return nil
		end

		u16.updateAsync({
			targetWidgetUri = t1.anchorUri,
			targetAnchorPoint = t1.position.targetAnchorPoint,
			subjectAnchorPoint = t1.position.subjectAnchorPoint,
			offset = t1.position.offset
		})

		return nil
	end, {
		u16,
		t1.anchorUri,
		t1.position
	})
	React.useEffect(function() -- line: 124
		-- upvalues: v8 (copy)
		return function() -- line: 125
			-- upvalues: v8 (copy)
			if v8.current then
				v8.current()
			end
		end
	end, {})

	return u16
end

return usePanel
