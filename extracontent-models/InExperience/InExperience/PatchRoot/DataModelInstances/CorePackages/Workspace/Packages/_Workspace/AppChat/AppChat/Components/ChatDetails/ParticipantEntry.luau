local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local FFlagAppChatUseProfileFrameThumbnail = require(AppChat.Flags.FFlagAppChatUseProfileFrameThumbnail)

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useUserData = require(AppChat.Hooks.useUserData)
local useTokens = Foundation.Hooks.useTokens
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local UserProfiles = require(parent.UserProfiles)
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber

local v = string.rep("W", 20)

local v2 = { showDivider = true }

local function ParticipantEntry(p)
	local union = Cryo.Dictionary.union(v2, p)
	local v3 = useUserData(union.userId)
	local v4 = useTokens()
	local v5

	if FFlagEnableBlackbirdCheck then
		v5 = union.userId
	end

	local v6 = useIsRobloxSubscriber(v5)

	local onActivated = React.useCallback(function()
		if union.onActivated then
			union.onActivated()
		end
	end, { union.onActivated })

	local v7 = React.useMemo(function()
		local v7

		if FoundationFontFaceMigration then
			v7 = GetTextSize(v, v4.Typography.TitleLarge.FontSize, v4.Typography.TitleLarge.Font, Vector2.zero)
		else
			v7 = Text.GetTextBounds(v, v4.Typography.TitleLarge.Font, v4.Typography.TitleLarge.FontSize, Vector2.zero)
		end

		return UDim2.fromOffset(v7.X, v7.Y)
	end, { v4.Typography.TitleLarge.Font, v4.Typography.TitleLarge.FontSize })

	local v8 = React.useMemo(function()
		local v8

		if FoundationFontFaceMigration then
			v8 = GetTextSize(
				"Roblox Studio",
				v4.Typography.CaptionMedium.FontSize,
				v4.Typography.CaptionMedium.Font,
				Vector2.zero
			)
		else
			v8 = Text.GetTextBounds(
				"Roblox Studio",
				v4.Typography.CaptionMedium.Font,
				v4.Typography.CaptionMedium.FontSize,
				Vector2.zero
			)
		end

		return UDim2.fromOffset(v8.X, v8.Y)
	end, { v4.Typography.CaptionMedium.Font, v4.Typography.CaptionMedium.FontSize })

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
		onActivated = nil
	end

	participantEntryContainer.onActivated = onActivated
	local v9 = {
		Avatar = React.createElement(Foundation.Avatar, {
			userId = v3.id,
			userPresence = v3.presence,
			size = Foundation.Enums.InputSize.Medium,
			backgroundStyle = v4.Color.Shift.Shift_300,
			includeProfileFrame = FFlagAppChatUseProfileFrameThumbnail,
			LayoutOrder = 1
		}),
		UserInfo = 0,
		ChildrenContainer = 0
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v10 = {
		UserDataSkeleton = React.createElement(Foundation.Skeleton, {
			Size = UDim2.new(v7.X, v7.Y + v8.Y),
			Visible = v3.isLoading,
			LayoutOrder = 1
		}),
		DisplayName = 0,
		PresenceText = 0
	}
	local displayName

	if FFlagEnableBlackbirdCheck and v6 then
		displayName = React.createElement(Foundation.View, {
			tag = "row align-y-center gap-xxsmall auto-xy",
			LayoutOrder = 1,
			Visible = v3.isLoading:map(function(p2): boolean
				return not p2
			end)
		}, {
			NameText = React.createElement(Foundation.Text, {
				tag = "shrink auto-xy text-title-large text-truncate-end content-emphasis",
				Text = v3.combinedName,
				LayoutOrder = 1
			}),
			SubscriptionBadge = React.createElement(Foundation.Icon, {
				LayoutOrder = 2,
				name = Foundation.Enums.IconName.RobloxPlus,
				size = Foundation.Enums.IconSize.Small,
				style = v4.Color.Content.Emphasis
			})
		})
	else
		displayName = React.createElement(Foundation.Text, {
			tag = "auto-xy text-title-large text-truncate-end content-emphasis",
			Text = v3.combinedName,
			LayoutOrder = 1,
			Visible = v3.isLoading:map(function(p2): boolean
				return not p2
			end)
		})
	end

	v10.DisplayName = displayName

	local createElement3 = React.createElement
	local text = Foundation.Text
	local text2

	if union.statusText then
		text2 = v3.presenceText:map(function(p2: string)
			return p2 .. " . " .. union.statusText
		end)
	else
		text2 = v3.presenceText
	end

	v10.PresenceText = createElement3(text, {
		tag = "auto-xy text-caption-medium text-truncate-end content-muted",
		Text = text2,
		LayoutOrder = 3,
		Visible = v3.isLoading:map(function(p2): boolean
			return not p2
		end)
	})
	v9.UserInfo = createElement2(view2, { tag = "col fill auto-y clip", LayoutOrder = 2 }, v10)
	local childrenContainer

	if union.children then
		childrenContainer = React.createElement(Foundation.View, {
			tag = "row align-x-right align-y-center auto-y",
			LayoutOrder = 3,
			selection = { Selectable = false },
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }
		}, union.children)
	end

	v9.ChildrenContainer = childrenContainer
	return createElement(view, participantEntryContainer, v9)
end

return React.memo(ParticipantEntry)
