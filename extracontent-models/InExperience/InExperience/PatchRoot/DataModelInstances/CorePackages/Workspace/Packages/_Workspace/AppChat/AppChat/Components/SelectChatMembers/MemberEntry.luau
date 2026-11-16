local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local FFlagAppChatUseProfileFrameThumbnail = require(AppChat.Flags.FFlagAppChatUseProfileFrameThumbnail)

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local GetSelectedUsersStore = require(AppChat.Stores.GetSelectedUsersStore)
local useUserData = require(AppChat.Hooks.useUserData)

local function MemberEntry(p)
	local v = useTokens()
	local selectedUsersStore = GetSelectedUsersStore(false)
	local v2 = useSignalState(selectedUsersStore.getSelectedUserIdAtIndex(p.index))

	local v3 = useUserData(v2 or "")

	local onActivated = React.useCallback(function()
		if v2 then
			selectedUsersStore.removeUserId(v2)
		end
	end, { v2 })

	local createElement = React.createElement
	local view = Foundation.View

	if not v2 then
		onActivated = nil
	end

	local v4 = {
		tag = "auto-xy",
		onActivated = onActivated,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		LayoutOrder = p.index
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local avatar

	if v2 then
		avatar = React.createElement(Foundation.Avatar, {
			userId = v3.id,
			userPresence = v3.presence,
			size = Foundation.Enums.InputSize.Large,
			backgroundStyle = v.Color.Shift.Shift_300,
			includeProfileFrame = FFlagAppChatUseProfileFrameThumbnail,
			LayoutOrder = 1
		})
	else
		avatar = React.createElement(Foundation.Image, {
			tag = "content-emphasis",
			Image = "rbxasset://textures/ui/LuaChatV2/ic-friend-empty-border.png",
			aspectRatio = {
				AspectRatio = 1,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Height
			},
			Size = UDim2.fromOffset(v.Size.Size_1200, v.Size.Size_1200),
			LayoutOrder = 1
		})
	end

	local v5 = {
		UserContainer = createElement2(
			view2,
			{ tag = "col size-0-full auto-x flex-x-fill align-x-center gap-xsmall" },
			{
				Avatar = avatar,
				Label = React.createElement(Foundation.Text, {
					tag = "auto-y text-truncate-end text-caption-small",
					Text = v3.combinedName,
					textStyle = v.Color.Content.Default,
					fontStyle = v.Typography.CaptionSmall,
					LayoutOrder = 2
				})
			}
		),
		RemoveIcon = 0
	}
	local removeIcon

	if v2 then
		removeIcon = React.createElement(
			Foundation.View,
			{
				tag = "auto-xy position-top-right anchor-top-right bg-over-media-0 radius-circle",
				ZIndex = 2
			},
			{
				Icon = React.createElement(Foundation.Icon, {
					style = v.Color.Content.Emphasis,
					name = Foundation.Enums.IconName.CircleX,
					variant = Foundation.Enums.IconVariant.Filled,
					size = Foundation.Enums.IconSize.Small,
					ZIndex = 2
				})
			}
		)
	end

	v5.RemoveIcon = removeIcon
	return createElement(view, v4, v5)
end

return React.memo(MemberEntry)
