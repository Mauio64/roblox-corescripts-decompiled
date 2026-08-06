local Parent = script:FindFirstAncestor("MomentsCreation").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local FoundationImage = Foundation.Image
local useCallback = React.useCallback

local function StickerPickerItem(t1: {[any]: any}) -- line: 25
	-- upvalues: useCallback (copy), React (copy), FoundationImage (copy)
	local stickerURI = t1.stickerURI
	local onStickerSelected = t1.onStickerSelected
	local v10 = useCallback(function() -- line: 29
		-- upvalues: onStickerSelected (copy), stickerURI (copy)
		if onStickerSelected then
			onStickerSelected(stickerURI)
		end
	end, {
		onStickerSelected,
		stickerURI
	})

	return React.createElement(FoundationImage, {
		BackgroundTransparency = 1,
		tag = "size-1000-1000 radius-medium",
		LayoutOrder = t1.layoutOrder,
		onActivated = if not onStickerSelected then nil else v10,
		Image = stickerURI,
		ScaleType = Enum.ScaleType.Fit
	})
end

return StickerPickerItem
