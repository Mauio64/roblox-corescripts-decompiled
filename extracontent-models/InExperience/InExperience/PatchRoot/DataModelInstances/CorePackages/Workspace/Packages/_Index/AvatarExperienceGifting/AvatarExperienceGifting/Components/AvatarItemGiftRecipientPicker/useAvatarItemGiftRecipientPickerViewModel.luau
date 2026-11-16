local AvatarExperienceGifting = script:FindFirstAncestor("AvatarExperienceGifting")
local parent = AvatarExperienceGifting.Parent

local React = require(parent.React)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local Foundation = require(parent.Foundation)
local Gifting = require(parent.Gifting)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

require(script.Parent.AvatarItemGiftRecipientPickerView)
local buildGiftItem = require(AvatarExperienceGifting.Utils.buildGiftItem)
require(AvatarExperienceGifting.Types.GiftSendFlowNavigationOverrides)

local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local closeGiftSendFlow = AvatarExperienceNavigation.Utils.closeGiftSendFlow
local debounce = AvatarExperienceCommon.Utils.debounce
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useTokens = Foundation.Hooks.useTokens

local Constants = Gifting.Constants
local GiftState = Gifting.Enums.GiftState
local useGiftRecipients = Gifting.Hooks.useGiftRecipients

local RecipientPickerStrings = Constants.RecipientPickerStrings

local function useAvatarItemGiftRecipientPickerViewModel(p)
	local v = useNavigation()
	local v2 = useAvatarRoute()
	local v3 = useTokens()

	local param = v.getParam("collectibleItemId")

	local v4 = React.useMemo(function()
		return buildGiftItem(param)
	end, { param })

	local v5 = React.useMemo(function()
		if v4 == nil then
			return nil
		end

		return { v4 }
	end, { v4 })
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

	local v6 = React.useCallback(function(recipientId: number)
		v.navigate(AvatarScreen.SendGiftReview, {
			collectibleItemId = param,
			recipientId = recipientId
		})
	end, { v, param })

	local state, setState = React.useState("")
	local state2, setState2 = React.useState("")
	local v7 = React.useMemo(function()
		return debounce(setState2, 0.25)
	end, {})
	local onSearchChanged = React.useCallback(function(p2: string)
		setState(p2)
		v7(p2)
	end, { v7 })

	local v8 = useGiftRecipients(v5, state2)
	local rows = React.useMemo(function()
		local result = {}

		for _, recipient in v8.recipients do
			table.insert(result, {
				userId = tostring(recipient.userId),
				displayName = recipient.displayName,
				username = recipient.username,
				isAvailable = true
			})
		end

		return result
	end, { v8.recipients })

	local onRecipientSelected = React.useCallback(function(p2: string)
		local v9 = tonumber(p2)

		if v9 == nil then
			return
		end

		v6(v9)
	end, { v6 })

	local state3 = React.useMemo(function()
		if v8.isLoading then
			return { state = GiftState.Loading }
		end

		if v8.hasFailed then
			return {
				state = GiftState.Error,
				titleText = RecipientPickerStrings.ErrorTitle,
				bodyText = RecipientPickerStrings.ErrorBody,
				retryLabel = RecipientPickerStrings.RetryLabel,
				onRetry = v8.retry
			}
		end

		if #rows == 0 then
			return {
				state = GiftState.Empty,
				titleText = RecipientPickerStrings.EmptyTitle,
				bodyText = RecipientPickerStrings.EmptyBody
			}
		end

		return nil
	end, { v8.isLoading, v8.hasFailed, v8.retry, rows })

	local sectionTitle = React.useMemo(function()
		local count = 0

		for _, recipient in v8.recipients do
			if recipient.userRelationship == Gifting.Enums.UserRelationship.Friend then
				count += 1
			end
		end

		return string.format(RecipientPickerStrings.FriendsSectionTitleFormat, count)
	end, { v8.recipients })

	local isVisible = v2.isVisible and v2.current.key == v.state.key

	if v4 == nil then
		isVisible = false
	end

	return {
		isVisible = isVisible,
		pickerProps = {
			isOpen = true,
			titleText = RecipientPickerStrings.SheetTitle,
			searchPlaceholder = RecipientPickerStrings.SearchPlaceholder,
			searchText = state,
			isSearchVisible = not v8.hasFailed or state2 ~= "",
			onSearchChanged = onSearchChanged,
			sectionTitle = sectionTitle,
			rows = rows,
			state = state3,
			onRecipientSelected = onRecipientSelected,
			unavailableLabel = RecipientPickerStrings.UnavailableLabel,
			avatarBackgroundStyle = v3.Color.Shift.Shift_200,
			onClose = onClose
		}
	}
end

return useAvatarItemGiftRecipientPickerViewModel
