local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Logger = require(Foundation.Utility.Logger)
local Interactable = require(Foundation.Components.Interactable)
local GuiObjectChildren = require(Foundation.Utility.GuiObjectChildren)

require(Foundation.Components.Types)

local useDefaultTags = require(Foundation.Utility.useDefaultTags)
local withDefaults = require(Foundation.Utility.withDefaults)
local withGuiObjectProps = require(Foundation.Utility.withGuiObjectProps)
local useStyleTags = require(Foundation.Providers.Style.useStyleTags)

require(Foundation.Enums.ControlState)

local t1 = {
	AutoLocalize = false,
	BorderSizePixel = 0,
	isDisabled = false,
	layout = {
		SortOrder = Enum.SortOrder.LayoutOrder
	}
}

local function View(p1, p2) -- line: 42
	-- upvalues: withDefaults (copy), t1 (copy), useDefaultTags (copy), useStyleTags (copy), React (copy), Logger (copy), withGuiObjectProps (copy), Interactable (copy), GuiObjectChildren (copy)
	local v15 = withDefaults(p1, t1)
	local v16 = v15.backgroundStyle == nil and "gui-object-defaults" or "gui-object-defaults x-default-transparency"
	local v17 = useDefaultTags(v15.tag, v16)
	local v18 = useStyleTags(v17)
	local v19 = v15.onStateChanged ~= nil or (v15.onActivated ~= nil or v15.onSecondaryActivated ~= nil)
	local v20 = React.useMemo(function() -- line: 52
		-- upvalues: v15 (copy)
		if v15.GroupTransparency ~= nil then
			if type(v15.GroupTransparency) == "table" then
				return true
			end

			return v15.GroupTransparency > 0
		end

		return false
	end, { v15.GroupTransparency })
	local v21 = React.useMemo(function() -- line: 63
		-- upvalues: v20 (copy), v19 (copy), v15 (copy), Logger (copy)
		if v20 then
			if v19 and not v15.isDisabled then
				Logger:warning("Some state changes are not supported with GroupTransparency")
			end

			return "CanvasGroup"
		end

		if v19 then
			return "ImageButton"
		end

		return "Frame"
	end, {
		v20,
		v19
	})
	local v22 = withGuiObjectProps(v15, {
		AutoButtonColor = v21 ~= "ImageButton" and nil,
		GroupTransparency = if not v20 then nil else v15.GroupTransparency,
		ref = p2,
		[React.Tag] = v18
	})
	local v23 = v21

	if v19 then
		v23 = Interactable
		v22.component = v21
		v22.onActivated = v15.onActivated
		v22.onSecondaryActivated = v15.onSecondaryActivated
		v22.onStateChanged = v15.onStateChanged
		v22.stateLayer = v15.stateLayer
		v22.isDisabled = v15.isDisabled
		v22.cursor = v15.cursor
	end

	return React.createElement(v23, v22, GuiObjectChildren(v15))
end

return React.memo(React.forwardRef(View))
