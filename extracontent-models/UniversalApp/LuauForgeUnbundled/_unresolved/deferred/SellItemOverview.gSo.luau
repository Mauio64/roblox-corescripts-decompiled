local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation

local module = require("@luauforge/bundled/dVl")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module2 = require("@luauforge/bundled/gxM")

local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local images = UIBlox.App.ImageSet.Images
local controlState = UIBlox.Core.Control.Enum.ControlState
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle

local module3 = require("@luauforge/deferred/gSp")

local iconscommonrobux = images["icons/common/robux"]
local iconsactionsinfo_small = images["icons/actions/info_small"]

local function getRobloxCommissionAmount(p2, marketplaceFee)
	if not p2 or p2 <= 0 then
		return 0, 0
	end

	local taxRate = marketplaceFee.taxRate
	local minimumFee = marketplaceFee.minimumFee

	if not module3() then
		return math.max(module.Round(taxRate * p2), minimumFee), 0
	end

	local bankersRounding = module.bankersRounding(p2 * (1 - taxRate))
	local v5 = p2 - bankersRounding

	if v5 < minimumFee then
		return minimumFee, p2 - minimumFee
	end

	return v5, bankersRounding
end

local function SellItemOverview(props)
	local v5 = module2({
		overviewLabel = "Feature.Catalog.Heading.Overview",
		robloxFeeText = "Feature.Catalog.Label.Fee",
		sellCutText = "Feature.Catalog.Label.SellCut"
	})

	local v6 = useStyle()

	local theme = v6.Theme
	local font = v6.Font
	local subHeader1 = font.SubHeader1
	local body = font.Body
	local relativeSize = subHeader1.RelativeSize
	local relativeSize2 = body.RelativeSize
	local baseSize = font.BaseSize

	local v7 = relativeSize * baseSize
	local v8 = relativeSize2 * baseSize

	local v9 = props.marketplaceFee.taxRate * 100
	local v10 = v5.robloxFeeText:gsub("({feePercentage})", v9)

	local v11 = tonumber((not props.priceInRobux or props.priceInRobux == "") and 0 or props.priceInRobux)
	local v12, v13

	if module3() then
		v12, v13 = getRobloxCommissionAmount(v11, props.marketplaceFee)
	else
		v12 = getRobloxCommissionAmount(v11, props.marketplaceFee)
		v13 = module.Round(v11 - v12)
	end

	local localize = numberLocalization.localize(v12, LocalizationService.RobloxLocaleId)
	local v14 = string.format("%.0f", v13)
	local localize2 = numberLocalization.localize(v14, LocalizationService.RobloxLocaleId)

	local v15 = useNavigation()

	local function onStateChanged(p2, p3)
		if p3 == controlState.Pressed or p3 == controlState.SelectedPressed then
			v15.navigate(avatarScreen.ResaleFeePolicyPrompt, {
				yourSharePercent = 100 - v9,
				robloxFeePercent = v9
			})
		end
	end

	return React.createElement(
		"Frame",
		{
			LayoutOrder = props.layoutOrder,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1
		},
		{
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			}),
			OverviewFrameContainer = React.createElement(
				"Frame",
				{
					LayoutOrder = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(1, 0),
					BackgroundTransparency = 1
				},
				{
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					}),
					OverviewSubHeader = React.createElement("TextLabel", {
						LayoutOrder = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						Text = v5.overviewLabel,
						FontFace = normalizeFontFace(v6.Tokens.Typography.TitleLarge.Font),
						TextSize = v7,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = theme.TextEmphasis.Color,
						TextTransparency = theme.TextEmphasis.Transparency,
						TextWrapped = true,
						BackgroundTransparency = 1
					}),
					OverviewInfoButton = React.createElement(iconButton, {
						layoutOrder = 2,
						icon = iconsactionsinfo_small,
						iconSize = iconSize.Small,
						onStateChanged = onStateChanged,
						iconColor3 = theme.IconEmphasis.Color,
						iconTransparency = theme.IconEmphasis.Transparency,
						backgroundTransparency = 1
					})
				}
			),
			CommissionContainer = React.createElement(
				"Frame",
				{
					LayoutOrder = 2,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(1, 0),
					BackgroundTransparency = 1
				},
				{
					CommissionLabel = React.createElement("TextLabel", {
						LayoutOrder = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						Text = v10,
						FontFace = normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font),
						TextSize = v8,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.Transparency,
						TextWrapped = true,
						BackgroundTransparency = 1
					}),
					CommissionAmountContainer = React.createElement("Frame", {
						LayoutOrder = 2,
						AutomaticSize = Enum.AutomaticSize.XY,
						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1
					}, {
						UIListLayout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Right,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 4)
						}),
						CommissionMinusText = React.createElement("TextLabel", {
							LayoutOrder = 1,
							AutomaticSize = Enum.AutomaticSize.XY,
							Text = "-",
							FontFace = normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font),
							TextSize = v8,
							TextXAlignment = Enum.TextXAlignment.Right,
							TextColor3 = theme.TextDefault.Color,
							TextTransparency = theme.TextDefault.Transparency,
							TextWrapped = true,
							BackgroundTransparency = 1
						}),
						CommissionRobuxImage = React.createElement(imageSetLabel, {
							LayoutOrder = 2,
							AutomaticSize = Enum.AutomaticSize.XY,
							Image = iconscommonrobux,
							Size = UDim2.fromOffset(v8, v8),
							ImageColor3 = theme.TextDefault.Color,
							ImageTransparency = theme.TextDefault.Transparency,
							BackgroundTransparency = 1
						}),
						CommissionAmountText = React.createElement("TextLabel", {
							LayoutOrder = 3,
							AutomaticSize = Enum.AutomaticSize.XY,
							Text = localize,
							FontFace = normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font),
							TextSize = v8,
							TextXAlignment = Enum.TextXAlignment.Right,
							TextColor3 = theme.TextDefault.Color,
							TextTransparency = theme.TextDefault.Transparency,
							TextWrapped = true,
							BackgroundTransparency = 1
						})
					})
				}
			),
			YouEarnContainer = React.createElement(
				"Frame",
				{
					LayoutOrder = 3,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(1, 0),
					BackgroundTransparency = 1
				},
				{
					YouEarnLabel = React.createElement("TextLabel", {
						LayoutOrder = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						Text = v5.sellCutText,
						FontFace = normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font),
						TextSize = v8,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.Transparency,
						TextWrapped = true,
						BackgroundTransparency = 1
					}),
					YouEarnAmountRobuxContainer = React.createElement("Frame", {
						LayoutOrder = 2,
						AutomaticSize = Enum.AutomaticSize.XY,
						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1
					}, {
						UIListLayout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Right,
							VerticalAlignment = Enum.VerticalAlignment.Top,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 4)
						}),
						YouEarnRobuxImage = React.createElement(imageSetLabel, {
							LayoutOrder = 1,
							AutomaticSize = Enum.AutomaticSize.XY,
							Image = iconscommonrobux,
							Size = UDim2.fromOffset(v8, v8),
							ImageColor3 = theme.TextDefault.Color,
							ImageTransparency = theme.TextDefault.Transparency,
							BackgroundTransparency = 1
						}),
						YouEarnAmountText = React.createElement("TextLabel", {
							LayoutOrder = 2,
							AutomaticSize = Enum.AutomaticSize.XY,
							Text = localize2,
							FontFace = normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font),
							TextSize = v8,
							TextXAlignment = Enum.TextXAlignment.Right,
							TextColor3 = theme.TextDefault.Color,
							TextTransparency = theme.TextDefault.Transparency,
							TextWrapped = true,
							BackgroundTransparency = 1
						})
					})
				}
			)
		}
	)
end

return SellItemOverview
