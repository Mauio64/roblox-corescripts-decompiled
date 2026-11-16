local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local parent = FriendsLanding.Parent

local dependencies = require(FriendsLanding.dependencies)
local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local withLocalization = dependencies.withLocalization
local button = uiBlox.App.Button.Button
local buttonType = uiBlox.App.Button.Enum.ButtonType

local Cryo = require(parent.Cryo)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens

local extended = roact.PureComponent:extend("ShowMoreButton")

local function fn() end

extended.defaultProps = { layoutOrder = 1, onSizeChange = fn, onActivated = fn, buttonHeight = 48 }

extended.MAX_WIDTH = 640

function extended:init()
	self.state = { width = 100 }

	self.localization = { showMore = "Feature.Friends.Action.ShowMore" }

	function self.onChangeSize(p)
		self:setState({
			width = math.min(self.props.maxWidth or extended.MAX_WIDTH, p.AbsoluteSize.X)
		})

		self.props.onSizeChange(p)
	end
end

function extended.render(data)
	return withLocalization(data.localization)(function(p)
		local buttonHeight = data.props.buttonHeight
		local udim = UDim2.new(0, data.state.width, 0, buttonHeight)

		return roact.createFragment({
			showMoreContainer = roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = data.props.layoutOrder,
				Size = UDim2.new(1, 0, 0, buttonHeight + 48),
				[roact.Change.AbsoluteSize] = data.onChangeSize
			}, {
				layout = roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				showMore = roact.createElement(button, {
					buttonType = buttonType.Secondary,
					onActivated = data.props.onActivated,
					size = udim,
					text = p.showMore
				})
			})
		})
	end)
end

local function ShowMoreButtonWrapper(p)
	local v = useDesignTokens()

	return roact.createElement(
		extended,
		Cryo.Dictionary.join(
			{
				maxWidth = v.LuaApps.FriendsLanding.ShowMore.ButtonWidth,
				buttonHeight = v.LuaApps.FriendsLanding.ShowMore.ButtonHeight
			},
			p
		)
	)
end

return ShowMoreButtonWrapper
