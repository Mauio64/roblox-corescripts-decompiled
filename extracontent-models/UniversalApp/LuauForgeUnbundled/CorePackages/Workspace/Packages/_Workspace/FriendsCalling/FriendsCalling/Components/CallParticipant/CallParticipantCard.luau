local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/React")

local ParticipantAvatar = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/Components/CallParticipant/ParticipantAvatar")
local RingingIndicator = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/Components/CallParticipant/RingingIndicator")

local avatarSize = Foundation.Enums.AvatarSize
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function useAbsoluteSize()
	local ref = React.useRef(nil)
	local state, setState = React.useState(Vector2.zero)

	React.useEffect(function()
		local current = ref.current

		if current == nil then
			return
		end

		local function update()
			setState(current.AbsoluteSize)
		end

		setState(current.AbsoluteSize)

		local absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, {})

	return ref, state
end

local function CallParticipantCard(props)
	local v5 = useTokens()
	local v6, v7 = useAbsoluteSize()
	local v8, v9 = useAbsoluteSize()
	local size_2600 = v5.Size.Size_2600
	local medium = v5.Padding.Medium

	local udim = UDim2.fromScale(0.5, 0.5)
	local v10

	if v7.X > 0 and v7.Y > 0 then
		local v11 = v7.Y - v9.Y
		local v12 = math.min(size_2600, v7.X - 2 * medium, v11 - medium)
		v10 = math.max(v12, 0) / size_2600
		udim = UDim2.new(0.5, 0, 0, (math.min(v7.Y / 2, v11 - v12 / 2)))
	else
		v10 = 1
	end

	local createElement = React.createElement
	local v12 = {
		ref = v6,
		tag = "size-full stroke-standard stroke-default radius-large clip bg-surface-200",
		testId = props.testId
	}
	local v13 = {
		Avatar = React.createElement(
			view,
			{
				Position = udim,
				Size = UDim2.fromOffset(size_2600, size_2600),
				scale = v10,
				tag = "anchor-center-center"
			},
			{
				Avatar = React.createElement(ParticipantAvatar, {
					avatarSize = avatarSize.Pictogram,
					isDimmed = props.isDimmed,
					isSpeaking = props.isSpeaking,
					ringSize = size_2600,
					userId = props.userId
				})
			}
		),
		Footer = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	local v20 = if props.isMuted then React.createElement(icon, {
		LayoutOrder = 1,
		name = iconName.MicrophoneSlash,
		size = iconSize.Small,
		testId = "friends-calling-participant-muted"
	}) else nil
	local v16 = {
		NameRow = createElement3(
			view,
			{
				LayoutOrder = 1,
				tag = "row align-y-center gap-xsmall size-full-0 auto-y"
			},
			{
				Muted = v20,
				Name = React.createElement(text, {
					LayoutOrder = 2,
					Text = props.name,
					tag = "shrink auto-xy text-title-medium text-no-wrap text-align-x-left text-truncate-end content-emphasis",
					testId = "friends-calling-participant-name"
				})
			}
		),
		StatusRow = 0
	}
	local v21

	if props.statusText ~= nil then
		local createElement4 = React.createElement

		local v24 = {
			Status = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.statusText,
				tag = "shrink auto-xy text-body-medium text-no-wrap text-align-x-left text-truncate-end content-default",
				testId = "friends-calling-participant-status"
			}),
			Animation = 0
		}

		local v25 = if props.showStatusAnimation then React.createElement(RingingIndicator, {
			LayoutOrder = 2,
			testId = "friends-calling-participant-activity"
		}) else nil
		v24.Animation = v25
		v21 = createElement4(
			view,
			{
				LayoutOrder = 2,
				tag = "row align-y-center gap-xsmall size-full-0 auto-y"
			},
			v24
		)
	end

	v16.StatusRow = v21
	v13.Footer = createElement2(
		view,
		{
			ref = v8,
			tag = "col gap-xsmall position-bottom-left anchor-bottom-left size-full-0 auto-y padding-medium"
		},
		v16
	)
	return createElement(view, v12, v13)
end

return CallParticipantCard
