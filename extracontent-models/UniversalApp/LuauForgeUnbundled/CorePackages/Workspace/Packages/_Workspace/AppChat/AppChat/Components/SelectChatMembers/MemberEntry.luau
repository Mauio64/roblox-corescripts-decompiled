local FFlagAppChatUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseProfileFrameThumbnail")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local useTokens = Foundation.Hooks.useTokens
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState

local GetSelectedUsersStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetSelectedUsersStore")
local useUserData = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useUserData")

local function MemberEntry(p2)
	local v5 = useTokens()
	local v6 = GetSelectedUsersStore(false)
	local v7 = useSignalState(v6.getSelectedUserIdAtIndex(p2.index))

	local v8 = useUserData(v7 or "")

	local v9 = React.useCallback(function()
		if v7 then
			v6.removeUserId(v7)
		end
	end, { v7 })

	local createElement = React.createElement
	local view = Foundation.View

	if not v7 then
		v9 = nil
	end

	local v10 = {
		tag = "auto-xy",
		onActivated = v9,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		LayoutOrder = p2.index
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v14

	if v7 then
		v14 = React.createElement(Foundation.Avatar, {
			userId = v8.id,
			userPresence = v8.presence,
			size = Foundation.Enums.InputSize.Large,
			backgroundStyle = v5.Color.Shift.Shift_300,
			includeProfileFrame = FFlagAppChatUseProfileFrameThumbnail,
			LayoutOrder = 1
		})
	else
		v14 = React.createElement(Foundation.Image, {
			tag = "content-emphasis",
			Image = "rbxasset://textures/ui/LuaChatV2/ic-friend-empty-border.png",
			aspectRatio = {
				AspectRatio = 1,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Height
			},
			Size = UDim2.fromOffset(v5.Size.Size_1200, v5.Size.Size_1200),
			LayoutOrder = 1
		})
	end

	local v11 = {
		UserContainer = createElement2(
			view2,
			{ tag = "col size-0-full auto-x flex-x-fill align-x-center gap-xsmall" },
			{
				Avatar = v14,
				Label = React.createElement(Foundation.Text, {
					tag = "auto-y text-truncate-end text-caption-small",
					Text = v8.combinedName,
					textStyle = v5.Color.Content.Default,
					fontStyle = v5.Typography.CaptionSmall,
					LayoutOrder = 2
				})
			}
		),
		RemoveIcon = 0
	}

	local v15 = if v7 then React.createElement(
		Foundation.View,
		{
			tag = "auto-xy position-top-right anchor-top-right bg-over-media-0 radius-circle",
			ZIndex = 2
		},
		{
			Icon = React.createElement(Foundation.Icon, {
				style = v5.Color.Content.Emphasis,
				name = Foundation.Enums.IconName.CircleX,
				variant = Foundation.Enums.IconVariant.Filled,
				size = Foundation.Enums.IconSize.Small,
				ZIndex = 2
			})
		}
	) else nil
	v11.RemoveIcon = v15
	return createElement(view, v10, v11)
end

return React.memo(MemberEntry)
