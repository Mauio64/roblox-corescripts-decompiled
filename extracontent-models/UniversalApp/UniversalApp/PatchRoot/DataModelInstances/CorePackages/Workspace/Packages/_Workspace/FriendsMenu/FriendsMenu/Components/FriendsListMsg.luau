local Parent = script:FindFirstAncestor("FriendsMenu").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local LocalizationHelper = require(Parent.NotificationsCommon).LocalizationHelper
local FFlagConnectionsToFriendsRename = require(Parent.SharedFlags).FFlagConnectionsToFriendsRename
local useStyle = UIBlox.Core.Style.useStyle
local getLocalizedStrings = LocalizationHelper.getLocalizedStrings

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: useStyle (copy), FFlagConnectionsToFriendsRename (copy), getLocalizedStrings (copy), React (copy)
	local v9 = useStyle()
	local Theme = v9.Theme
	local Font = v9.Font
	local t2 = {
		noResultFriendsList = "Feature.SettingsHub.Label.InviteSearchNoResults",
		errorFriendsList = not FFlagConnectionsToFriendsRename and "Feature.SettingsHub.Label.ConnectionsListLoadErrorMessage" or "Feature.SettingsHub.Label.FriendsListLoadErrorMessage"
	}
	local v13 = Font.BaseSize * Font.Body.RelativeSize
	local v14 = getLocalizedStrings(t2)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		Name = t1.msgType
	}, {
		subtitle = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			Text = v14[t1.msgType],
			TextColor3 = Theme.TextDefault.Color,
			TextTransparency = Theme.TextDefault.Transparency,
			TextSize = v13,
			Font = Font.Body.Font,
			Size = UDim2.new(1, 0, 0, v13),
			Position = UDim2.new(0, 0, 0.4, 0),
			TextYAlignment = Enum.TextYAlignment.Top
		})
	})
end
