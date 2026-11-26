local module = require("@luauforge/bundled/dTk")
require("@luauforge/bundled/dTq")
local module2 = require("@luauforge/bundled/dTF")

local fFlagAXItemViewportRestoreParentScrollingOnUnmount = require("@luauforge/bundled/dTp").FFlagAXItemViewportRestoreParentScrollingOnUnmount

local fFlagAXItemMediaHeaderDefaultAspectRatio = require("@luauforge/bundled/dTp").FFlagAXItemMediaHeaderDefaultAspectRatio

local itemMediaHeader = module2.ItemMediaHeader
local itemDetailsSduiScrollingContext = module2.ItemDetailsSduiScrollingContext

local function SduiItemMediaHeader(props)
	local itemId = props.itemId
	local itemType = props.itemType
	local bundleType = props.bundleType
	local bundleItems = props.bundleItems
	local setParentScrollingEnabled

	if fFlagAXItemViewportRestoreParentScrollingOnUnmount then
		setParentScrollingEnabled = module.useContext(itemDetailsSduiScrollingContext).setParentScrollingEnabled
	end

	local v5 = module.useMemo(function()
		if itemType == "Bundle" then
			if bundleType == nil or bundleItems == nil or #bundleItems == 0 then
				return nil
			end

			return {
				itemType = "Bundle",
				itemId = itemId,
				bundleType = bundleType,
				bundleItems = bundleItems
			}
		elseif itemType == "Asset" then
			return { itemType = "Asset", itemId = itemId }
		else
			return nil
		end
	end, { itemId, itemType, bundleType, bundleItems })

	return module.createElement(itemMediaHeader, {
		item = v5,
		preferThreeDimensional = props.preferThreeDimensional,
		thumbnail = props.thumbnail,
		setParentScrollingEnabled = setParentScrollingEnabled,
		overlaySlot = props.overlayComponent,
		size = props.size,
		aspectRatio = fFlagAXItemMediaHeaderDefaultAspectRatio and props.size == nil and 16 / 9 or nil,
		layoutOrder = props.layoutOrder,
		zIndex = props.zIndex,
		visible = props.visible,
		testId = props.testId
	})
end

return module.memo(SduiItemMediaHeader)
