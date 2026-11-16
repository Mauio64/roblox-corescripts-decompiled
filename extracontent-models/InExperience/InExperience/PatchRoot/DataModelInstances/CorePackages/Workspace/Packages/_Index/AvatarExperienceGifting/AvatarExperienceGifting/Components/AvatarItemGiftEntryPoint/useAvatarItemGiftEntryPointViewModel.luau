local AvatarExperienceGifting = script:FindFirstAncestor("AvatarExperienceGifting")
local parent = AvatarExperienceGifting.Parent

local React = require(parent.React)
require(parent.Gifting)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

require(script.Parent.AvatarItemGiftEntryPointView)
local useAvatarItemGiftEligibility = require(AvatarExperienceGifting.Hooks.useAvatarItemGiftEligibility)

local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local function useAvatarItemGiftEntryPointViewModel(data)
	local collectibleItemId = data.collectibleItemId
	local isCircular = data.isCircular
	local layoutOrder = data.LayoutOrder

	local v = useNavigation()

	local v2 = useAvatarItemGiftEligibility(collectibleItemId, data.eligibilityDeps)

	local areItemsGiftable = v2.areItemsGiftable

	local canGift = v2.canGift

	local onActivated = React.useCallback(function()
		if not canGift or collectibleItemId == nil or collectibleItemId == "" then
			return
		end

		v.navigate(AvatarScreen.SendGiftRecipientPicker, { collectibleItemId = collectibleItemId })
	end, { canGift, collectibleItemId, v })

	return {
		isVisible = areItemsGiftable,
		buttonProps = React.useMemo(function()
			return { onActivated = onActivated, isCircular = isCircular, LayoutOrder = layoutOrder }
		end, { onActivated, isCircular, layoutOrder })
	}
end

return useAvatarItemGiftEntryPointViewModel
