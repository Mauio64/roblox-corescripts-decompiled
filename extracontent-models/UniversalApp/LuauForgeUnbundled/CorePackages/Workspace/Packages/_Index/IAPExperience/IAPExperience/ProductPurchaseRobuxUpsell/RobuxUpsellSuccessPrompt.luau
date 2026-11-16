local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")

local FitFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/FitFrame")
local fitFrameVertical = FitFrame.FitFrameVertical
local fitTextLabel = FitFrame.FitTextLabel

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local iconSize = UIBlox.App.Constant.IconSize
local withStyle = UIBlox.Core.Style.withStyle

local MultiTextLocalizer = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/MultiTextLocalizer")
local ModelViewport = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/ModelViewport")

local iconsstatusimageunavailable = images["icons/status/imageunavailable"]

local extended = Roact.Component:extend("RobuxUpsellSuccessPrompt")

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function extended:init()
	self.contentRef = Roact.createRef()
	self.state = { contentSize = Vector2.new(0, 0) }

	function self.changeContentSize(p2)
		if self.state.contentSize ~= p2.AbsoluteSize then
			self:setState({ contentSize = p2.AbsoluteSize })
		end
	end
end

function extended:render()
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			PurchaseSucceededTitle = {
				key = "IAPExperience.PurchaseSuccess.Title.PurchaseSucceeded"
			},
			YouOwnText = {
				key = "IAPExperience.PurchaseSuccess.Text.YouOwn",
				params = { name = self.props.itemName }
			},
			BalanceNow = { key = "IAPExperience.PurchaseSuccess.Text.BalanceNow" },
			BackToGameButtonText = {
				key = "IAPExperience.PurchaseSuccess.Action.BackToGame"
			},
			EquipText = { key = "IAPExperience.PurchaseSuccess.Action.Equip" },
			BackToShopText = { key = "IAPExperience.PurchaseSuccess.Action.BackToShop" }
		},
		render = function(p2)
			return self:renderAlert(p2)
		end
	})
end

function extended:renderAlert(data2)
	local props = self.props

	return withStyle(function(p2)
		local theme = p2.Theme
		local font = p2.Font

		local v5 = data2.YouOwnText .. " " .. data2.BalanceNow:gsub(
			"{robux}",
			utf8.char(57346) .. tostring(props.balance)
		)
		local v6

		if self.props.equipActivated then
			v6 = {
				buttons = {
					{
						props = {
							onActivated = props.doneActivated,
							text = data2.BackToShopText,
							inputIcon = props.cancelControllerIcon
						}
					},
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							onActivated = props.equipActivated,
							text = data2.EquipText,
							inputIcon = props.confirmControllerIcon
						}
					}
				}
			}
		else
			v6 = {
				buttons = {
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							onActivated = props.doneActivated,
							text = data2.BackToGameButtonText,
							inputIcon = props.confirmControllerIcon
						}
					}
				}
			}
		end

		local v7

		if props.itemIcon then
			v7 = Roact.createElement(imageSetLabel, {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 5, 0, 5),
				Size = UDim2.new(0, 85, 0, 85),
				ScaleType = Enum.ScaleType.Stretch,
				Image = props.itemIcon,
				ImageTransparency = 0
			})
		else
			v7 = Roact.createElement(imageSetLabel, {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 5, 0, 5),
				Size = UDim2.new(0, iconSize.Large, 0, iconSize.Large),
				ScaleType = Enum.ScaleType.Stretch,
				Image = iconsstatusimageunavailable,
				ImageColor3 = theme.UIDefault.Color,
				ImageTransparency = theme.UIDefault.Transparency
			})
		end

		if props.model then
			v7 = Roact.createElement(ModelViewport, {
				model = props.model,
				Position = UDim2.fromOffset(5, 5),
				Size = UDim2.fromOffset(85, 85)
			})
		end

		return Roact.createElement(interactiveAlert, {
			screenSize = props.screenSize,
			position = props.position,
			anchorPoint = props.anchorPoint,
			title = data2.PurchaseSucceededTitle,
			middleContent = function()
				return Roact.createElement(fitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 24),
					[Roact.Ref] = self.contentRef,
					[Roact.Change.AbsoluteSize] = self.changeContentSize
				}, {
					ItemIconFrame = Roact.createElement(fitFrameVertical, {
						LayoutOrder = 0,
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}, { ItemIcon = v7 }),
					YouOwnText = Roact.createElement(fitTextLabel, {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						TextWrapped = true,
						width = fitTextLabel.Width.FitToText,
						maximumWidth = self.state.contentSize.X,
						Font = font.Body.Font,
						Text = v5,
						TextSize = font.BaseSize * font.Body.RelativeSize,
						TextColor3 = theme.TextDefault.Color
					})
				})
			end,
			buttonStackInfo = v6
		})
	end)
end

return extended
