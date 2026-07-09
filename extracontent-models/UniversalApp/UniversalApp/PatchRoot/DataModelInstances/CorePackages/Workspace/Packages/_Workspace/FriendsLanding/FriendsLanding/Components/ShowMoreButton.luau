local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsLandingParent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local withLocalization = dependencies.withLocalization
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Cryo = require(FriendsLandingParent.Cryo)
local useDesignTokens = require(FriendsLandingParent.Style).useDesignTokens
local v11 = Roact.PureComponent:extend("ShowMoreButton")

local function v12() -- line: 18
end

v11.defaultProps = {
	layoutOrder = 1,
	buttonHeight = 48,
	onSizeChange = v12,
	onActivated = v12
}
v11.MAX_WIDTH = 640

function v11.init(p1) -- line: 30
	-- upvalues: v11 (copy)
	p1.state = {
		width = 100
	}
	p1.localization = {
		showMore = "Feature.Friends.Action.ShowMore"
	}

	function p1.onChangeSize(p2) -- line: 39
		-- upvalues: p1 (copy), v11 (copy)
		local v19 = p1.props.maxWidth or v11.MAX_WIDTH

		p1:setState({
			width = math.min(v19, p2.AbsoluteSize.X)
		})
		p1.props.onSizeChange(p2)
	end
end
function v11.render(p3) -- line: 49
	-- upvalues: withLocalization (copy), Roact (copy), Button (copy), ButtonType (copy)
	return withLocalization(p3.localization)(function(p4) -- line: 50
		-- upvalues: p3 (copy), Roact (copy), Button (copy), ButtonType (copy)
		local buttonHeight = p3.props.buttonHeight
		local uDim2 = UDim2.new(0, p3.state.width, 0, buttonHeight)

		return Roact.createFragment({
			showMoreContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = p3.props.layoutOrder,
				Size = UDim2.new(1, 0, 0, buttonHeight + 48),
				[Roact.Change.AbsoluteSize] = p3.onChangeSize
			}, {
				layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				showMore = Roact.createElement(Button, {
					buttonType = ButtonType.Secondary,
					onActivated = p3.props.onActivated,
					size = uDim2,
					text = p4.showMore
				})
			})
		})
	end)
end

local function ShowMoreButtonWrapper(p5) -- line: 78
	-- upvalues: useDesignTokens (copy), Roact (copy), v11 (copy), Cryo (copy)
	local v17 = useDesignTokens()

	return Roact.createElement(v11, Cryo.Dictionary.join({
		maxWidth = v17.LuaApps.FriendsLanding.ShowMore.ButtonWidth,
		buttonHeight = v17.LuaApps.FriendsLanding.ShowMore.ButtonHeight
	}, p5))
end

return ShowMoreButtonWrapper
