local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withLocalization = require(Modules.LuaApp.withLocalization)
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local Foundation = require(CorePackages.Packages.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local withStyle = UIBlox.Style.withStyle
local v16 = Roact.PureComponent:extend("HomePageUpsellCard")

function v16.didMount(p1) -- line: 29
	p1.props.authEventAnalytics.reportModalShown("homepageUpsellCard", "homepage")
end
function v16.render(p2) -- line: 33
	-- upvalues: withStyle (copy), withLocalization (copy), FormFactor (copy), Text (copy), Roact (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy)
	return withStyle(function(p3) -- line: 34
		-- upvalues: p2 (copy), withLocalization (copy), FormFactor (copy), Text (copy), Roact (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy)
		local Theme = p3.Theme
		local TextEmphasisColor = Theme.TextEmphasis.Color
		local Header2Font = p3.Font.Header2.Font
		local v26 = p3.Font.BaseSize * p3.Font.Header2.RelativeSize
		local formFactor = p2.props.formFactor

		return withLocalization({
			addButtonText = "Feature.ContactMethodUpsell.Action.SecureYourAccount",
			addTitleText = "Feature.ContactMethodUpsell.Description.HomePageUpsellCardAddPhoneText"
		})(function(p4) -- line: 45
			-- upvalues: formFactor (copy), FormFactor (copy), Text (copy), p3 (copy), Roact (copy), Theme (copy), Header2Font (copy), TextEmphasisColor (copy), v26 (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy), p2 (copy)
			local uDim2 = UDim2.new(1, 0, 0, 0)
			local n1 = 12
			local Vertical = Enum.FillDirection.Vertical

			if formFactor == FormFactor.WIDE then
				n1 = 20
				Vertical = Enum.FillDirection.Horizontal
				uDim2 = UDim2.new(1, -Text.GetTextWidth(p4.addButtonText, p3.Font.CaptionHeader.Font, p3.Font.BaseSize * p3.Font.CaptionHeader.RelativeSize) - 30, 0, 0)
			end

			return Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 0,
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundColor3 = Theme.BackgroundUIDefault.Color,
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				UISizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(650, 1e999)
				}),
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, n1)
				}),
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 12)
				}),
				UIStroke = Roact.createElement("UIStroke", {
					Thickness = 1,
					Transparency = 0.7,
					Color = Theme.SystemPrimaryDefault.Color
				}),
				UIPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12),
					PaddingTop = UDim.new(0, 12),
					PaddingBottom = UDim.new(0, 12)
				}),
				TitleTextLabel = Roact.createElement("TextLabel", {
					LayoutOrder = 1,
					BorderSizePixel = 0,
					TextWrapped = true,
					BackgroundTransparency = 0,
					Size = uDim2,
					Font = Header2Font,
					Text = p4.addTitleText,
					TextColor3 = TextEmphasisColor,
					TextSize = v26,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundColor3 = Theme.BackgroundUIDefault.Color,
					AutomaticSize = Enum.AutomaticSize.Y
				}),
				CallToActionButton = Roact.createElement(Button, {
					LayoutOrder = 2,
					variant = ButtonVariant.SubEmphasis,
					size = ButtonSize.Medium,
					text = p4.addButtonText,
					onActivated = p2.props.buttonClickCallback,
					width = UDim.new(1, 0)
				})
			})
		end)
	end)
end

local v17 = RoactRodux.connect(function(p5, _) -- line: 121
	return {
		formFactor = p5.FormFactor
	}
end)(v16)

return (RoactServices.connect({
	authEventAnalytics = RoactAnalyticsAuthEvents
})(v17))
