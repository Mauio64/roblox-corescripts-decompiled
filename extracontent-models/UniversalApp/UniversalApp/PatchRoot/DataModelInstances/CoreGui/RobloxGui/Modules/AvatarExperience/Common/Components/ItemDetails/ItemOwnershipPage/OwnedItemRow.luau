local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local ItemTile = UIBlox.Tile.ItemTile
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local Modules = CoreGui.RobloxGui.Modules
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local getRbxthumbWithTypeSizeAndOptions = require(CorePackages.Workspace.Packages.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions
local GetFFlagL2ControllerSupport = require(Modules.AvatarExperience.Flags.GetFFlagL2ControllerSupport)
local FFlagAXThumbTypeNilCheck = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXThumbTypeNilCheck

require(Modules.AvatarExperience.Common.Types)

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 49
	-- upvalues: CatalogUtils (copy), FFlagAXThumbTypeNilCheck (copy), getRbxthumbWithTypeSizeAndOptions (copy), useLocalization (copy), useStyle (copy), useRoactService (copy), RoactLocalization (copy), NumberLocalization (copy), React (copy), ItemTile (copy), CatalogConstants (copy), GetFFlagL2ControllerSupport (copy), Button (copy), ButtonType (copy), Focusable (copy)
	local itemType = t1.itemType
	local v23 = CatalogUtils.GetRbxThumbType(itemType)
	local v24 = if not FFlagAXThumbTypeNilCheck or not v23 then getRbxthumbWithTypeSizeAndOptions(t1.itemId, v23, 150) else getRbxthumbWithTypeSizeAndOptions(t1.itemId, v23, 150)
	local v25 = useLocalization({
		holdingLabel = "Feature.Catalog.Label.Holding",
		offSaleLabel = "Feature.Catalog.Heading.TakeOffSale",
		sellAction = "Feature.Catalog.Action.Sell",
		buyPriceLabel = "Feature.Catalog.Label.BuyPrice",
		salePriceLabel = "Feature.Catalog.Label.SalePrice"
	})
	local v26 = useStyle()
	local v27 = useRoactService(RoactLocalization)
	local v28 = t1.buyPrice and string.format("%.0f", t1.buyPrice)
	local v29 = v28 and NumberLocalization.localize(v28, v27:GetLocale())
	local v30 = t1.salePrice and string.format("%.0f", t1.salePrice)
	local v31 = v30 and NumberLocalization.localize(v30, v27:GetLocale())
	local v32 = if not t1.isOnHold then if not t1.isOnSale then v25.sellAction else v25.offSaleLabel else v25.holdingLabel

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 100),
		LayoutOrder = t1.layoutOrder
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8)
		}),
		ItemTileContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(100, 100)
		}, {
			ItemTile = React.createElement(ItemTile, {
				name = "",
				thumbnail = v24,
				restrictionTypes = t1.restrictionTypes
			})
		}),
		DetailsContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, -108, 1, 0)
		}, {
			LabelsContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0)
			}, {
				Layout = React.createElement("UIListLayout", {
					Padding = UDim.new(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				ItemTitleLabel = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(1, 0),
					Text = t1.title,
					Font = v26.Font.Header2.Font,
					TextSize = v26.Font.BaseSize * v26.Font.Header2.RelativeSize,
					TextColor3 = v26.Theme.TextEmphasis.Color,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				BuyPriceLabel = v29 and React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = v25.buyPriceLabel .. " " .. CatalogConstants.RobloxEmoji.Robux .. v29,
					Font = v26.Font.Body.Font,
					TextSize = v26.Font.BaseSize * v26.Font.Body.RelativeSize,
					TextColor3 = v26.Theme.TextEmphasis.Color
				}),
				SalePriceLabel = v31 and React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = v25.salePriceLabel .. " " .. CatalogConstants.RobloxEmoji.Robux .. v31,
					Font = v26.Font.Body.Font,
					TextSize = v26.Font.BaseSize * v26.Font.Body.RelativeSize,
					TextColor3 = v26.Theme.TextEmphasis.Color
				})
			}),
			Button = t1.resaleRestriction ~= CatalogConstants.ResaleRestriction.Disabled and (not GetFFlagL2ControllerSupport() and React.createElement(Button, {
				layoutOrder = 2,
				buttonType = if not t1.isOnSale then ButtonType.PrimarySystem else ButtonType.Secondary,
				size = UDim2.new(1, 0, 0, 28),
				text = v32,
				position = UDim2.fromScale(0, 1),
				anchorPoint = Vector2.new(0, 1),
				onActivated = t1.onActivated,
				isDisabled = t1.isOnHold
			})),
			ButtonContainer = t1.resaleRestriction ~= CatalogConstants.ResaleRestriction.Disabled and (GetFFlagL2ControllerSupport() and React.createElement(Focusable.Frame, {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 28),
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1),
				NextSelectionUp = if not GetFFlagL2ControllerSupport() then nil else t1.NextSelectionUp,
				NextSelectionDown = if not GetFFlagL2ControllerSupport() then nil else t1.NextSelectionDown,
				ref = if not GetFFlagL2ControllerSupport() then nil else p1
			}, {
				OnSaleButton = t1.isOnSale and React.createElement(Button, {
					buttonType = ButtonType.Secondary,
					size = UDim2.fromScale(1, 1),
					text = v32,
					onActivated = t1.onActivated,
					isDisabled = t1.isOnHold
				}),
				OffSaleButton = not t1.isOnSale and React.createElement(Button, {
					buttonType = ButtonType.PrimarySystem,
					size = UDim2.fromScale(1, 1),
					text = v32,
					onActivated = t1.onActivated,
					isDisabled = t1.isOnHold
				})
			}))
		})
	})
end))
