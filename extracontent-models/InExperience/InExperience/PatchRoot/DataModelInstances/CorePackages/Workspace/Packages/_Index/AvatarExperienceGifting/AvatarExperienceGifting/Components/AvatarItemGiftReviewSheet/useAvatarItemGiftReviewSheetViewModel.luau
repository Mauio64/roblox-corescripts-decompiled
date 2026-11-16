local AvatarExperienceGifting = script:FindFirstAncestor("AvatarExperienceGifting")
local parent = AvatarExperienceGifting.Parent

local React = require(parent.React)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

require(script.Parent.AvatarItemGiftReviewSheetPlaceholderView)
local buildGiftItem = require(AvatarExperienceGifting.Utils.buildGiftItem)
require(AvatarExperienceGifting.Types.GiftSendFlowNavigationOverrides)

local closeGiftSendFlow = AvatarExperienceNavigation.Utils.closeGiftSendFlow
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

local function useAvatarItemGiftReviewSheetViewModel(p)
	local v = useNavigation()
	local v2 = useAvatarRoute()

	local param = v.getParam("collectibleItemId")
	local param2 = v.getParam("recipientId")

	local v3 = React.useMemo(function()
		return buildGiftItem(param)
	end, { param })
	local goBack

	if p then
		goBack = p.goBack
	else
		goBack = nil
	end

	local onBack = React.useCallback(function()
		if goBack then
			goBack()
		else
			v.pop()
		end
	end, { v, goBack })
	local closeSendFlow

	if p then
		closeSendFlow = p.closeSendFlow
	else
		closeSendFlow = nil
	end

	local onClose = React.useCallback(function()
		if closeSendFlow then
			closeSendFlow()
		else
			closeGiftSendFlow(v)
		end
	end, { v, closeSendFlow })

	local isVisible = v2.isVisible and v2.current.key == v.state.key

	if v3 == nil then
		isVisible = false
	elseif param2 == nil then
		isVisible = false
	end

	return { isVisible = isVisible, onBack = onBack, onClose = onClose }
end

return useAvatarItemGiftReviewSheetViewModel
