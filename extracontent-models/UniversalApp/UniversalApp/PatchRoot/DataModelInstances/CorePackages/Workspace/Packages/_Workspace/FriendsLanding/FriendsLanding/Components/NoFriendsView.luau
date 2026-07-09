local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsLandingParent = FriendsLanding.Parent
local FFlagConnectionsToFriendsRename = require(FriendsLandingParent.SharedFlags).FFlagConnectionsToFriendsRename
local dependencies = require(FriendsLanding.dependencies)
local React = dependencies.React
local Dash = dependencies.Dash
local UIBlox = dependencies.UIBlox
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local Colors = UIBlox.App.Style.Colors
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useLocalization = dependencies.Hooks.useLocalization
local TextKeys = require(FriendsLanding.Common.TextKeys)
local AppFonts = require(FriendsLandingParent.Style).AppFonts
local Image = require(FriendsLandingParent.Foundation).Image
local FoundationCloudAssets = require(FriendsLandingParent.FoundationCloudAssets)
local Assets = FoundationCloudAssets.Assets
local preloadAsset = FoundationCloudAssets.preloadAsset
local v23 = game:DefineFastFlag("MigrateNoFriendsViewToFoundation", false)
local t1 = {
	layoutOrder = 0,
	pageLoadingTimeReport = nil,
	pageRenderReport = nil,
	addFriendsBtnEnabled = true,
	openAddFriendsPage = Dash.noop,
	addFriendsBtnLabelKey = if not FFlagConnectionsToFriendsRename then TextKeys.ADD_CONNECTIONS_BTN else TextKeys.ADD_FRIENDS_BTN,
	noFriendsTextLabelKey = if not FFlagConnectionsToFriendsRename then TextKeys.NO_CONNECTIONS_TEXT else TextKeys.NO_FRIENDS_TEXT
}

local function loadFoundationCloudAsset(s1: string) -- line: 64
	-- upvalues: preloadAsset (copy), Assets (copy)
	preloadAsset(s1)

	local v28 = Assets[s1]

	return v28.assetId, v28.size
end
local function NoFriendsView(p1) -- line: 70
	-- upvalues: Dash (copy), t1 (copy), v23 (copy), preloadAsset (copy), Assets (copy), React (copy), useLocalization (copy), useStyle (copy), Image (copy), ImageSetLabel (copy), Images (copy), Colors (copy), StyledTextLabel (copy), AppFonts (copy), Button (copy), ButtonType (copy), StandardButtonSize (copy)
	local v30 = Dash.join(t1, p1 or {})
	local v31 = if not v23 then nil else "pictograms/collaborators"
	local assetId = nil
	local size = nil

	if v23 then
		preloadAsset(v31)

		local v34 = Assets[v31]

		assetId = v34.assetId
		size = v34.size
	end

	local v35 = if not v23 then nil else size / 3

	React.useEffect(function() -- line: 83
		-- upvalues: v30 (copy)
		if v30.pageLoadingTimeReport then
			v30.pageLoadingTimeReport()
		end

		if v30.pageRenderReport then
			v30.pageRenderReport()
		end
	end, {})

	local v36 = useLocalization({
		addFriendsBtn = v30.addFriendsBtnLabelKey,
		noFriendsText = v30.noFriendsTextLabelKey,
		noFriendsHeader = v30.noFriendsHeaderKey
	})
	local v37 = useStyle()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		LayoutOrder = v30.layoutOrder
	}, {
		IndicatorInner = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			SidePadding = React.createElement("UIPadding", {
				PaddingRight = UDim.new(0, 30),
				PaddingLeft = UDim.new(0, 30)
			}),
			UIList = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 15)
			}),
			Imagelabel = if not v23 then React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Image = Images["icons/graphic/findfriends_xlarge"],
				ImageColor3 = Colors.White,
				Size = UDim2.fromOffset(96, 96)
			}) else React.createElement(Image, {
				LayoutOrder = 1,
				Image = assetId,
				Size = UDim2.fromOffset(v35.X, v35.Y)
			}),
			Headerlabel = if not v30.noFriendsHeaderKey or not v36.noFriendsHeader then nil else React.createElement(StyledTextLabel, {
				layoutOrder = 2,
				text = v36.noFriendsHeader,
				fontStyle = v37.Font.Header1,
				colorStyle = v37.Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.Y,
				size = UDim2.new(1, 0, 0, 0),
				textXAlignment = Enum.TextXAlignment.Center,
				textYAlignment = Enum.TextYAlignment.Center
			}),
			Textlabel = React.createElement("TextLabel", {
				TextWrapped = true,
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				AutomaticSize = Enum.AutomaticSize.Y,
				Font = AppFonts.default:getDefault(),
				Size = UDim2.new(1, 0, 0, 0),
				Text = v36.noFriendsText,
				TextColor3 = v37.Theme.TextMuted.Color,
				TextSize = v37.Font.Header2.RelativeSize * v37.Font.BaseSize,
				TextTransparency = v37.Theme.TextMuted.Transparency
			}),
			Padding = React.createElement("Frame", {
				LayoutOrder = 4,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 0, 0, 10)
			}),
			AddFriendsButton = v30.addFriendsBtnEnabled and React.createElement(Button, {
				layoutOrder = 5,
				buttonType = ButtonType.PrimarySystem,
				text = v36.addFriendsBtn,
				standardSize = StandardButtonSize.Regular,
				onActivated = v30.openAddFriendsPage
			})
		})
	})
end

return NoFriendsView
