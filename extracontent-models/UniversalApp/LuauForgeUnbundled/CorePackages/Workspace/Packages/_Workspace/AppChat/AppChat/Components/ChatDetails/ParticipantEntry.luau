local FFlagAppChatUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseProfileFrameThumbnail")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Text
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Style").GetTextSize
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useUserData = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useUserData")
local useTokens = Foundation.Hooks.useTokens
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserProfiles").Hooks.useIsRobloxSubscriber

local v5 = string.rep("W", 20)

local v6 = { showDivider = true }

local function ParticipantEntry(p2)
	local union = Cryo.Dictionary.union(v6, p2)
	local v7 = useUserData(union.userId)
	local v8 = useTokens()

	local v10 = if fFlagEnableBlackbirdCheck then union.userId else nil
	local v11 = useIsRobloxSubscriber(v10)

	local v12 = React.useCallback(function()
		if union.onActivated then
			union.onActivated()
		end
	end, { union.onActivated })

	local v13 = React.useMemo(function()
		local v14

		if foundationFontFaceMigration then
			v14 = getTextSize(
				v5,
				v8.Typography.TitleLarge.FontSize,
				v8.Typography.TitleLarge.Font,
				Vector2.zero
			)
		else
			v14 = text.GetTextBounds(
				v5,
				v8.Typography.TitleLarge.Font,
				v8.Typography.TitleLarge.FontSize,
				Vector2.zero
			)
		end

		return UDim2.fromOffset(v14.X, v14.Y)
	end, { v8.Typography.TitleLarge.Font, v8.Typography.TitleLarge.FontSize })

	local v14 = React.useMemo(function()
		local v15

		if foundationFontFaceMigration then
			v15 = getTextSize(
				"Roblox Studio",
				v8.Typography.CaptionMedium.FontSize,
				v8.Typography.CaptionMedium.Font,
				Vector2.zero
			)
		else
			v15 = text.GetTextBounds(
				"Roblox Studio",
				v8.Typography.CaptionMedium.Font,
				v8.Typography.CaptionMedium.FontSize,
				Vector2.zero
			)
		end

		return UDim2.fromOffset(v15.X, v15.Y)
	end, { v8.Typography.CaptionMedium.Font, v8.Typography.CaptionMedium.FontSize })

	local createElement = React.createElement
	local view = Foundation.View
	local participantEntryContainer = {
		Name = "ParticipantEntryContainer",
		tag = {
			["row align-y-center gap-medium size-full padding-x-medium"] = true,
			["stroke-thin stroke-muted"] = union.showDivider
		},
		onActivated = 0
	}

	if not union.onActivated then
		v12 = nil
	end

	participantEntryContainer.onActivated = v12
	local v15 = {
		Avatar = React.createElement(Foundation.Avatar, {
			userId = v7.id,
			userPresence = v7.presence,
			size = Foundation.Enums.InputSize.Medium,
			backgroundStyle = v8.Color.Shift.Shift_300,
			includeProfileFrame = FFlagAppChatUseProfileFrameThumbnail,
			LayoutOrder = 1
		}),
		UserInfo = 0,
		ChildrenContainer = 0
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v17 = {
		UserDataSkeleton = React.createElement(Foundation.Skeleton, {
			Size = UDim2.new(v13.X, v13.Y + v14.Y),
			Visible = v7.isLoading,
			LayoutOrder = 1
		}),
		DisplayName = 0,
		PresenceText = 0
	}
	local v18

	if fFlagEnableBlackbirdCheck and v11 then
		v18 = React.createElement(Foundation.View, {
			tag = "row align-y-center gap-xxsmall auto-xy",
			LayoutOrder = 1,
			Visible = v7.isLoading:map(function(p3): boolean
				return not p3
			end)
		}, {
			NameText = React.createElement(Foundation.Text, {
				tag = "shrink auto-xy text-title-large text-truncate-end content-emphasis",
				Text = v7.combinedName,
				LayoutOrder = 1
			}),
			SubscriptionBadge = React.createElement(Foundation.Icon, {
				LayoutOrder = 2,
				name = Foundation.Enums.IconName.RobloxPlus,
				size = Foundation.Enums.IconSize.Small,
				style = v8.Color.Content.Emphasis
			})
		})
	else
		v18 = React.createElement(Foundation.Text, {
			tag = "auto-xy text-title-large text-truncate-end content-emphasis",
			Text = v7.combinedName,
			LayoutOrder = 1,
			Visible = v7.isLoading:map(function(p3): boolean
				return not p3
			end)
		})
	end

	v17.DisplayName = v18

	local createElement3 = React.createElement
	local text2 = Foundation.Text
	local v20

	if union.statusText then
		v20 = v7.presenceText:map(function(p3)
			return p3 .. " . " .. union.statusText
		end)
	else
		v20 = v7.presenceText
	end

	v17.PresenceText = createElement3(text2, {
		tag = "auto-xy text-caption-medium text-truncate-end content-muted",
		Text = v20,
		LayoutOrder = 3,
		Visible = v7.isLoading:map(function(p3): boolean
			return not p3
		end)
	})
	v15.UserInfo = createElement2(view2, {
		tag = "col fill auto-y clip",
		LayoutOrder = 2
	}, v17)

	local v21 = if union.children then React.createElement(Foundation.View, {
		tag = "row align-x-right align-y-center auto-y",
		LayoutOrder = 3,
		selection = { Selectable = false },
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }
	}, union.children) else nil
	v15.ChildrenContainer = v21
	return createElement(view, participantEntryContainer, v15)
end

return React.memo(ParticipantEntry)
