local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local FFlagAppChatUseProfileFrameThumbnail = require(AppChat.Flags.FFlagAppChatUseProfileFrameThumbnail)

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SignalsReact = require(parent.SignalsReact)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize

local useSignalState = SignalsReact.useSignalState

local GetSelectedUsersStore = require(AppChat.Stores.GetSelectedUsersStore)
local useUserData = require(AppChat.Hooks.useUserData)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local UserProfiles = require(parent.UserProfiles)
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)

local function noOp() end

local v = string.rep("W", 20)

return React.memo(function(p)
	local v2 = useUserData(p.userId)
	local v3 = Foundation.Hooks.useTokens()
	local v4

	if FFlagEnableBlackbirdCheck then
		v4 = p.userId
	end

	local v5 = useIsRobloxSubscriber(v4)

	local selectedUsersStore = GetSelectedUsersStore(false)
	local isChecked = useSignalState(selectedUsersStore.getIsUserSelected(p.userId))

	local onActivated = React.useCallback(function()
		selectedUsersStore.toggleUserId(p.userId)
	end, { p.userId })

	local v6 = React.useMemo(function()
		local textSize = GetTextSize(v, v3.Typography.TitleLarge.FontSize, v3.Typography.TitleLarge.Font, Vector2.zero)

		return UDim2.fromOffset(textSize.X, textSize.Y)
	end, { v3.Typography.TitleLarge.Font, v3.Typography.TitleLarge.FontSize })

	local v7 = React.useMemo(function()
		local textSize = GetTextSize(
			"Roblox Studio",
			v3.Typography.CaptionMedium.FontSize,
			v3.Typography.CaptionMedium.Font,
			Vector2.zero
		)

		return UDim2.fromOffset(textSize.X, textSize.Y)
	end, { v3.Typography.CaptionMedium.Font, v3.Typography.CaptionMedium.FontSize })

	local state = nil
	local v8 = nil

	if FFlagDebugAppChatEnableDomLocators then
		local setState
		state, setState = React.useState("")
		v8 = setState
		React.__subscribeToBinding(v2.username, function(p2)
			v8(p2)
		end)
	end

	local createElement = React.createElement
	local view = Foundation.View
	local testId

	if FFlagDebugAppChatEnableDomLocators then
		testId = DomLocators.selectChatMembersUserCellWithCheckbox(state, isChecked)
	end

	local children = {
		Avatar = React.createElement(Foundation.Avatar, {
			userId = v2.id,
			userPresence = v2.presence,
			size = Foundation.Enums.InputSize.Medium,
			backgroundStyle = v3.Color.Shift.Shift_300,
			includeProfileFrame = FFlagAppChatUseProfileFrameThumbnail,
			LayoutOrder = 1
		}),
		UserInfo = 0,
		CheckboxContainer = 0
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v9 = {
		UserDataSkeleton = React.createElement(Foundation.Skeleton, {
			Size = UDim2.new(v6.X, v6.Y + v7.Y),
			Visible = v2.isLoading,
			LayoutOrder = 1
		}),
		DisplayNameRow = 0,
		DisplayName = 0,
		PresenceText = 0
	}
	local displayNameRow

	if FFlagEnableBlackbirdCheck then
		local createElement3 = React.createElement
		local view3 = Foundation.View
		local v10 = {
			tag = "row auto-xy align-y-center gap-xsmall",
			LayoutOrder = 1,
			Visible = v2.isLoading:map(function(p2): boolean
				return not p2
			end)
		}

		local v11 = {
			DisplayName = React.createElement(Foundation.Text, {
				tag = "auto-xy text-title-large text-truncate-end content-emphasis",
				Text = v2.combinedName,
				LayoutOrder = 1
			}),
			SubscriptionBadge = 0
		}
		local subscriptionBadge

		if v5 then
			subscriptionBadge = React.createElement(Foundation.Icon, {
				LayoutOrder = 2,
				name = Foundation.Enums.IconName.RobloxPlus,
				size = Foundation.Enums.IconSize.Small,
				style = v3.Color.Content.Emphasis
			})
		end

		v11.SubscriptionBadge = subscriptionBadge
		displayNameRow = createElement3(view3, v10, v11)
	end

	v9.DisplayNameRow = displayNameRow
	local displayName

	if not FFlagEnableBlackbirdCheck then
		displayName = React.createElement(Foundation.Text, {
			tag = "auto-xy text-title-large text-truncate-end content-emphasis",
			Text = v2.combinedName,
			LayoutOrder = 1,
			Visible = v2.isLoading:map(function(p2): boolean
				return not p2
			end)
		})
	end

	v9.DisplayName = displayName

	v9.PresenceText = React.createElement(Foundation.Text, {
		tag = "auto-xy text-caption-medium text-truncate-end content-muted",
		Text = v2.presenceText,
		LayoutOrder = 3,
		Visible = v2.isLoading:map(function(p2): boolean
			return not p2
		end)
	})
	children.UserInfo = createElement2(view2, { tag = "col fill auto-y clip", LayoutOrder = 2 }, v9)

	children.CheckboxContainer = React.createElement(Foundation.View, {
		tag = "auto-xy padding-x-medium",
		onActivated = noOp,
		isDisabled = true,
		LayoutOrder = 3,
		selection = { Selectable = false }
	}, {
		checkbox = React.createElement(Foundation.Checkbox, {
			label = "",
			isChecked = isChecked,
			size = Foundation.Enums.InputSize.XSmall,
			onActivated = noOp,
			Selectable = false
		})
	})
	return createElement(
		view,
		{
			tag = "row size-full-0 auto-y stroke-muted stroke-thin gap-medium padding-x-medium padding-y-small align-y-center",
			onActivated = onActivated,
			testId = testId
		},
		children
	)
end)
