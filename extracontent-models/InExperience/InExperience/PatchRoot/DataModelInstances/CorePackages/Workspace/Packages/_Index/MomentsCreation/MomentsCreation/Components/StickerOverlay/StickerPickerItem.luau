local parent = script:FindFirstAncestor("MomentsCreation").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Image = Foundation.Image

local useCallback = React.useCallback

local function StickerPickerItem(props)
	local stickerURI = props.stickerURI
	local onStickerSelected = props.onStickerSelected

	local onActivated = useCallback(function()
		if onStickerSelected then
			onStickerSelected(stickerURI)
		end
	end, { onStickerSelected, stickerURI })

	local createElement = React.createElement
	local v = {
		LayoutOrder = props.layoutOrder,
		onActivated = 0,
		Image = 0,
		ScaleType = 0,
		BackgroundTransparency = 1,
		tag = "size-1000-1000 radius-medium"
	}

	if not onStickerSelected then
		onActivated = nil
	end

	v.onActivated = onActivated
	v.Image = stickerURI
	v.ScaleType = Enum.ScaleType.Fit
	return createElement(Image, v)
end

return StickerPickerItem
