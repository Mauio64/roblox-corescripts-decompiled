local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(ShareGame.Constants)
local ShareGameIcons = require(ShareGame.Spritesheets.ShareGameIcons)
local Frame = ShareGameIcons:GetFrame("friends")
local ImagePath = ShareGameIcons:GetImagePath()
local Theme = require(RobloxGui.Modules.Settings.Theme)
local v10 = require(ShareGame.getTranslator)()
local v11 = Roact.PureComponent:extend("NoFriendsPage")

function v11.render(p1) -- line: 23
	-- upvalues: Roact (copy), ImagePath (copy), Frame (copy), v10 (copy), Constants (copy), Theme (copy)
	local propsLayoutOrder = p1.props.LayoutOrder
	local propsZIndex = p1.props.ZIndex
	local propsPosition = p1.props.Position
	local n1 = 0

	local function incrementLayoutOrder() -- line: 29
		-- upvalues: n1 (ref)
		n1 += 1

		return n1
	end

	local createElement = Roact.createElement
	local t1 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		LayoutOrder = propsLayoutOrder,
		ZIndex = propsZIndex,
		Position = propsPosition
	}
	local t2 = {
		listLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}
	local createElement2 = Roact.createElement
	local t3 = {
		BackgroundTransparency = 1,
		Image = ImagePath,
		ImageRectOffset = Frame.offset,
		ImageRectSize = Frame.size,
		Size = UDim2.new(0, 72, 0, 72)
	}

	n1 += 1
	t3.LayoutOrder = n1
	t3.ZIndex = propsZIndex
	t2.friendsIcon = createElement2("ImageLabel", t3)

	local createElement3 = Roact.createElement
	local t4 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0, 34)
	}

	n1 += 1
	t4.LayoutOrder = n1
	t4.ZIndex = propsZIndex
	t2.iconToSubtitleSpacer = createElement3("Frame", t4)

	local createElement4 = Roact.createElement
	local t5 = {
		BackgroundTransparency = 1,
		TextTransparency = 0.22,
		TextWrapped = true,
		Text = v10:FormatByKey("Feature.SettingsHub.Label.NoFriendsScreen"),
		TextColor3 = Constants.Color.GRAY5,
		TextSize = Theme.textSize(21),
		Font = Theme.font(Enum.Font.SourceSans)
	}

	n1 += 1
	t5.LayoutOrder = n1
	t5.Size = UDim2.new(0, 280, 0, 42)
	t5.TextYAlignment = Enum.TextYAlignment.Top
	t5.ZIndex = propsZIndex
	t2.subtitle = createElement4("TextLabel", t5)

	local createElement5 = Roact.createElement
	local t6 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0, 120)
	}

	n1 += 1
	t6.LayoutOrder = n1
	t6.ZIndex = propsZIndex
	t2.bottomSpacer = createElement5("Frame", t6)

	return createElement("Frame", t1, t2)
end

return v11
