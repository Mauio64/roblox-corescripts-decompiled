local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local useLocalization = dependencies.Localization.Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle

local function MaxAccountsReachedText() -- line: 10
	-- upvalues: useLocalization (copy), useStyle (copy), React (copy)
	local v8 = useLocalization({
		maxAccountsReachedText = "Authentication.AccountSwitch.Label.AccountLimitReached.2"
	})
	local v9 = useStyle()

	return React.createElement("TextLabel", {
		BackgroundTransparency = 1,
		TextWrapped = true,
		Text = v8.maxAccountsReachedText,
		TextSize = v9.Font.BaseSize,
		TextColor3 = v9.Theme.TextDefault.Color,
		TextTransparency = v9.Theme.TextDefault.Transparency,
		BackgroundColor3 = v9.Theme.BackgroundUIDefault.Color,
		Font = v9.Font.Body.Font,
		TextXAlignment = Enum.TextXAlignment.Center,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12)
		})
	})
end

return MaxAccountsReachedText
