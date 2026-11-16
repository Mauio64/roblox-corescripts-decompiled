local AppStorageService = game:GetService("AppStorageService")

local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local localStorageKey = require("@luauforge/bundled/dCq").Enums.LocalStorageKey

local UIBlox = require(CorePackages.Packages.UIBlox)

local tokens = UIBlox.App.Style.Tokens

local module = require("@luauforge/bundled/hYd")
local module2 = require("@luauforge/bundled/fNP")

local extended = Roact.Component:extend("ThemeProvider")

local function fn(p2, foundationTokensDefaultScale)
	local clone = table.clone(p2)

	clone.ContextPrimaryButton.Color = foundationTokensDefaultScale.Color.ActionEmphasis.Background.Color3
	clone.ContextPrimaryButton.Transparency = foundationTokensDefaultScale.Color.ActionEmphasis.Background.Transparency
	clone.ContextPrimaryButton.Text.Color = foundationTokensDefaultScale.Color.ActionEmphasis.Foreground.Color3
	clone.ContextPrimaryButton.Text.Transparency = foundationTokensDefaultScale.Color.ActionEmphasis.Foreground.Transparency

	clone.SecondaryButton.Color = foundationTokensDefaultScale.Color.ActionSubtle.Background.Color3
	clone.SecondaryButton.Transparency = foundationTokensDefaultScale.Color.ActionSubtle.Background.Transparency
	clone.SecondaryButton.DisabledColor = foundationTokensDefaultScale.Color.ActionSubtle.Background.Color3
	clone.SecondaryButton.DisabledTransparency = 0.5
	clone.SecondaryButton.OnPressColor = foundationTokensDefaultScale.Color.ActionSubtle.Background.Color3
	clone.SecondaryButton.OnPressTransparency = 0.5
	clone.SecondaryButton.Text.Color = foundationTokensDefaultScale.Color.ActionSubtle.Foreground.Color3
	clone.SecondaryButton.Text.Transparency = foundationTokensDefaultScale.Color.ActionSubtle.Foreground.Transparency
	clone.SecondaryButton.Border.Color = foundationTokensDefaultScale.Color.ActionSubtle.Border.Color3
	clone.SecondaryButton.Border.Transparency = foundationTokensDefaultScale.Color.ActionSubtle.Border.Transparency

	clone.ShimmerPanel.Color = foundationTokensDefaultScale.Color.Common.Shimmer.Color3
	clone.ShimmerPanel.Transparency = foundationTokensDefaultScale.Color.Common.Shimmer.Transparency

	clone.AlertWindow.Background.Color = foundationTokensDefaultScale.Color.Surface.Surface_300.Color3
	clone.AlertWindow.Title.Color = foundationTokensDefaultScale.Color.Content.Emphasis.Color3
	clone.AlertWindow.Message.Color = foundationTokensDefaultScale.Color.Content.Default.Color3
	clone.AlertWindow.Divider.Color = foundationTokensDefaultScale.Color.Stroke.Default.Color3

	clone.GameDetails.GameInfoList.Cells.Background.Color = foundationTokensDefaultScale.Color.State.Press.Color3
	clone.GameDetails.GameInfoList.Cells.Background.Transparency.Pressed = foundationTokensDefaultScale.Color.State.Press.Transparency

	clone.GameMediaAccordion.Item.BackgroundColor = foundationTokensDefaultScale.Color.Surface.Surface_300.Color3
	clone.GameMediaAccordion.Item.BackgroundTransparency = 0.5
	clone.GameMediaAccordion.FakeItem.Loading.Color = foundationTokensDefaultScale.Color.Surface.Surface_300.Color3
	clone.GameMediaAccordion.FakeItem.Loading.BaseTransparency = 0.5
	clone.GameMediaAccordion.FakeItem.Loaded.Color = foundationTokensDefaultScale.Color.OverMedia.OverMedia_200.Color3
	clone.GameMediaAccordion.FakeItem.Loaded.BaseTransparency = foundationTokensDefaultScale.Color.OverMedia.OverMedia_200.Transparency
	clone.GameMediaAccordion.VideoIconColor = foundationTokensDefaultScale.Color.Content.Emphasis.Color3

	return clone
end

function extended:init(p3)
	local themeName = p3.themeName
	self.state = {
		theme = fn(module(themeName), tokens.getFoundationTokensDefaultScale(themeName))
	}
end

function extended:didMount()
	self.connection = AppStorageService.ItemWasSet:Connect(function(p2, p3)
		if p2 == localStorageKey.AuthenticatedTheme then
			self:setState({
				theme = fn(module(p3), tokens.getFoundationTokensDefaultScale(p3))
			})
		end
	end)
end

function extended.willUnmount(p2)
	if p2.connection then
		p2.connection:Disconnect()
	end
end

function extended.render(p2)
	return Roact.createElement(module2.Provider, { value = p2.state.theme }, p2.props[Roact.Children])
end

return extended
