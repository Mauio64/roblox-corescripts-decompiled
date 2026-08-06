local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Logger = require(Foundation.Utility.Logger)
local Interactable = require(Foundation.Components.Interactable)
local Flags = require(Foundation.Utility.Flags)
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
local u13 = false

local function View(p1, p2) -- line: 45
	-- upvalues: withDefaults (copy), t1 (copy), useDefaultTags (copy), useStyleTags (copy), Flags (copy), React (copy), u13 (ref), Logger (copy), withGuiObjectProps (copy), Interactable (copy), GuiObjectChildren (copy)
	local v17 = withDefaults(p1, t1)
	local v18 = v17.backgroundStyle == nil and "gui-object-defaults" or "gui-object-defaults x-default-transparency"
	local v19 = useDefaultTags(v17.tag, v18)
	local v20 = useStyleTags(v19)
	local v21 = v17.onStateChanged ~= nil or (v17.onActivated ~= nil or v17.onSecondaryActivated ~= nil)
	local u22 = if not Flags.FoundationViewMemoizationChanges then React.useMemo(function() -- line: 64
		-- upvalues: v17 (copy)
		if v17.GroupTransparency ~= nil then
			if type(v17.GroupTransparency) == "table" then
				return true
			end

			return v17.GroupTransparency > 0
		end

		return false
	end, { v17.GroupTransparency }) else v17.GroupTransparency ~= nil and (type(v17.GroupTransparency) == "table" or v17.GroupTransparency > 0)
	local v23

	if Flags.FoundationViewMemoizationChanges then
		v23 = if not u22 then not v21 and "Frame" or "ImageButton" else "CanvasGroup"

		if u22 and v21 and not v17.isDisabled and not u13 then
			u13 = true
			Logger:warning("Some state changes are not supported with GroupTransparency")
		end
	else
		v23 = React.useMemo(function() -- line: 91
			-- upvalues: u22 (ref), v21 (copy), v17 (copy), Logger (copy)
			if u22 then
				if v21 and not v17.isDisabled then
					Logger:warning("Some state changes are not supported with GroupTransparency")
				end

				return "CanvasGroup"
			end

			if v21 then
				return "ImageButton"
			end

			return "Frame"
		end, {
			u22,
			v21
		})
	end

	local v24 = withGuiObjectProps(v17, {
		AutoButtonColor = v23 ~= "ImageButton" and nil,
		GroupTransparency = if not u22 then nil else v17.GroupTransparency,
		ref = p2,
		[React.Tag] = v20
	})
	local v25 = v23

	if v21 then
		v25 = Interactable
		v24.component = v23
		v24.onActivated = v17.onActivated
		v24.onSecondaryActivated = v17.onSecondaryActivated
		v24.onStateChanged = v17.onStateChanged
		v24.stateLayer = v17.stateLayer
		v24.isDisabled = v17.isDisabled
		v24.cursor = v17.cursor
	end

	return React.createElement(v25, v24, GuiObjectChildren(v17))
end

return React.memo(React.forwardRef(View))
