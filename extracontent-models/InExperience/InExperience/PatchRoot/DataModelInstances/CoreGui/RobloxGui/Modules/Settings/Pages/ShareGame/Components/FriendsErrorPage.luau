local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(ShareGame.Constants)
local Theme = require(RobloxGui.Modules.Settings.Theme)
local v7 = require(ShareGame.getTranslator)()
local v8 = Roact.PureComponent:extend("FriendsErrorPage")

function v8.render(p1) -- line: 17
	-- upvalues: Roact (copy), v7 (copy), Constants (copy), Theme (copy)
	local propsLayoutOrder = p1.props.LayoutOrder
	local propsZIndex = p1.props.ZIndex
	local n1 = 0

	local function incrementLayoutOrder() -- line: 22
		-- upvalues: n1 (ref)
		n1 += 1

		return n1
	end

	local createElement = Roact.createElement
	local t1 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		LayoutOrder = propsLayoutOrder,
		ZIndex = propsZIndex
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
		TextTransparency = 0.22,
		TextWrapped = true,
		Text = v7:FormatByKey("Feature.SettingsHub.Label.LoadingFriendsListFailed"),
		TextColor3 = Constants.Color.GRAY5,
		TextSize = Theme.textSize(21),
		Font = Theme.font(Enum.Font.SourceSans)
	}

	n1 += 1
	t3.LayoutOrder = n1
	t3.Size = UDim2.new(0, 280, 0, 42)
	t3.TextYAlignment = Enum.TextYAlignment.Top
	t3.ZIndex = propsZIndex
	t2.subtitle = createElement2("TextLabel", t3)

	return createElement("Frame", t1, t2)
end

return v8
