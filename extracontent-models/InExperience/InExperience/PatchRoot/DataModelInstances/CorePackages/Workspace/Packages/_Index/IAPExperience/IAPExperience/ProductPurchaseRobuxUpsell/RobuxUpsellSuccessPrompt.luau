local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local RoactFitComponents = require(ParentParentParent.RoactFitComponents)
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local FitTextLabel = RoactFitComponents.FitTextLabel
local UIBlox = require(ParentParentParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local withStyle = UIBlox.Core.Style.withStyle
local MultiTextLocalizer = require(ParentParent.Locale.MultiTextLocalizer)
local ModelViewport = require(ParentParent.Generic.ModelViewport)
local v16 = Images["icons/status/imageunavailable"]
local v17 = Roact.Component:extend(script.Name)

v17.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function v17.init(p1) -- line: 48
	-- upvalues: Roact (copy)
	p1.contentRef = Roact.createRef()
	p1.state = {
		contentSize = Vector2.new(0, 0)
	}

	function p1.changeContentSize(p2) -- line: 54
		-- upvalues: p1 (copy)
		if p1.state.contentSize ~= p2.AbsoluteSize then
			p1:setState({
				contentSize = p2.AbsoluteSize
			})
		end
	end
end
function v17.render(p3) -- line: 63
	-- upvalues: Roact (copy), MultiTextLocalizer (copy)
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			PurchaseSucceededTitle = {
				key = "IAPExperience.PurchaseSuccess.Title.PurchaseSucceeded"
			},
			YouOwnText = {
				key = "IAPExperience.PurchaseSuccess.Text.YouOwn",
				params = {
					name = p3.props.itemName
				}
			},
			BalanceNow = {
				key = "IAPExperience.PurchaseSuccess.Text.BalanceNow"
			},
			BackToGameButtonText = {
				key = "IAPExperience.PurchaseSuccess.Action.BackToGame"
			},
			EquipText = {
				key = "IAPExperience.PurchaseSuccess.Action.Equip"
			},
			BackToShopText = {
				key = "IAPExperience.PurchaseSuccess.Action.BackToShop"
			}
		},
		render = function(t1: {[any]: any}) -- line: 88
			-- upvalues: p3 (copy)
			return p3:renderAlert(t1)
		end
	})
end
function v17.renderAlert(t2: {[any]: any}, t3: {[any]: any}) -- line: 94
	-- upvalues: withStyle (copy), ButtonType (copy), Roact (copy), ImageSetLabel (copy), IconSize (copy), v16 (copy), ModelViewport (copy), InteractiveAlert (copy), FitFrameVertical (copy), FitTextLabel (copy)
	local props = t2.props

	return withStyle(function(p4) -- line: 97
		-- upvalues: t3 (copy), props (copy), t2 (copy), ButtonType (copy), Roact (copy), ImageSetLabel (copy), IconSize (copy), v16 (copy), ModelViewport (copy), InteractiveAlert (copy), FitFrameVertical (copy), FitTextLabel (copy)
		local Theme = p4.Theme
		local p4Font = p4.Font
		local v28 = t3.YouOwnText .. " " .. t3.BalanceNow:gsub("{robux}", utf8.char(57346) .. tostring(props.balance))
		local v29 = if not t2.props.equipActivated then {
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = props.doneActivated,
					text = t3.BackToGameButtonText,
					inputIcon = props.confirmControllerIcon
				}
			}}
		} else {
			buttons = {
				{
					props = {
						onActivated = props.doneActivated,
						text = t3.BackToShopText,
						inputIcon = props.cancelControllerIcon
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = props.equipActivated,
						text = t3.EquipText,
						inputIcon = props.confirmControllerIcon
					}
				}
			}
		}
		local u30 = if not props.itemIcon then Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 5, 0, 5),
			Size = UDim2.new(0, IconSize.Large, 0, IconSize.Large),
			ScaleType = Enum.ScaleType.Stretch,
			Image = v16,
			ImageColor3 = Theme.UIDefault.Color,
			ImageTransparency = Theme.UIDefault.Transparency
		}) else Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			ImageTransparency = 0,
			Position = UDim2.new(0, 5, 0, 5),
			Size = UDim2.new(0, 85, 0, 85),
			ScaleType = Enum.ScaleType.Stretch,
			Image = props.itemIcon
		})

		if props.model then
			u30 = Roact.createElement(ModelViewport, {
				model = props.model,
				Position = UDim2.fromOffset(5, 5),
				Size = UDim2.fromOffset(85, 85)
			})
		end

		return Roact.createElement(InteractiveAlert, {
			screenSize = props.screenSize,
			position = props.position,
			anchorPoint = props.anchorPoint,
			title = t3.PurchaseSucceededTitle,
			middleContent = function() -- line: 175
				-- upvalues: Roact (copy), FitFrameVertical (copy), t2 (copy), u30 (ref), FitTextLabel (copy), p4Font (copy), v28 (copy), Theme (copy)
				return Roact.createElement(FitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 24),
					[Roact.Ref] = t2.contentRef,
					[Roact.Change.AbsoluteSize] = t2.changeContentSize
				}, {
					ItemIconFrame = Roact.createElement(FitFrameVertical, {
						LayoutOrder = 0,
						BackgroundTransparency = 1,
						width = UDim.new(1, 0),
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}, {
						ItemIcon = u30
					}),
					YouOwnText = Roact.createElement(FitTextLabel, {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						TextWrapped = true,
						width = FitTextLabel.Width.FitToText,
						maximumWidth = t2.state.contentSize.X,
						Font = p4Font.Body.Font,
						Text = v28,
						TextSize = p4Font.BaseSize * p4Font.Body.RelativeSize,
						TextColor3 = Theme.TextDefault.Color
					})
				})
			end,
			buttonStackInfo = v29
		})
	end)
end

return v17
