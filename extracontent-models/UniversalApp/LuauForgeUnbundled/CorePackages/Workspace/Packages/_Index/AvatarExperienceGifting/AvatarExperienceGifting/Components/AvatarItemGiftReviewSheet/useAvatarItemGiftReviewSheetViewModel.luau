local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/React")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/AvatarExperienceNavigation")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/Navigation").useNavigation

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Components/AvatarItemGiftReviewSheet/AvatarItemGiftReviewSheetPlaceholderView")
local buildGiftItem = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Utils/buildGiftItem")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Types/GiftSendFlowNavigationOverrides")

local closeGiftSendFlow = AvatarExperienceNavigation.Utils.closeGiftSendFlow
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

local function useAvatarItemGiftReviewSheetViewModel(p2)
	local v5 = useNavigation()
	local v6 = useAvatarRoute()

	local param = v5.getParam("collectibleItemId")
	local param2 = v5.getParam("recipientId")

	local v7 = React.useMemo(function()
		return buildGiftItem(param)
	end, { param })

	local goBack = if p2 then p2.goBack else nil
	local v8 = React.useCallback(function()
		if goBack then
			goBack()
		else
			v5.pop()
		end
	end, { v5, goBack })

	local closeSendFlow = if p2 then p2.closeSendFlow else nil
	local v9 = React.useCallback(function()
		if closeSendFlow then
			closeSendFlow()
		else
			closeGiftSendFlow(v5)
		end
	end, { v5, closeSendFlow })

	local v10 = v6.isVisible and v6.current.key == v5.state.key

	if v7 == nil then
		v10 = false
	elseif param2 == nil then
		v10 = false
	end

	return { isVisible = v10, onBack = v8, onClose = v9 }
end

return useAvatarItemGiftReviewSheetViewModel
