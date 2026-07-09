local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local Modules = CoreGui.RobloxGui.Modules
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local v12 = Images["icons/common/robux"]

local function SellItemInfo(t1: {[any]: any}) -- line: 34
	-- upvalues: useLocalization (copy), useStyle (copy), NumberLocalization (copy), LocalizationService (copy), React (copy), ImageSetLabel (copy), v12 (copy)
	local v15 = useLocalization({
		itemInfoLabel = "Feature.Catalog.Heading.ItemInfo",
		serialNumberLabel = "Feature.Catalog.Label.SerialNumberColon",
		averagePriceLabel = "Feature.Catalog.Label.AveragePriceColon"
	})
	local v16 = useStyle()
	local averagePrice = t1.itemIdPriceSerialNumber.averagePrice
	local Theme = v16.Theme
	local Font = v16.Font
	local SubHeader1 = Font.SubHeader1
	local Body = Font.Body
	local RelativeSize = SubHeader1.RelativeSize
	local RelativeSize2 = Body.RelativeSize
	local BaseSize = Font.BaseSize
	local v25 = RelativeSize * BaseSize
	local v26 = RelativeSize2 * BaseSize
	local v27 = averagePrice and NumberLocalization.localize(averagePrice, LocalizationService.RobloxLocaleId) or ""
	local v28 = if not t1.itemIdPriceSerialNumber.serialNumber then nil else t1.itemIdPriceSerialNumber.serialNumber

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
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
		ItemInfoSubHeader = React.createElement("TextLabel", {
			LayoutOrder = 1,
			TextWrapped = true,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = v15.itemInfoLabel,
			Font = SubHeader1.Font,
			Size = UDim2.fromScale(1, 0),
			TextSize = v25,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Theme.TextEmphasis.Color,
			TextTransparency = Theme.TextEmphasis.Transparency
		}),
		SerialNumberContainer = v28 and React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			}),
			SerialNumberLabel = React.createElement("TextLabel", {
				LayoutOrder = 1,
				TextWrapped = true,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = v15.serialNumberLabel,
				Font = Body.Font,
				TextSize = v26,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = Theme.TextDefault.Color,
				TextTransparency = Theme.TextDefault.Transparency
			}),
			SerialNumberText = React.createElement("TextLabel", {
				LayoutOrder = 2,
				TextWrapped = true,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = v28,
				Font = Body.Font,
				TextSize = v26,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = Theme.TextDefault.Color,
				TextTransparency = Theme.TextDefault.Transparency
			})
		}),
		AveragePriceContainer = React.createElement("Frame", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			}),
			AveragePriceLabel = React.createElement("TextLabel", {
				LayoutOrder = 1,
				TextWrapped = true,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = v15.averagePriceLabel,
				Font = Body.Font,
				TextSize = v26,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = Theme.TextDefault.Color,
				TextTransparency = Theme.TextDefault.Transparency
			}),
			AveragePriceTextContainer = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4)
				}),
				AveragePriceRobuxImage = React.createElement(ImageSetLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Image = v12,
					Size = UDim2.fromOffset(v26, v26),
					ImageColor3 = Theme.TextDefault.Color,
					ImageTransparency = Theme.TextDefault.Transparency
				}),
				AveragePriceText = React.createElement("TextLabel", {
					LayoutOrder = 2,
					TextWrapped = true,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = v27,
					Font = Body.Font,
					TextSize = v26,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextColor3 = Theme.TextDefault.Color,
					TextTransparency = Theme.TextDefault.Transparency
				})
			})
		})
	})
end

return SellItemInfo
