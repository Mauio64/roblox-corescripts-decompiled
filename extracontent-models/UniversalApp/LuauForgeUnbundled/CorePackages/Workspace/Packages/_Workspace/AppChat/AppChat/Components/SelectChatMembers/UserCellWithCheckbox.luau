local FFlagAppChatUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseProfileFrameThumbnail")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Style").GetTextSize

local useSignalState = SignalsReact.useSignalState

local GetSelectedUsersStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetSelectedUsersStore")
local useUserData = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useUserData")

local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserProfiles").Hooks.useIsRobloxSubscriber
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")

local function noOp() end

local v5 = string.rep("W", 20)

return React.memo(function(p2)
	local v6 = useUserData(p2.userId)
	local v7 = Foundation.Hooks.useTokens()

	local v9 = if fFlagEnableBlackbirdCheck then p2.userId else nil
	local v10 = useIsRobloxSubscriber(v9)

	local v11 = GetSelectedUsersStore(false)
	local v12 = useSignalState(v11.getIsUserSelected(p2.userId))

	local v13 = React.useCallback(function()
		v11.toggleUserId(p2.userId)
	end, { p2.userId })

	local v14 = React.useMemo(function()
		local textSize = getTextSize(
			v5,
			v7.Typography.TitleLarge.FontSize,
			v7.Typography.TitleLarge.Font,
			Vector2.zero
		)

		return UDim2.fromOffset(textSize.X, textSize.Y)
	end, { v7.Typography.TitleLarge.Font, v7.Typography.TitleLarge.FontSize })

	local v15 = React.useMemo(function()
		local textSize = getTextSize(
			"Roblox Studio",
			v7.Typography.CaptionMedium.FontSize,
			v7.Typography.CaptionMedium.Font,
			Vector2.zero
		)

		return UDim2.fromOffset(textSize.X, textSize.Y)
	end, { v7.Typography.CaptionMedium.Font, v7.Typography.CaptionMedium.FontSize })

	local state = nil
	local v16 = nil

	if FFlagDebugAppChatEnableDomLocators then
		local setState
		state, setState = React.useState("")
		v16 = setState
		React.__subscribeToBinding(v6.username, function(p3)
			v16(p3)
		end)
	end

	local createElement = React.createElement
	local view = Foundation.View

	local v18 = if FFlagDebugAppChatEnableDomLocators then DomLocators.selectChatMembersUserCellWithCheckbox(state, v12) else nil

	local children = {
		Avatar = React.createElement(Foundation.Avatar, {
			userId = v6.id,
			userPresence = v6.presence,
			size = Foundation.Enums.InputSize.Medium,
			backgroundStyle = v7.Color.Shift.Shift_300,
			includeProfileFrame = FFlagAppChatUseProfileFrameThumbnail,
			LayoutOrder = 1
		}),
		UserInfo = 0,
		CheckboxContainer = 0
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v20 = {
		UserDataSkeleton = React.createElement(Foundation.Skeleton, {
			Size = UDim2.new(v14.X, v14.Y + v15.Y),
			Visible = v6.isLoading,
			LayoutOrder = 1
		}),
		DisplayNameRow = 0,
		DisplayName = 0,
		PresenceText = 0
	}
	local v21

	if fFlagEnableBlackbirdCheck then
		local createElement3 = React.createElement
		local view3 = Foundation.View
		local v22 = {
			tag = "row auto-xy align-y-center gap-xsmall",
			LayoutOrder = 1,
			Visible = v6.isLoading:map(function(p3): boolean
				return not p3
			end)
		}

		local v23 = {
			DisplayName = React.createElement(Foundation.Text, {
				tag = "auto-xy text-title-large text-truncate-end content-emphasis",
				Text = v6.combinedName,
				LayoutOrder = 1
			}),
			SubscriptionBadge = 0
		}

		local v24 = if v10 then React.createElement(Foundation.Icon, {
			LayoutOrder = 2,
			name = Foundation.Enums.IconName.RobloxPlus,
			size = Foundation.Enums.IconSize.Small,
			style = v7.Color.Content.Emphasis
		}) else nil
		v23.SubscriptionBadge = v24
		v21 = createElement3(view3, v22, v23)
	end

	v20.DisplayNameRow = v21
	local v22

	if not fFlagEnableBlackbirdCheck then
		v22 = React.createElement(Foundation.Text, {
			tag = "auto-xy text-title-large text-truncate-end content-emphasis",
			Text = v6.combinedName,
			LayoutOrder = 1,
			Visible = v6.isLoading:map(function(p3): boolean
				return not p3
			end)
		})
	end

	v20.DisplayName = v22

	v20.PresenceText = React.createElement(Foundation.Text, {
		tag = "auto-xy text-caption-medium text-truncate-end content-muted",
		Text = v6.presenceText,
		LayoutOrder = 3,
		Visible = v6.isLoading:map(function(p3): boolean
			return not p3
		end)
	})
	children.UserInfo = createElement2(view2, {
		tag = "col fill auto-y clip",
		LayoutOrder = 2
	}, v20)

	children.CheckboxContainer = React.createElement(Foundation.View, {
		tag = "auto-xy padding-x-medium",
		onActivated = noOp,
		isDisabled = true,
		LayoutOrder = 3,
		selection = { Selectable = false }
	}, {
		checkbox = React.createElement(Foundation.Checkbox, {
			label = "",
			isChecked = v12,
			size = Foundation.Enums.InputSize.XSmall,
			onActivated = noOp,
			Selectable = false
		})
	})
	return createElement(
		view,
		{
			tag = "row size-full-0 auto-y stroke-muted stroke-thin gap-medium padding-x-medium padding-y-small align-y-center",
			onActivated = v13,
			testId = v18
		},
		children
	)
end)
