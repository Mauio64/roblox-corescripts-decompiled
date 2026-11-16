local parent = script:FindFirstAncestor("FriendsCalling").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local ParticipantAvatar = require(script.Parent.ParticipantAvatar)
local RingingIndicator = require(script.Parent.RingingIndicator)

local AvatarSize = Foundation.Enums.AvatarSize
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function useAbsoluteSize()
	local ref = React.useRef(nil)
	local state, setState = React.useState(Vector2.zero)

	React.useEffect(function()
		local current = ref.current

		if current == nil then
			return
		end

		local function update() -- 1 equivalent call inferred from this helper
			setState(current.AbsoluteSize)
		end

		update() -- inferred equivalent call
		local absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, {})

	return ref, state
end

local function CallParticipantCard(props)
	local v = useTokens()
	local ref, v2 = useAbsoluteSize()
	local ref2, v3 = useAbsoluteSize()
	local size_2600 = v.Size.Size_2600
	local medium = v.Padding.Medium

	local udim = UDim2.fromScale(0.5, 0.5)
	local scale

	if v2.X > 0 and v2.Y > 0 then
		local v4 = v2.Y - v3.Y
		local v5 = math.min(size_2600, v2.X - 2 * medium, v4 - medium)
		scale = math.max(v5, 0) / size_2600
		udim = UDim2.new(0.5, 0, 0, (math.min(v2.Y / 2, v4 - v5 / 2)))
	else
		scale = 1
	end

	local createElement = React.createElement
	local v4 = {
		ref = ref,
		tag = "size-full stroke-standard stroke-default radius-large clip bg-surface-200",
		testId = props.testId
	}
	local v5 = {
		Avatar = React.createElement(
			View,
			{
				Position = udim,
				Size = UDim2.fromOffset(size_2600, size_2600),
				scale = scale,
				tag = "anchor-center-center"
			},
			{
				Avatar = React.createElement(ParticipantAvatar, {
					avatarSize = AvatarSize.Pictogram,
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
	local muted

	if props.isMuted then
		muted = React.createElement(Icon, {
			LayoutOrder = 1,
			name = IconName.MicrophoneSlash,
			size = IconSize.Small,
			testId = "friends-calling-participant-muted"
		})
	end

	local v6 = {
		NameRow = createElement3(View, {
			LayoutOrder = 1,
			tag = "row align-y-center gap-xsmall size-full-0 auto-y"
		}, {
			Muted = muted,
			Name = React.createElement(Text, {
				LayoutOrder = 2,
				Text = props.name,
				tag = "shrink auto-xy text-title-medium text-no-wrap text-align-x-left text-truncate-end content-emphasis",
				testId = "friends-calling-participant-name"
			})
		}),
		StatusRow = 0
	}
	local statusRow

	if props.statusText ~= nil then
		local createElement4 = React.createElement

		local v7 = {
			Status = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.statusText,
				tag = "shrink auto-xy text-body-medium text-no-wrap text-align-x-left text-truncate-end content-default",
				testId = "friends-calling-participant-status"
			}),
			Animation = 0
		}
		local animation

		if props.showStatusAnimation then
			animation = React.createElement(RingingIndicator, {
				LayoutOrder = 2,
				testId = "friends-calling-participant-activity"
			})
		end

		v7.Animation = animation
		statusRow = createElement4(
			View,
			{ LayoutOrder = 2, tag = "row align-y-center gap-xsmall size-full-0 auto-y" },
			v7
		)
	end

	v6.StatusRow = statusRow
	v5.Footer = createElement2(
		View,
		{
			ref = ref2,
			tag = "col gap-xsmall position-bottom-left anchor-bottom-left size-full-0 auto-y padding-medium"
		},
		v6
	)
	return createElement(View, v4, v5)
end

return CallParticipantCard
