local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local useLocalization = dependencies.useLocalization
local useStyle = dependencies.useStyle
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local IconSize = UIBlox.App.Constant.IconSize
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local TextKeys = require(ContactImporter.Common.TextKeys)
local v15 = Images["icons/graphic/contacts_large"]

local function FindFriendsBanner(t1: {[any]: any}) -- line: 29
	-- upvalues: useLocalization (copy), TextKeys (copy), useStyle (copy), React (copy), ImageSetLabel (copy), IconSize (copy), v15 (copy), StyledTextLabel (copy), Button (copy), ButtonType (copy), StandardButtonSize (copy)
	local openAmpUpsell = t1.openAmpUpsell
	local v19 = not t1.showMatchedContacts
	local v20 = not v19 and 0 or 122
	local isUserInGreenFindFriendsButtonExperiment = t1.isUserInGreenFindFriendsButtonExperiment
	local v22 = useLocalization({
		findFriendsButton = TextKeys.CONTACTS_FIND_FRIENDS_BUTTON,
		findFriendsDescription = TextKeys.CONTACTS_FIND_FRIENDS_DESCRIPTION,
		findFriendsDescriptionPV = TextKeys.CONTACTS_FIND_FRIENDS_DESCRIPTION_PV
	})
	local v23 = useStyle()

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 48),
		LayoutOrder = t1.layoutOrder
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 12)
		}),
		ImageIcon = React.createElement(ImageSetLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(0, IconSize.Large, 0, IconSize.Large),
			ScaleType = Enum.ScaleType.Fit,
			Image = v15,
			ImageTransparency = v23.Theme.SystemPrimaryDefault.Transparency
		}),
		TextFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, -(v20 + 48 + 12), 0, 48)
		}, {
			textLayout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Description = React.createElement(StyledTextLabel, {
				lineHeight = 1,
				text = if not v19 then v22.findFriendsDescriptionPV else v22.findFriendsDescription,
				fontStyle = v23.Font.CaptionBody,
				colorStyle = v23.Theme.TextDefault,
				size = UDim2.new(1, 0, 1, 0),
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center
			})
		}),
		ButtonFrame = if not v19 then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(0, 110, 0, 48),
			AnchorPoint = Vector2.new(1, 0.5)
		}, {
			ButtonLayout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			FindFriendsButton = React.createElement(Button, {
				fitContent = false,
				buttonType = if not isUserInGreenFindFriendsButtonExperiment then ButtonType.PrimarySystem else ButtonType.PrimaryContextual,
				standardSize = StandardButtonSize.XSmall,
				text = v22.findFriendsButton,
				onActivated = openAmpUpsell
			})
		})
	})
end

return FindFriendsBanner
