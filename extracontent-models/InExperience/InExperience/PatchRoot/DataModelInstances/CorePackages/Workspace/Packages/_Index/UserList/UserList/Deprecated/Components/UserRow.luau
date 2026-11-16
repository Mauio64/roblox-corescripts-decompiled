local parent = script:FindFirstAncestor("UserList").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Radius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton

local Avatar = Foundation.Avatar
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens

local function UserRow(props)
	local v = props.displayName == "" or props.username == ""
	local displayName = props.displayName
	local formatted = `@{props.username}`
	local userId = tonumber(props.userId)

	local v2 = useTokens()

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
	local v3 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 12)
		}),
		Avatar = React.createElement(Avatar, {
			userId = userId,
			size = InputSize.Large,
			userPresence = props.userPresence,
			backgroundStyle = v2.Color.Shift.Shift_300,
			LayoutOrder = 1
		}),
		UserInfo = 0
	}

	local createElement2 = React.createElement
	local view = Foundation.View
	local displayName2

	if not v then
		displayName2 = React.createElement(Foundation.Text, {
			LayoutOrder = 1,
			Text = displayName,
			tag = "auto-xy text-title-medium content-emphasis text-align-x-left"
		})
	end

	local username

	if not v then
		username = React.createElement(Foundation.Text, {
			LayoutOrder = 2,
			Text = formatted,
			tag = "auto-xy text-body-medium content-default text-align-x-left"
		})
	end

	local shimmerDisplayName

	if v then
		shimmerDisplayName = React.createElement(Skeleton, {
			LayoutOrder = 1,
			Size = UDim2.new(0.8, 0, 0, v2.Typography.TitleMedium.FontSize + v2.Typography.BodyMedium.FontSize),
			radius = Radius.Circle
		})
	end

	v3.UserInfo = createElement2(
		view,
		{ tag = "size-full-0 auto-y col gap-xsmall align-x-left align-y-center", LayoutOrder = 2 },
		{ DisplayName = displayName2, Username = username, ShimmerDisplayName = shimmerDisplayName }
	)
	return createElement("TextButton", onActivatedsByActivated, v3)
end

return UserRow
