local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

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

local v = {
	layout = { SortOrder = Enum.SortOrder.LayoutOrder },
	AutoLocalize = false,
	BorderSizePixel = 0,
	isDisabled = false
}

local v2 = false

local function View(p, ref)
	local v3 = withDefaults(p, v)

	local v4 = v3.backgroundStyle == nil and "gui-object-defaults" or "gui-object-defaults x-default-transparency"

	local v5 = useStyleTags((useDefaultTags(v3.tag, v4)))

	local v6 = v3.onStateChanged ~= nil or v3.onActivated ~= nil or v3.onSecondaryActivated ~= nil
	local v7

	if Flags.FoundationViewMemoizationChanges then
		if v3.GroupTransparency == nil then
			v7 = false
		else
			v7 = type(v3.GroupTransparency) == "table" or v3.GroupTransparency > 0
		end
	else
		v7 = React.useMemo(function(): boolean
			return v3.GroupTransparency ~= nil and (type(v3.GroupTransparency) == "table" or v3.GroupTransparency > 0)
		end, { v3.GroupTransparency })
	end

	local component

	if Flags.FoundationViewMemoizationChanges then
		component = v7 and "CanvasGroup" or v6 and "ImageButton" or "Frame"

		if v7 and v6 and not (v3.isDisabled or v2) then
			v2 = true
			Logger:warning("Some state changes are not supported with GroupTransparency")
		end
	else
		component = React.useMemo(function(): string
			if v7 then
				if v6 and not v3.isDisabled then
					Logger:warning("Some state changes are not supported with GroupTransparency")
				end

				return "CanvasGroup"
			else
				return if v6 then "ImageButton" else "Frame"
			end
		end, { v7, v6 })
	end

	local v8 = {}
	v8.AutoButtonColor = component ~= "ImageButton" and nil
	local groupTransparency

	if v7 then
		groupTransparency = v3.GroupTransparency
	end

	v8.GroupTransparency = groupTransparency

	v8.ref = ref
	v8[React.Tag] = v5
	local v9 = withGuiObjectProps(v3, v8)
	local v10

	if v6 then
		v10 = Interactable
		v9.component = component
		v9.onActivated = v3.onActivated
		v9.onSecondaryActivated = v3.onSecondaryActivated
		v9.onStateChanged = v3.onStateChanged
		v9.stateLayer = v3.stateLayer
		v9.isDisabled = v3.isDisabled
		v9.cursor = v3.cursor
	else
		v10 = component
	end

	return React.createElement(v10, v9, GuiObjectChildren(v3))
end

return React.memo(React.forwardRef(View))
