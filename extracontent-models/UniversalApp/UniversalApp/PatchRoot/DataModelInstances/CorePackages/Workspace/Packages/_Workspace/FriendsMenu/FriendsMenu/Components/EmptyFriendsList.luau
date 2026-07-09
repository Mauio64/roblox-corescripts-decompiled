local Parent = script:FindFirstAncestor("FriendsMenu").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local LocalizationHelper = require(Parent.NotificationsCommon).LocalizationHelper
local FFlagConnectionsToFriendsRename = require(Parent.SharedFlags).FFlagConnectionsToFriendsRename
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local getLocalizedStrings = LocalizationHelper.getLocalizedStrings
local v10 = Images["icons/menu/friends_large"]

return function() -- line: 21
	-- upvalues: useStyle (copy), FFlagConnectionsToFriendsRename (copy), getLocalizedStrings (copy), React (copy), ImageSetLabel (copy), v10 (copy)
	local v11 = useStyle()
	local Theme = v11.Theme
	local Font = v11.Font
	local t1 = {
		noFriendsText = not FFlagConnectionsToFriendsRename and "Feature.SettingsHub.Label.NoConnectionsPageMessage" or "Feature.SettingsHub.Label.NoFriendsPageMessage"
	}
	local v15 = getLocalizedStrings(t1)
	local v16 = Font.BaseSize * Font.Body.RelativeSize

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Name = "EmptyFriendsList",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, -20)
	}, {
		listLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 12)
		}),
		friendsIcon = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Image = v10,
			Size = UDim2.new(0, 48, 0, 48)
		}),
		subtitle = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			LayoutOrder = 2,
			Text = v15.noFriendsText,
			TextColor3 = Theme.TextDefault.Color,
			TextTransparency = Theme.TextDefault.Transparency,
			TextSize = v16,
			Font = Font.Body.Font,
			Size = UDim2.new(1, 0, 0, v16),
			TextYAlignment = Enum.TextYAlignment.Top
		})
	})
end
