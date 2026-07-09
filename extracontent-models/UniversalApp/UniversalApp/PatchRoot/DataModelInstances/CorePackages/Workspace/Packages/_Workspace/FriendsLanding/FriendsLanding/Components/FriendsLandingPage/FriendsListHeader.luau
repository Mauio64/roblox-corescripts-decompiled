local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local FriendsLandingParent = FriendsLanding.Parent
local useStyle = dependencies.UIBlox.Core.Style.useStyle
local useLocalization = dependencies.Hooks.useLocalization
local TenFootUiGridCarouselHeader = require(FriendsLandingParent.TenFootUiSharedComponents).TenFootUiGridCarouselHeader
local React = require(FriendsLandingParent.React)

local function FriendsListHeader(t1: {[any]: any}) -- line: 16
	-- upvalues: useStyle (copy), useLocalization (copy), React (copy), TenFootUiGridCarouselHeader (copy)
	local v10 = useStyle()
	local v11 = useLocalization({
		friends = "CommonUI.Features.Label.Friends"
	})
	local str = tostring(t1.friendCount or 0)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v10.Tokens.Size.Size_1000)
		}),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		GridHeader = React.createElement(TenFootUiGridCarouselHeader, {
			text = `{ v11.friends } ({ str })`
		})
	})
end

return FriendsListHeader
