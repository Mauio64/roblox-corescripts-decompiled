local module = require("@luauforge/bundled/fPo")
local react = module.React
local uiBlox = module.UIBlox
local useLocalization = module.Localization.Hooks.useLocalization
local useStyle = uiBlox.Core.Style.useStyle

local function MaxAccountsReachedText()
	local v5 = useLocalization({
		maxAccountsReachedText = "Authentication.AccountSwitch.Label.AccountLimitReached.2"
	})

	local v6 = useStyle()
	return react.createElement("TextLabel", {
		Text = v5.maxAccountsReachedText,
		TextSize = v6.Font.BaseSize,
		TextColor3 = v6.Theme.TextDefault.Color,
		TextTransparency = v6.Theme.TextDefault.Transparency,
		BackgroundColor3 = v6.Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = 1,
		Font = v6.Font.Body.Font,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextWrapped = true,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIPadding = react.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12)
		})
	})
end

return MaxAccountsReachedText
