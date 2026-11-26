local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/Gifting")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/AvatarExperienceNavigation")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/Navigation").useNavigation

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Components/AvatarItemGiftEntryPoint/AvatarItemGiftEntryPointView")
local useAvatarItemGiftEligibility = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Hooks/useAvatarItemGiftEligibility")

local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local function useAvatarItemGiftEntryPointViewModel(data)
	local collectibleItemId = data.collectibleItemId
	local isCircular = data.isCircular
	local layoutOrder = data.LayoutOrder

	local v5 = useNavigation()

	local v6 = useAvatarItemGiftEligibility(collectibleItemId, data.eligibilityDeps)

	local areItemsGiftable = v6.areItemsGiftable

	local canGift = v6.canGift

	local v7 = React.useCallback(function()
		if not canGift or collectibleItemId == nil or collectibleItemId == "" then
			return
		end

		v5.navigate(avatarScreen.SendGiftRecipientPicker, {
			collectibleItemId = collectibleItemId
		})
	end, { canGift, collectibleItemId, v5 })

	return {
		isVisible = areItemsGiftable,
		buttonProps = React.useMemo(function()
			return {
				onActivated = v7,
				isCircular = isCircular,
				LayoutOrder = layoutOrder
			}
		end, { v7, isCircular, layoutOrder })
	}
end

return useAvatarItemGiftEntryPointViewModel
