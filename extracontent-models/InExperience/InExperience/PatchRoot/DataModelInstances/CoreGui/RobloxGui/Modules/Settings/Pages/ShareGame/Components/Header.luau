local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Roact = require(CorePackages.Packages.Roact)
local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local Theme = require(RobloxGui.Modules.Settings.Theme)
local Constants = require(ShareGame.Constants)
local BackButton = require(ShareGame.Components.BackButton)
local SearchArea = require(ShareGame.Components.SearchArea)
local v9 = require(ShareGame.getTranslator)()
local v10 = Roact.PureComponent:extend("Header")

function v10.render(p1) -- line: 20
	-- upvalues: Constants (copy), BackButton (copy), Roact (copy), v9 (copy), Theme (copy), SearchArea (copy)
	local deviceLayout = p1.props.deviceLayout
	local size = p1.props.size
	local layoutOrder = p1.props.layoutOrder
	local zIndex = p1.props.zIndex
	local closePage = p1.props.closePage
	local searchAreaActive = p1.props.searchAreaActive
	local analytics = p1.props.analytics
	local toggleSearchIcon = p1.props.toggleSearchIcon
	local iconType = p1.props.iconType
	local v21 = Constants.LayoutSpecific[deviceLayout]
	local v22 = deviceLayout == Constants.DeviceLayout.DESKTOP
	local v23 = toggleSearchIcon and searchAreaActive
	local v24 = if iconType ~= BackButton.IconType.None then v21.BACK_BUTTON_MODAL_WIDTH else v21.BACK_BUTTON_WIDTH

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = size,
		AnchorPoint = Vector2.new(0, 1),
		LayoutOrder = layoutOrder,
		ZIndex = zIndex,
		Position = UDim2.new(0, 0, 0, 4)
	}, {
		Title = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Visible = not v23,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Text = v9:FormatByKey("Feature.SettingsHub.Heading.InviteFriends"),
			TextSize = Theme.textSize(v21.PAGE_TITLE_TEXT_SIZE),
			TextColor3 = Constants.Color.WHITE,
			Font = Theme.font(Enum.Font.SourceSansSemibold, "Semibold"),
			ZIndex = zIndex
		}),
		BackButton = Roact.createElement(BackButton, {
			visible = true,
			iconType = iconType,
			position = UDim2.new(0, 0, 0.5, 0),
			size = UDim2.new(0, v24 or v21.BACK_BUTTON_WIDTH, 0, v21.BACK_BUTTON_HEIGHT),
			anchorPoint = Vector2.new(0, 0.5),
			zIndex = zIndex,
			onClick = closePage
		}),
		SearchArea = Roact.createElement(SearchArea, {
			fullWidthSearchBar = toggleSearchIcon or not v22,
			searchBoxMargin = v21.SEARCH_BOX_MARGIN,
			anchorPoint = Vector2.new(1, 0.5),
			position = UDim2.new(1, 0, 0.5, 0),
			size = UDim2.new(1, -v24, 1, 0),
			zIndex = zIndex,
			analytics = analytics
		})
	})
end

return v10
