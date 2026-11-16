local parent = script.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)

local RoactFitComponents = require(parent2.RoactFitComponents)
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local FitTextLabel = RoactFitComponents.FitTextLabel

local UIBlox = require(parent2.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local withStyle = UIBlox.Core.Style.withStyle

local MultiTextLocalizer = require(parent.Locale.MultiTextLocalizer)
local ModelViewport = require(parent.Generic.ModelViewport)

local iconsstatusimageunavailable = Images["icons/status/imageunavailable"]

local extended = Roact.Component:extend(script.Name)

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function extended:init()
	self.contentRef = Roact.createRef()
	self.state = { contentSize = Vector2.new(0, 0) }

	function self.changeContentSize(p)
		if self.state.contentSize ~= p.AbsoluteSize then
			self:setState({ contentSize = p.AbsoluteSize })
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
			BackToGameButtonText = { key = "IAPExperience.PurchaseSuccess.Action.BackToGame" },
			EquipText = { key = "IAPExperience.PurchaseSuccess.Action.Equip" },
			BackToShopText = { key = "IAPExperience.PurchaseSuccess.Action.BackToShop" }
		},
		render = function(p)
			return self:renderAlert(p)
		end
	})
end

function extended:renderAlert(data)
	local props = self.props

	return withStyle(function(p)
		local theme = p.Theme
		local font = p.Font

		local text = data.YouOwnText .. " " .. data.BalanceNow:gsub(
			"{robux}",
			utf8.char(57346) .. tostring(props.balance)
		)
		local buttonStackInfo

		if self.props.equipActivated then
			buttonStackInfo = {
				buttons = {
					{
						props = {
							onActivated = props.doneActivated,
							text = data.BackToShopText,
							inputIcon = props.cancelControllerIcon
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = props.equipActivated,
							text = data.EquipText,
							inputIcon = props.confirmControllerIcon
						}
					}
				}
			}
		else
			buttonStackInfo = {
				buttons = {
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = props.doneActivated,
							text = data.BackToGameButtonText,
							inputIcon = props.confirmControllerIcon
						}
					}
				}
			}
		end

		local itemIcon

		if props.itemIcon then
			itemIcon = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 5, 0, 5),
				Size = UDim2.new(0, 85, 0, 85),
				ScaleType = Enum.ScaleType.Stretch,
				Image = props.itemIcon,
				ImageTransparency = 0
			})
		else
			itemIcon = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 5, 0, 5),
				Size = UDim2.new(0, IconSize.Large, 0, IconSize.Large),
				ScaleType = Enum.ScaleType.Stretch,
				Image = iconsstatusimageunavailable,
				ImageColor3 = theme.UIDefault.Color,
				ImageTransparency = theme.UIDefault.Transparency
			})
		end

		if props.model then
			itemIcon = Roact.createElement(ModelViewport, {
				model = props.model,
				Position = UDim2.fromOffset(5, 5),
				Size = UDim2.fromOffset(85, 85)
			})
		end

		return Roact.createElement(InteractiveAlert, {
			screenSize = props.screenSize,
			position = props.position,
			anchorPoint = props.anchorPoint,
			title = data.PurchaseSucceededTitle,
			middleContent = function()
				return Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 24),
					[Roact.Ref] = self.contentRef,
					[Roact.Change.AbsoluteSize] = self.changeContentSize
				}, {
					ItemIconFrame = Roact.createElement(FitFrameVertical, {
						LayoutOrder = 0,
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}, { ItemIcon = itemIcon }),
					YouOwnText = Roact.createElement(FitTextLabel, {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						TextWrapped = true,
						width = FitTextLabel.Width.FitToText,
						maximumWidth = self.state.contentSize.X,
						Font = font.Body.Font,
						Text = text,
						TextSize = font.BaseSize * font.Body.RelativeSize,
						TextColor3 = theme.TextDefault.Color
					})
				})
			end,
			buttonStackInfo = buttonStackInfo
		})
	end)
end

return extended
