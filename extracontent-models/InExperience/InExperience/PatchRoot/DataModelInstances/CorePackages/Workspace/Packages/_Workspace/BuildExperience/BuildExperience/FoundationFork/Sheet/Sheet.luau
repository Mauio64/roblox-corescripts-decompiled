local CorePackages = game:GetService("CorePackages")
local foundation = CorePackages.Packages._Index.Foundation.Foundation
local parent = foundation.Parent
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

local BottomSheet = require(script.Parent.BottomSheet)
local CenterSheet = require(script.Parent.CenterSheet)
local SideSheet = require(script.Parent.SideSheet)
local useScreen = require(foundation.Providers.Overlay.useScreen)
local Wrappers = require(foundation.Utility.Wrappers)
local GuiService = Wrappers.Services.GuiService
require(foundation.Enums.DialogSize)
local withDefaults = require(foundation.Utility.withDefaults)

require(script.Parent.Types)

local v = { testId = "--foundation-sheet" }

local function Sheet(p, ref)
	local v2 = withDefaults(p, v)
	local state, setState = React.useState(v2.isOpen == nil or v2.isOpen)
	local ref2 = React.useRef(nil)
	local v3 = useScreen()

	local state2, setState2 = React.useState(not v3 or v3.AbsoluteSize.X > v3.AbsoluteSize.Y)
	local state3, setState3 = React.useState(GuiService.ViewportDisplaySize)

	React.useImperativeHandle(v2.sheetRef, function()
		return ref2.current
	end, {})

	React.useEffect(function()
		if v2.isOpen == false and ref2.current then
			ref2.current.close()
		elseif v2.isOpen then
			setState(true)
		end
	end, { v2.isOpen })

	React.useEffect(function()
		if not state and v2.isOpen then
			setState(true)
		end
	end, { state })

	ReactUtils.useEventConnection(GuiService:GetPropertyChangedSignal("ViewportDisplaySize"), function()
		setState3(GuiService.ViewportDisplaySize)
	end, {})

	React.useLayoutEffect(function()
		local absoluteSizeChangedConnection

		if v3 then
			setState2(v3.AbsoluteSize.X > v3.AbsoluteSize.Y)
			absoluteSizeChangedConnection = v3:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				setState2(v3.AbsoluteSize.X > v3.AbsoluteSize.Y)
			end)
		else
			absoluteSizeChangedConnection = nil
		end

		return function()
			if absoluteSizeChangedConnection then
				absoluteSizeChangedConnection:Disconnect()
			end
		end
	end, { v3 })

	if not state then
		return nil
	end

	local clone = table.clone(v2)
	clone.isOpen = nil
	clone.ref = ref
	clone.sheetRef = ref2
	clone.displaySize = state3
	function clone.onClose()
		if v2.onClose then
			v2.onClose()
		end

		setState(false)
	end

	if state3 == Enum.DisplaySize.Small and not state2 then
		return React.createElement(BottomSheet, clone)
	end

	if v2.preferCenterSheet then
		return React.createElement(CenterSheet, clone)
	end

	return React.createElement(SideSheet, clone)
end

return React.memo(React.forwardRef(Sheet))
