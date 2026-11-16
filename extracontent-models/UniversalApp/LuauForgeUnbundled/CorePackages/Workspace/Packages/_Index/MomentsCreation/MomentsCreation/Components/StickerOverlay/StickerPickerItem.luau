local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local image = Foundation.Image

local useCallback = React.useCallback

local function StickerPickerItem(props)
	local stickerURI = props.stickerURI
	local onStickerSelected = props.onStickerSelected

	local v5 = useCallback(function()
		if onStickerSelected then
			onStickerSelected(stickerURI)
		end
	end, { onStickerSelected, stickerURI })

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.layoutOrder,
		onActivated = 0,
		Image = 0,
		ScaleType = 0,
		BackgroundTransparency = 1,
		tag = "size-1000-1000 radius-medium"
	}

	if not onStickerSelected then
		v5 = nil
	end

	v7.onActivated = v5
	v7.Image = stickerURI
	v7.ScaleType = Enum.ScaleType.Fit
	return createElement(image, v7)
end

return StickerPickerItem
