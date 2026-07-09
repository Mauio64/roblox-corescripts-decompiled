local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local Foundation = require(AppChatParent.Foundation)
local Text = require(AppChatParent.AppCommonLib).Text
local useUserData = require(AppChat.Hooks.useUserData)
local useTokens = Foundation.Hooks.useTokens
local FFlagEnableBlackbirdCheck = require(AppChatParent.SharedFlags).FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = require(AppChatParent.UserProfiles).Hooks.useIsRobloxSubscriber
local v11 = string.rep("W", 20)
local t1 = {
	showDivider = true
}

local function ParticipantEntry(t2: {[any]: any}) -- line: 32
	-- upvalues: Cryo (copy), t1 (copy), useUserData (copy), useTokens (copy), useIsRobloxSubscriber (copy), FFlagEnableBlackbirdCheck (copy), React (copy), Text (copy), v11 (copy), Foundation (copy)
	local v15 = Cryo.Dictionary.union(t1, t2)
	local v16 = useUserData(v15.userId)
	local v17 = useTokens()
	local v18 = useIsRobloxSubscriber(if not FFlagEnableBlackbirdCheck then nil else v15.userId)
	local v19 = React.useCallback(function() -- line: 39
		-- upvalues: v15 (copy)
		if v15.onActivated then
			v15.onActivated()
		end
	end, { v15.onActivated })
	local v20 = React.useMemo(function() -- line: 45
		-- upvalues: Text (copy), v11 (copy), v17 (copy)
		local v22 = Text.GetTextBounds(v11, v17.Typography.TitleLarge.Font, v17.Typography.TitleLarge.FontSize, Vector2.zero)

		return UDim2.fromOffset(v22.X, v22.Y)
	end, {
		v17.Typography.TitleLarge.Font,
		v17.Typography.TitleLarge.FontSize
	})
	local v21 = React.useMemo(function() -- line: 55
		-- upvalues: Text (copy), v17 (copy)
		local v23 = Text.GetTextBounds("Roblox Studio", v17.Typography.CaptionMedium.Font, v17.Typography.CaptionMedium.FontSize, Vector2.zero)

		return UDim2.fromOffset(v23.X, v23.Y)
	end, {
		v17.Typography.CaptionMedium.Font,
		v17.Typography.CaptionMedium.FontSize
	})

	return React.createElement(Foundation.View, {
		Name = "ParticipantEntryContainer",
		tag = {
			["row align-y-center gap-medium size-full padding-x-medium"] = true,
			["stroke-thin stroke-muted"] = v15.showDivider
		},
		onActivated = if not v15.onActivated then nil else v19
	}, {
		Avatar = React.createElement(Foundation.Avatar, {
			LayoutOrder = 1,
			userId = v16.id,
			userPresence = v16.presence,
			size = Foundation.Enums.InputSize.Medium,
			backgroundStyle = v17.Color.Shift.Shift_300
		}),
		UserInfo = React.createElement(Foundation.View, {
			tag = "col fill auto-y clip",
			LayoutOrder = 2
		}, {
			UserDataSkeleton = React.createElement(Foundation.Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(v20.X, v20.Y + v21.Y),
				Visible = v16.isLoading
			}),
			DisplayName = if not FFlagEnableBlackbirdCheck or not v18 then React.createElement(Foundation.Text, {
				tag = "auto-xy text-title-large text-truncate-end content-emphasis",
				LayoutOrder = 1,
				Text = v16.combinedName,
				Visible = v16.isLoading:map(function(p1) -- line: 114
					return not p1
				end)
			}) else React.createElement(Foundation.View, {
				tag = "row align-y-center gap-xxsmall auto-xy",
				LayoutOrder = 1,
				Visible = v16.isLoading:map(function(p2) -- line: 94
					return not p2
				end)
			}, {
				NameText = React.createElement(Foundation.Text, {
					tag = "shrink auto-xy text-title-large text-truncate-end content-emphasis",
					LayoutOrder = 1,
					Text = v16.combinedName
				}),
				SubscriptionBadge = React.createElement(Foundation.Icon, {
					LayoutOrder = 2,
					name = Foundation.Enums.IconName.RobloxPlus,
					size = Foundation.Enums.IconSize.Small,
					style = v17.Color.Content.Emphasis
				})
			}),
			PresenceText = React.createElement(Foundation.Text, {
				tag = "auto-xy text-caption-medium text-truncate-end content-muted",
				LayoutOrder = 3,
				Text = if not v15.statusText then v16.presenceText else v16.presenceText:map(function(s1: string) -- line: 122
					-- upvalues: v15 (copy)
					return s1 .. " . " .. v15.statusText
				end),
				Visible = v16.isLoading:map(function(p3) -- line: 127
					return not p3
				end)
			})
		}),
		ChildrenContainer = if not v15.children then nil else React.createElement(Foundation.View, {
			tag = "row align-x-right align-y-center auto-y",
			LayoutOrder = 3,
			selection = {
				Selectable = false
			},
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			}
		}, v15.children)
	})
end

return React.memo(ParticipantEntry)
