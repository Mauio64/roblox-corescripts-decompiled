local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Packages.Roact)

local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local Theme = require(RobloxGui.Modules.Settings.Theme)
local Constants = require(ShareGame.Constants)
local BackButton = require(ShareGame.Components.BackButton)
local SearchArea = require(ShareGame.Components.SearchArea)

local getTranslator = require(ShareGame.getTranslator)
local translator = getTranslator()

local extended = Roact.PureComponent:extend("Header")

function extended.render(p)
	local deviceLayout = p.props.deviceLayout
	local size = p.props.size
	local layoutOrder = p.props.layoutOrder
	local zIndex = p.props.zIndex
	local closePage = p.props.closePage
	local searchAreaActive = p.props.searchAreaActive
	local analytics = p.props.analytics

	local toggleSearchIcon = p.props.toggleSearchIcon
	local iconType = p.props.iconType

	local v = Constants.LayoutSpecific[deviceLayout]
	local v2 = deviceLayout == Constants.DeviceLayout.DESKTOP
	local v3

	if iconType == BackButton.IconType.None then
		v3 = v.BACK_BUTTON_WIDTH
	else
		v3 = v.BACK_BUTTON_MODAL_WIDTH
	end

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
			Visible = not (toggleSearchIcon and searchAreaActive),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Text = translator:FormatByKey("Feature.SettingsHub.Heading.InviteFriends"),
			TextSize = Theme.textSize(v.PAGE_TITLE_TEXT_SIZE),
			TextColor3 = Constants.Color.WHITE,
			Font = Theme.font(Enum.Font.SourceSansSemibold, "Semibold"),
			ZIndex = zIndex
		}),
		BackButton = Roact.createElement(BackButton, {
			visible = true,
			iconType = iconType,
			position = UDim2.new(0, 0, 0.5, 0),
			size = UDim2.new(0, v3 or v.BACK_BUTTON_WIDTH, 0, v.BACK_BUTTON_HEIGHT),
			anchorPoint = Vector2.new(0, 0.5),
			zIndex = zIndex,
			onClick = closePage
		}),
		SearchArea = Roact.createElement(SearchArea, {
			fullWidthSearchBar = toggleSearchIcon or not v2,
			searchBoxMargin = v.SEARCH_BOX_MARGIN,
			anchorPoint = Vector2.new(1, 0.5),
			position = UDim2.new(1, 0, 0.5, 0),
			size = UDim2.new(1, -v3, 1, 0),
			zIndex = zIndex,
			analytics = analytics
		})
	})
end

return extended
