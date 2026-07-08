local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactUtils = require(FoundationParent.ReactUtils)
local Flags = require(Foundation.Utility.Flags)
local BottomSheet = require(script.Parent.BottomSheet)
local CenterSheet = require(script.Parent.CenterSheet)
local SideSheet = require(script.Parent.SideSheet)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local useScreen = require(Foundation.Providers.Overlay.useScreen)
local GuiService = require(Foundation.Utility.Wrappers).Services.GuiService

require(Foundation.Enums.DialogSize)

local withDefaults = require(Foundation.Utility.withDefaults)

require(script.Parent.Types)

local t1 = {
	testId = "--foundation-sheet"
}

local function Sheet(p1, p2) -- line: 26
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), Flags (copy), useScreen (copy), useOverlay (copy), GuiService (copy), ReactUtils (copy), BottomSheet (copy), CenterSheet (copy), SideSheet (copy)
	local v17 = withDefaults(p1, t1)
	local v18, v19 = React.useState(v17.isOpen == nil or v17.isOpen)
	local v20 = React.useRef(nil)
	local v21 = if not Flags.FoundationOverlayKeyboardAwarenessHardened then useOverlay() else useScreen()
	local v22, v23 = React.useState(not v21 or v21.AbsoluteSize.X > v21.AbsoluteSize.Y)
	local v24, v25 = React.useState(GuiService.ViewportDisplaySize)

	React.useImperativeHandle(v17.sheetRef, function() -- line: 36
		-- upvalues: v20 (copy)
		return v20.current
	end, {})
	React.useEffect(function() -- line: 40
		-- upvalues: v17 (copy), v20 (copy), v19 (copy)
		if v17.isOpen == false and v20.current then
			v20.current.close()

			return
		end

		if v17.isOpen then
			v19(true)
		end
	end, { v17.isOpen })
	React.useEffect(function() -- line: 48
		-- upvalues: v18 (copy), v17 (copy), v19 (copy)
		if not v18 and v17.isOpen then
			v19(true)
		end
	end, { v18 })
	ReactUtils.useEventConnection(GuiService:GetPropertyChangedSignal("ViewportDisplaySize"), function() -- line: 54
		-- upvalues: v25 (copy), GuiService (copy)
		v25(GuiService.ViewportDisplaySize)
	end, {})
	React.useLayoutEffect(function() -- line: 58
		-- upvalues: v21 (copy), v23 (copy)
		local connection = nil

		if v21 then
			v23(v21.AbsoluteSize.X > v21.AbsoluteSize.Y)
			connection = v21:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 62
				-- upvalues: v23 (copy), v21 (copy)
				v23(v21.AbsoluteSize.X > v21.AbsoluteSize.Y)
			end)
		end

		return function() -- line: 67
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { v21 })

	if not v18 then
		return nil
	end

	local v26 = table.clone(v17)

	v26.isOpen = nil
	v26.ref = p2
	v26.sheetRef = v20
	v26.displaySize = v24

	function v26.onClose() -- line: 83
		-- upvalues: v17 (copy), v19 (copy)
		if v17.onClose then
			v17.onClose()
		end

		v19(false)
	end

	if v24 == Enum.DisplaySize.Small and not v22 then
		return React.createElement(BottomSheet, v26)
	end

	if v17.preferCenterSheet then
		return React.createElement(CenterSheet, v26)
	end

	return React.createElement(SideSheet, v26)
end

return React.memo(React.forwardRef(Sheet))
