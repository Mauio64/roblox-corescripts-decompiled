local Parent = script:FindFirstAncestor("UserList").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local Avatar = Foundation.Avatar
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens

local function UserRow(t1: {[any]: any}) -- line: 26
	-- upvalues: useTokens (copy), React (copy), Avatar (copy), InputSize (copy), Foundation (copy), Skeleton (copy), EnumsRadius (copy)
	local v11 = t1.displayName == "" or t1.username == ""
	local displayName = t1.displayName
	local v13 = `@{ t1.username }`
	local num = tonumber(t1.userId)
	local v15 = useTokens()

	if num == nil then
		return nil
	end

	return React.createElement("TextButton", {
		Size = UDim2.new(1, 0, 0, 48),
		BackgroundTransparency = 1,
		Text = "",
		BorderSizePixel = 0,
		[React.Event.Activated] = t1.onActivated
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 12)
		}),
		Avatar = React.createElement(Avatar, {
			LayoutOrder = 1,
			userId = num,
			size = InputSize.Large,
			userPresence = t1.userPresence,
			backgroundStyle = v15.Color.Shift.Shift_300
		}),
		UserInfo = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y col gap-xsmall align-x-left align-y-center",
			LayoutOrder = 2
		}, {
			DisplayName = if v11 then nil else React.createElement(Foundation.Text, {
				LayoutOrder = 1,
				tag = "auto-xy text-title-medium content-emphasis text-align-x-left",
				Text = displayName
			}),
			Username = if v11 then nil else React.createElement(Foundation.Text, {
				LayoutOrder = 2,
				tag = "auto-xy text-body-medium content-default text-align-x-left",
				Text = v13
			}),
			ShimmerDisplayName = if not v11 then nil else React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(0.8, 0, 0, v15.Typography.TitleMedium.FontSize + v15.Typography.BodyMedium.FontSize),
				radius = EnumsRadius.Circle
			})
		})
	})
end

return UserRow
