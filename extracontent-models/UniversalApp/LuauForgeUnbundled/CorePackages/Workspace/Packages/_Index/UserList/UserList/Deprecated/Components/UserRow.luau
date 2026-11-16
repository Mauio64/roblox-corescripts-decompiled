local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation")
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton

local avatar = Foundation.Avatar
local inputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens

local function UserRow(props)
	local v5 = props.displayName == "" or props.username == ""
	local displayName = props.displayName
	local formatted = `@{props.username}`
	local userId = tonumber(props.userId)

	local v6 = useTokens()

	if userId == nil then
		return nil
	end

	local createElement = React.createElement
	local onActivatedsByActivated = {
		Size = UDim2.new(1, 0, 0, 48),
		BackgroundTransparency = 1,
		Text = "",
		BorderSizePixel = 0,
		[React.Event.Activated] = props.onActivated
	}
	local v8 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 12)
		}),
		Avatar = React.createElement(avatar, {
			userId = userId,
			size = inputSize.Large,
			userPresence = props.userPresence,
			backgroundStyle = v6.Color.Shift.Shift_300,
			LayoutOrder = 1
		}),
		UserInfo = 0
	}

	local createElement2 = React.createElement
	local view = Foundation.View

	local v11 = if not v5 then React.createElement(Foundation.Text, {
		LayoutOrder = 1,
		Text = displayName,
		tag = "auto-xy text-title-medium content-emphasis text-align-x-left"
	}) else nil

	local v12 = if not v5 then React.createElement(Foundation.Text, {
		LayoutOrder = 2,
		Text = formatted,
		tag = "auto-xy text-body-medium content-default text-align-x-left"
	}) else nil

	local v13 = if v5 then React.createElement(skeleton, {
		LayoutOrder = 1,
		Size = UDim2.new(0.8, 0, 0, v6.Typography.TitleMedium.FontSize + v6.Typography.BodyMedium.FontSize),
		radius = radius.Circle
	}) else nil
	v8.UserInfo = createElement2(
		view,
		{
			tag = "size-full-0 auto-y col gap-xsmall align-x-left align-y-center",
			LayoutOrder = 2
		},
		{ DisplayName = v11, Username = v12, ShimmerDisplayName = v13 }
	)
	return createElement("TextButton", onActivatedsByActivated, v8)
end

return UserRow
