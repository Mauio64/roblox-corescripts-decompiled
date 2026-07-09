local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Foundation = require(AppChatParent.Foundation)
local SignalsReact = require(AppChatParent.SignalsReact)
local Text = require(AppChatParent.AppCommonLib).Text
local useSignalState = SignalsReact.useSignalState
local GetSelectedUsersStore = require(AppChat.Stores.GetSelectedUsersStore)
local useUserData = require(AppChat.Hooks.useUserData)
local FFlagEnableBlackbirdCheck = require(AppChatParent.SharedFlags).FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = require(AppChatParent.UserProfiles).Hooks.useIsRobloxSubscriber
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)

local function noOp() -- line: 29
end

local v15 = string.rep("W", 20)

return React.memo(function(t1: {[any]: any}) -- line: 35
	-- upvalues: useUserData (copy), Foundation (copy), useIsRobloxSubscriber (copy), FFlagEnableBlackbirdCheck (copy), GetSelectedUsersStore (copy), useSignalState (copy), React (copy), Text (copy), v15 (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), noOp (copy)
	local v17 = useUserData(t1.userId)
	local v18 = Foundation.Hooks.useTokens()
	local v19 = useIsRobloxSubscriber(if not FFlagEnableBlackbirdCheck then nil else t1.userId)
	local v20 = GetSelectedUsersStore(false)
	local v21 = useSignalState(v20.getIsUserSelected(t1.userId))
	local v22 = React.useCallback(function() -- line: 44
		-- upvalues: v20 (copy), t1 (copy)
		v20.toggleUserId(t1.userId)
	end, { t1.userId })
	local v23 = React.useMemo(function() -- line: 48
		-- upvalues: Text (copy), v15 (copy), v18 (copy)
		local v28 = Text.GetTextBounds(v15, v18.Typography.TitleLarge.Font, v18.Typography.TitleLarge.FontSize, Vector2.zero)

		return UDim2.fromOffset(v28.X, v28.Y)
	end, {
		v18.Typography.TitleLarge.Font,
		v18.Typography.TitleLarge.FontSize
	})
	local v24 = React.useMemo(function() -- line: 58
		-- upvalues: Text (copy), v18 (copy)
		local v29 = Text.GetTextBounds("Roblox Studio", v18.Typography.CaptionMedium.Font, v18.Typography.CaptionMedium.FontSize, Vector2.zero)

		return UDim2.fromOffset(v29.X, v29.Y)
	end, {
		v18.Typography.CaptionMedium.Font,
		v18.Typography.CaptionMedium.FontSize
	})
	local v25 = nil
	local u26 = nil

	if FFlagDebugAppChatEnableDomLocators then
		local v27

		v25, v27 = React.useState("")
		u26 = v27
		React.__subscribeToBinding(v17.username, function(p1) -- line: 71
			-- upvalues: u26 (ref)
			u26(p1)
		end)
	end

	return React.createElement(Foundation.View, {
		tag = "row size-full-0 auto-y stroke-muted stroke-thin gap-medium padding-x-medium padding-y-small align-y-center",
		onActivated = v22,
		testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.selectChatMembersUserCellWithCheckbox(v25, v21)
	}, {
		Avatar = React.createElement(Foundation.Avatar, {
			LayoutOrder = 1,
			userId = v17.id,
			userPresence = v17.presence,
			size = Foundation.Enums.InputSize.Medium,
			backgroundStyle = v18.Color.Shift.Shift_300
		}),
		UserInfo = React.createElement(Foundation.View, {
			tag = "col fill auto-y clip",
			LayoutOrder = 2
		}, {
			UserDataSkeleton = React.createElement(Foundation.Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(v23.X, v23.Y + v24.Y),
				Visible = v17.isLoading
			}),
			DisplayNameRow = if not FFlagEnableBlackbirdCheck then nil else React.createElement(Foundation.View, {
				tag = "row auto-xy align-y-center gap-xsmall",
				LayoutOrder = 1,
				Visible = v17.isLoading:map(function(p2) -- line: 104
					return not p2
				end)
			}, {
				DisplayName = React.createElement(Foundation.Text, {
					tag = "auto-xy text-title-large text-truncate-end content-emphasis",
					LayoutOrder = 1,
					Text = v17.combinedName
				}),
				SubscriptionBadge = if not v19 then nil else React.createElement(Foundation.Icon, {
					LayoutOrder = 2,
					name = Foundation.Enums.IconName.RobloxPlus,
					size = Foundation.Enums.IconSize.Small,
					style = v18.Color.Content.Emphasis
				})
			}),
			DisplayName = if FFlagEnableBlackbirdCheck then nil else React.createElement(Foundation.Text, {
				tag = "auto-xy text-title-large text-truncate-end content-emphasis",
				LayoutOrder = 1,
				Text = v17.combinedName,
				Visible = v17.isLoading:map(function(p3) -- line: 128
					return not p3
				end)
			}),
			PresenceText = React.createElement(Foundation.Text, {
				tag = "auto-xy text-caption-medium text-truncate-end content-muted",
				LayoutOrder = 3,
				Text = v17.presenceText,
				Visible = v17.isLoading:map(function(p4) -- line: 137
					return not p4
				end)
			})
		}),
		CheckboxContainer = React.createElement(Foundation.View, {
			tag = "auto-xy padding-x-medium",
			isDisabled = true,
			LayoutOrder = 3,
			onActivated = noOp,
			selection = {
				Selectable = false
			}
		}, {
			checkbox = React.createElement(Foundation.Checkbox, {
				label = "",
				Selectable = false,
				isChecked = v21,
				size = Foundation.Enums.InputSize.XSmall,
				onActivated = noOp
			})
		})
	})
end)
