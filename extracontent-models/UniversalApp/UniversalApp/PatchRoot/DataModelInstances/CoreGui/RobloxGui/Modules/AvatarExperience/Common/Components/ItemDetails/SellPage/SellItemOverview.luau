local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local Modules = CoreGui.RobloxGui.Modules
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local ControlState = UIBlox.Core.Control.Enum.ControlState
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local GetFFlagEnableBankersRoundingOnResale = require(Modules.AvatarExperience.Flags.GetFFlagEnableBankersRoundingOnResale)
local v19 = Images["icons/common/robux"]
local v20 = Images["icons/actions/info_small"]

local function getRobloxCommissionAmount(n1: number, t1: {[any]: any}) -- line: 37
	-- upvalues: GetFFlagEnableBankersRoundingOnResale (copy), CatalogUtils (copy)
	if not n1 or n1 <= 0 then
		return 0, 0
	end

	local taxRate = t1.taxRate
	local minimumFee = t1.minimumFee

	if GetFFlagEnableBankersRoundingOnResale() then
		local v27 = CatalogUtils.bankersRounding(n1 * (1 - taxRate))
		local v28 = n1 - v27

		if v28 < minimumFee then
			return minimumFee, n1 - minimumFee
		end

		return v28, v27
	end

	return math.max(CatalogUtils.Round(taxRate * n1), minimumFee), 0
end
local function SellItemOverview(t2: {[any]: any}) -- line: 69
	-- upvalues: useLocalization (copy), useStyle (copy), GetFFlagEnableBankersRoundingOnResale (copy), getRobloxCommissionAmount (copy), CatalogUtils (copy), NumberLocalization (copy), LocalizationService (copy), useNavigation (copy), ControlState (copy), AvatarScreen (copy), React (copy), IconButton (copy), v20 (copy), IconSize (copy), ImageSetLabel (copy), v19 (copy)
	local v30 = useLocalization({
		overviewLabel = "Feature.Catalog.Heading.Overview",
		robloxFeeText = "Feature.Catalog.Label.Fee",
		sellCutText = "Feature.Catalog.Label.SellCut"
	})
	local v31 = useStyle()
	local Theme = v31.Theme
	local Font = v31.Font
	local SubHeader1 = Font.SubHeader1
	local Body = Font.Body
	local RelativeSize = SubHeader1.RelativeSize
	local RelativeSize2 = Body.RelativeSize
	local BaseSize = Font.BaseSize
	local v39 = RelativeSize * BaseSize
	local v40 = RelativeSize2 * BaseSize
	local v41 = t2.marketplaceFee.taxRate * 100
	local v42 = v30.robloxFeeText:gsub("({feePercentage})", v41)
	local num = tonumber(if not not t2.priceInRobux and t2.priceInRobux ~= "" then t2.priceInRobux else 0)
	local v44, v45

	if GetFFlagEnableBankersRoundingOnResale() then
		v44, v45 = getRobloxCommissionAmount(num, t2.marketplaceFee)
	else
		v44 = getRobloxCommissionAmount(num, t2.marketplaceFee)
		v45 = CatalogUtils.Round(num - v44)
	end

	local v46 = NumberLocalization.localize(v44, LocalizationService.RobloxLocaleId)
	local v47 = string.format("%.0f", v45)
	local v48 = NumberLocalization.localize(v47, LocalizationService.RobloxLocaleId)
	local v49 = useNavigation()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t2.layoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0)
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 10)
		}),
		OverviewFrameContainer = React.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			OverviewSubHeader = React.createElement("TextLabel", {
				LayoutOrder = 1,
				TextWrapped = true,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = v30.overviewLabel,
				Font = SubHeader1.Font,
				TextSize = v39,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency
			}),
			OverviewInfoButton = React.createElement(IconButton, {
				layoutOrder = 2,
				backgroundTransparency = 1,
				icon = v20,
				iconSize = IconSize.Small,
				onStateChanged = function(_, p2) -- line: 107
					-- upvalues: ControlState (copy), v49 (copy), AvatarScreen (copy), v41 (copy)
					if p2 == ControlState.Pressed or p2 == ControlState.SelectedPressed then
						v49.navigate(AvatarScreen.ResaleFeePolicyPrompt, {
							yourSharePercent = 100 - v41,
							robloxFeePercent = v41
						})
					end
				end,
				iconColor3 = Theme.IconEmphasis.Color,
				iconTransparency = Theme.IconEmphasis.Transparency
			})
		}),
		CommissionContainer = React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0)
		}, {
			CommissionLabel = React.createElement("TextLabel", {
				LayoutOrder = 1,
				TextWrapped = true,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = v42,
				Font = Body.Font,
				TextSize = v40,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = Theme.TextDefault.Color,
				TextTransparency = Theme.TextDefault.Transparency
			}),
			CommissionAmountContainer = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0)
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
					Text = "-",
					TextWrapped = true,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Font = Body.Font,
					TextSize = v40,
					TextXAlignment = Enum.TextXAlignment.Right,
					TextColor3 = Theme.TextDefault.Color,
					TextTransparency = Theme.TextDefault.Transparency
				}),
				CommissionRobuxImage = React.createElement(ImageSetLabel, {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Image = v19,
					Size = UDim2.fromOffset(v40, v40),
					ImageColor3 = Theme.TextDefault.Color,
					ImageTransparency = Theme.TextDefault.Transparency
				}),
				CommissionAmountText = React.createElement("TextLabel", {
					LayoutOrder = 3,
					TextWrapped = true,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = v46,
					Font = Body.Font,
					TextSize = v40,
					TextXAlignment = Enum.TextXAlignment.Right,
					TextColor3 = Theme.TextDefault.Color,
					TextTransparency = Theme.TextDefault.Transparency
				})
			})
		}),
		YouEarnContainer = React.createElement("Frame", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0)
		}, {
			YouEarnLabel = React.createElement("TextLabel", {
				LayoutOrder = 1,
				TextWrapped = true,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = v30.sellCutText,
				Font = Body.Font,
				TextSize = v40,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = Theme.TextDefault.Color,
				TextTransparency = Theme.TextDefault.Transparency
			}),
			YouEarnAmountRobuxContainer = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4)
				}),
				YouEarnRobuxImage = React.createElement(ImageSetLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Image = v19,
					Size = UDim2.fromOffset(v40, v40),
					ImageColor3 = Theme.TextDefault.Color,
					ImageTransparency = Theme.TextDefault.Transparency
				}),
				YouEarnAmountText = React.createElement("TextLabel", {
					LayoutOrder = 2,
					TextWrapped = true,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = v48,
					Font = Body.Font,
					TextSize = v40,
					TextXAlignment = Enum.TextXAlignment.Right,
					TextColor3 = Theme.TextDefault.Color,
					TextTransparency = Theme.TextDefault.Transparency
				})
			})
		})
	})
end

return SellItemOverview
