local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/React")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/AvatarExperienceCommon")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/AvatarExperienceNavigation")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/Foundation")
local Gifting = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/Gifting")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/Navigation").useNavigation

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Components/AvatarItemGiftRecipientPicker/AvatarItemGiftRecipientPickerView")
local buildGiftItem = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Utils/buildGiftItem")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Types/GiftSendFlowNavigationOverrides")

local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local closeGiftSendFlow = AvatarExperienceNavigation.Utils.closeGiftSendFlow
local debounce = AvatarExperienceCommon.Utils.debounce
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useTokens = Foundation.Hooks.useTokens

local constants = Gifting.Constants
local giftState = Gifting.Enums.GiftState
local useGiftRecipients = Gifting.Hooks.useGiftRecipients

local recipientPickerStrings = constants.RecipientPickerStrings

local function useAvatarItemGiftRecipientPickerViewModel(p2)
	local v5 = useNavigation()
	local v6 = useAvatarRoute()
	local v7 = useTokens()

	local param = v5.getParam("collectibleItemId")

	local v8 = React.useMemo(function()
		return buildGiftItem(param)
	end, { param })

	local v9 = React.useMemo(function()
		if v8 == nil then
			return nil
		end

		return { v8 }
	end, { v8 })

	local closeSendFlow = if p2 then p2.closeSendFlow else nil
	local v10 = React.useCallback(function()
		if closeSendFlow then
			closeSendFlow()
		else
			closeGiftSendFlow(v5)
		end
	end, { v5, closeSendFlow })

	local v11 = React.useCallback(function(p3)
		v5.navigate(avatarScreen.SendGiftReview, {
			collectibleItemId = param,
			recipientId = p3
		})
	end, { v5, param })

	local state, setState = React.useState("")
	local state2, setState2 = React.useState("")
	local v12 = React.useMemo(function()
		return debounce(setState2, 0.25)
	end, {})
	local v13 = React.useCallback(function(p3)
		setState(p3)
		v12(p3)
	end, { v12 })

	local v14 = useGiftRecipients(v9, state2)
	local v15 = React.useMemo(function()
		local result = {}

		for k, recipient in v14.recipients do
			table.insert(result, {
				userId = tostring(recipient.userId),
				displayName = recipient.displayName,
				username = recipient.username,
				isAvailable = true
			})
		end

		return result
	end, { v14.recipients })

	local v16 = React.useCallback(function(p3)
		local v17 = tonumber(p3)

		if v17 == nil then
			return
		end

		v11(v17)
	end, { v11 })

	local v17 = React.useMemo(function()
		if v14.isLoading then
			return { state = giftState.Loading }
		end

		if v14.hasFailed then
			return {
				state = giftState.Error,
				titleText = recipientPickerStrings.ErrorTitle,
				bodyText = recipientPickerStrings.ErrorBody,
				retryLabel = recipientPickerStrings.RetryLabel,
				onRetry = v14.retry
			}
		end

		if #v15 == 0 then
			return {
				state = giftState.Empty,
				titleText = recipientPickerStrings.EmptyTitle,
				bodyText = recipientPickerStrings.EmptyBody
			}
		end

		return nil
	end, { v14.isLoading, v14.hasFailed, v14.retry, v15 })

	local v18 = React.useMemo(function()
		local count = 0

		for k, recipient in v14.recipients do
			if recipient.userRelationship == Gifting.Enums.UserRelationship.Friend then
				count += 1
			end
		end

		return string.format(recipientPickerStrings.FriendsSectionTitleFormat, count)
	end, { v14.recipients })

	local v19 = v6.isVisible and v6.current.key == v5.state.key

	if v8 == nil then
		v19 = false
	end

	return {
		isVisible = v19,
		pickerProps = {
			isOpen = true,
			titleText = recipientPickerStrings.SheetTitle,
			searchPlaceholder = recipientPickerStrings.SearchPlaceholder,
			searchText = state,
			isSearchVisible = not v14.hasFailed or state2 ~= "",
			onSearchChanged = v13,
			sectionTitle = v18,
			rows = v15,
			state = v17,
			onRecipientSelected = v16,
			unavailableLabel = recipientPickerStrings.UnavailableLabel,
			avatarBackgroundStyle = v7.Color.Shift.Shift_200,
			onClose = v10
		}
	}
end

return useAvatarItemGiftRecipientPickerViewModel
