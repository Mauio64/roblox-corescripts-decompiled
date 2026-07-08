local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Foundation = require(AppChatParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useSignalState = require(AppChatParent.SignalsReact).useSignalState
local GetSelectedUsersStore = require(AppChat.Stores.GetSelectedUsersStore)
local useUserData = require(AppChat.Hooks.useUserData)

local function MemberEntry(t1: {[any]: any}) -- line: 23
	-- upvalues: useTokens (copy), GetSelectedUsersStore (copy), useSignalState (copy), useUserData (copy), React (copy), Foundation (copy)
	local v11 = useTokens()
	local v12 = GetSelectedUsersStore(false)
	local v13 = useSignalState(v12.getSelectedUserIdAtIndex(t1.index))
	local v14 = useUserData(v13 or "")
	local v15 = React.useCallback(function() -- line: 30
		-- upvalues: v13 (copy), v12 (copy)
		if v13 then
			v12.removeUserId(v13)
		end
	end, { v13 })

	return React.createElement(Foundation.View, {
		tag = "auto-xy",
		onActivated = if not v13 then nil else v15,
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		LayoutOrder = t1.index
	}, {
		UserContainer = React.createElement(Foundation.View, {
			tag = "col size-0-full auto-x flex-x-fill align-x-center gap-xsmall"
		}, {
			Avatar = if not v13 then React.createElement(Foundation.Image, {
				tag = "content-emphasis",
				Image = "rbxasset://textures/ui/LuaChatV2/ic-friend-empty-border.png",
				LayoutOrder = 1,
				aspectRatio = {
					AspectRatio = 1,
					AspectType = Enum.AspectType.FitWithinMaxSize,
					DominantAxis = Enum.DominantAxis.Height
				},
				Size = UDim2.fromOffset(v11.Size.Size_1200, v11.Size.Size_1200)
			}) else React.createElement(Foundation.Avatar, {
				LayoutOrder = 1,
				userId = v14.id,
				userPresence = v14.presence,
				size = Foundation.Enums.InputSize.Large,
				backgroundStyle = v11.Color.Shift.Shift_300
			}),
			Label = React.createElement(Foundation.Text, {
				tag = "auto-y text-truncate-end text-caption-small",
				LayoutOrder = 2,
				Text = v14.combinedName,
				textStyle = v11.Color.Content.Default,
				fontStyle = v11.Typography.CaptionSmall
			})
		}),
		RemoveIcon = if not v13 then nil else React.createElement(Foundation.View, {
			tag = "auto-xy position-top-right anchor-top-right bg-over-media-0 radius-circle",
			ZIndex = 2
		}, {
			Icon = React.createElement(Foundation.Icon, {
				ZIndex = 2,
				style = v11.Color.Content.Emphasis,
				name = Foundation.Enums.IconName.CircleX,
				variant = Foundation.Enums.IconVariant.Filled,
				size = Foundation.Enums.IconSize.Small
			})
		})
	})
end

return React.memo(MemberEntry)
