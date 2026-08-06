local Foundation = game:GetService("CorePackages").Packages._Index.Foundation.Foundation
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactUtils = require(FoundationParent.ReactUtils)
local BottomSheet = require(script.Parent.BottomSheet)
local CenterSheet = require(script.Parent.CenterSheet)
local SideSheet = require(script.Parent.SideSheet)
local useScreen = require(Foundation.Providers.Overlay.useScreen)
local GuiService = require(Foundation.Utility.Wrappers).Services.GuiService

require(Foundation.Enums.DialogSize)

local withDefaults = require(Foundation.Utility.withDefaults)

require(script.Parent.Types)

local t1 = {
	testId = "--foundation-sheet"
}

local function Sheet(p1, p2) -- line: 23
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), useScreen (copy), GuiService (copy), ReactUtils (copy), BottomSheet (copy), CenterSheet (copy), SideSheet (copy)
	local v15 = withDefaults(p1, t1)
	local v16, v17 = React.useState(v15.isOpen == nil or v15.isOpen)
	local v18 = React.useRef(nil)
	local v19 = useScreen()
	local v20, v21 = React.useState(not v19 or v19.AbsoluteSize.X > v19.AbsoluteSize.Y)
	local v22, v23 = React.useState(GuiService.ViewportDisplaySize)

	React.useImperativeHandle(v15.sheetRef, function() -- line: 33
		-- upvalues: v18 (copy)
		return v18.current
	end, {})
	React.useEffect(function() -- line: 37
		-- upvalues: v15 (copy), v18 (copy), v17 (copy)
		if v15.isOpen == false and v18.current then
			v18.current.close()

			return
		end

		if v15.isOpen then
			v17(true)
		end
	end, { v15.isOpen })
	React.useEffect(function() -- line: 45
		-- upvalues: v16 (copy), v15 (copy), v17 (copy)
		if not v16 and v15.isOpen then
			v17(true)
		end
	end, { v16 })
	ReactUtils.useEventConnection(GuiService:GetPropertyChangedSignal("ViewportDisplaySize"), function() -- line: 51
		-- upvalues: v23 (copy), GuiService (copy)
		v23(GuiService.ViewportDisplaySize)
	end, {})
	React.useLayoutEffect(function() -- line: 55
		-- upvalues: v19 (copy), v21 (copy)
		local connection = nil

		if v19 then
			v21(v19.AbsoluteSize.X > v19.AbsoluteSize.Y)
			connection = v19:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 59
				-- upvalues: v21 (copy), v19 (copy)
				v21(v19.AbsoluteSize.X > v19.AbsoluteSize.Y)
			end)
		end

		return function() -- line: 64
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { v19 })

	if not v16 then
		return nil
	end

	local v24 = table.clone(v15)

	v24.isOpen = nil
	v24.ref = p2
	v24.sheetRef = v18
	v24.displaySize = v22

	function v24.onClose() -- line: 80
		-- upvalues: v15 (copy), v17 (copy)
		if v15.onClose then
			v15.onClose()
		end

		v17(false)
	end

	if v22 == Enum.DisplaySize.Small and not v20 then
		return React.createElement(BottomSheet, v24)
	end

	if v15.preferCenterSheet then
		return React.createElement(CenterSheet, v24)
	end

	return React.createElement(SideSheet, v24)
end

return React.memo(React.forwardRef(Sheet))
