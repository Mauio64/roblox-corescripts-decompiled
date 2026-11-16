local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)
local react = dependencies.React
local uiBlox = dependencies.UIBlox
local useLocalization = dependencies.useLocalization
local useStyle = dependencies.useStyle
local button = uiBlox.App.Button.Button
local buttonType = uiBlox.App.Button.Enum.ButtonType
local iconSize = uiBlox.App.Constant.IconSize
local standardButtonSize = uiBlox.App.Button.Enum.StandardButtonSize
local images = uiBlox.App.ImageSet.Images
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local styledTextLabel = uiBlox.App.Text.StyledTextLabel
local TextKeys = require(ContactImporter.Common.TextKeys)

local iconsgraphiccontacts_large = images["icons/graphic/contacts_large"]

local function FindFriendsBanner(props)
	local openAmpUpsell = props.openAmpUpsell
	local v = not props.showMatchedContacts

	local isUserInGreenFindFriendsButtonExperiment = props.isUserInGreenFindFriendsButtonExperiment

	local v2 = useLocalization({
		findFriendsButton = TextKeys.CONTACTS_FIND_FRIENDS_BUTTON,
		findFriendsDescription = TextKeys.CONTACTS_FIND_FRIENDS_DESCRIPTION,
		findFriendsDescriptionPV = TextKeys.CONTACTS_FIND_FRIENDS_DESCRIPTION_PV
	})

	local v3 = useStyle()

	local createElement = react.createElement
	local v4 = {
		Size = UDim2.new(1, 0, 0, 48),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder
	}
	local v5 = {
		UIListLayout = react.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 12)
		}),
		ImageIcon = react.createElement(imageSetLabel, {
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(0, iconSize.Large, 0, iconSize.Large),
			ScaleType = Enum.ScaleType.Fit,
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Image = iconsgraphiccontacts_large,
			ImageTransparency = v3.Theme.SystemPrimaryDefault.Transparency
		}),
		TextFrame = 0,
		ButtonFrame = 0
	}

	local createElement2 = react.createElement
	local v6 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -((v and 122 or 0) + 48 + 12), 0, 48),
		LayoutOrder = 2
	}

	local v7 = {
		textLayout = react.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Description = 0
	}

	local createElement3 = react.createElement
	local text

	if v then
		text = v2.findFriendsDescription
	else
		text = v2.findFriendsDescriptionPV
	end

	v7.Description = createElement3(styledTextLabel, {
		text = text,
		fontStyle = v3.Font.CaptionBody,
		colorStyle = v3.Theme.TextDefault,
		size = UDim2.new(1, 0, 1, 0),
		lineHeight = 1,
		textTruncate = Enum.TextTruncate.AtEnd,
		textXAlignment = Enum.TextXAlignment.Left,
		textYAlignment = Enum.TextYAlignment.Center
	})
	v5.TextFrame = createElement2("Frame", v6, v7)
	local buttonFrame

	if v then
		local createElement4 = react.createElement
		local v8 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 110, 0, 48),
			AnchorPoint = Vector2.new(1, 0.5),
			LayoutOrder = 3
		}

		local v9 = {
			ButtonLayout = react.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			FindFriendsButton = 0
		}

		local createElement5 = react.createElement
		local buttonType2

		if isUserInGreenFindFriendsButtonExperiment then
			buttonType2 = buttonType.PrimaryContextual
		else
			buttonType2 = buttonType.PrimarySystem
		end

		v9.FindFriendsButton = createElement5(button, {
			buttonType = buttonType2,
			standardSize = standardButtonSize.XSmall,
			fitContent = false,
			text = v2.findFriendsButton,
			onActivated = openAmpUpsell
		})
		buttonFrame = createElement4("Frame", v8, v9)
	end

	v5.ButtonFrame = buttonFrame
	return createElement("Frame", v4, v5)
end

return FindFriendsBanner
