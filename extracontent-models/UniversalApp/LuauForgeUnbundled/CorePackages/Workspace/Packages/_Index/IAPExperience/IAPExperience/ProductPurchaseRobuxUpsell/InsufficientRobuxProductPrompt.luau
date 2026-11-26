local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")

local fitFrameVertical = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/FitFrame").FitFrameVertical

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation").Utility.normalizeFontFace
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Core.Style.withStyle

local MultiTextLocalizer = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/MultiTextLocalizer")

local module4 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/ProductDetails")

local extended = Roact.Component:extend("InsufficientRobuxProductPrompt")

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function extended:init()
	self.contentRef = Roact.createRef()
	self.state = { contentSize = Vector2.new(0, 0), footerSize = Vector2.new(0, 0) }

	function self.changeContentSize(p2)
		if self.state.contentSize ~= p2.AbsoluteSize then
			self:setState({ contentSize = p2.AbsoluteSize })
		end
	end
end

function extended:render()
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			InsufficientRobuxTitle = {
				key = "IAPExperience.InsufficientRobux.Title.InsufficientRobux"
			},
			YouNeed = { key = "IAPExperience.InsufficientRobux.Text.YouNeed" },
			RobuxStore = { key = "IAPExperience.InsufficientRobux.Action.RobuxStore" },
			ButtonCancel = { key = "IAPExperience.InsufficientRobux.Action.Cancel" }
		},
		render = function(p2)
			return self:renderAlert(p2)
		end
	})
end

function extended:renderAlert(data2)
	local props = self.props

	return withStyle(function(props2)
		local theme = props2.Theme
		local font = props2.Font

		local color = Color3.new(
			math.round(theme.TextEmphasis.Color.R * 255),
			math.round(theme.TextEmphasis.Color.G * 255),
			(math.round(theme.TextEmphasis.Color.B * 255))
		)

		local v5 = props.itemRobuxCost - props.balanceAmount
		local v6 = string.format(
			"<font color=\"rgb(%s)\">%s%s</font>",
			tostring(color),
			utf8.char(57346),
			(tostring(v5))
		)

		local v7 = data2.YouNeed:gsub("{robux}", v6)

		return Roact.createElement(interactiveAlert, {
			screenSize = props.screenSize,
			position = props.position,
			anchorPoint = props.anchorPoint,
			title = data2.InsufficientRobuxTitle,
			middleContent = function()
				return Roact.createElement(fitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 15),
					[Roact.Ref] = self.contentRef,
					[Roact.Change.AbsoluteSize] = self.changeContentSize
				}, {
					ProductDetails = Roact.createElement(module4, {
						layoutOrder = 1,
						model = props.model,
						itemIcon = props.itemIcon,
						itemName = props.itemName,
						itemRobuxCost = props.itemRobuxCost
					}),
					Underline = Roact.createElement("Frame", {
						LayoutOrder = 2,
						BorderSizePixel = 0,
						BackgroundColor3 = theme.Divider.Color,
						BackgroundTransparency = theme.Divider.Transparency,
						Size = UDim2.new(1, 0, 0, 1)
					}),
					AdditionalBuyText = Roact.createElement("TextLabel", {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						Size = UDim2.new(0, self.state.contentSize.X, 0, 0),
						RichText = true,
						AutomaticSize = Enum.AutomaticSize.Y,
						TextWrapped = true,
						FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
						Text = v7,
						TextSize = font.BaseSize * font.Body.RelativeSize,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.Transparency
					})
				})
			end,
			buttonStackInfo = {
				buttons = {
					{
						props = {
							onActivated = props.cancelPurchaseActivated,
							text = data2.ButtonCancel,
							inputIcon = props.cancelControllerIcon
						}
					},
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							onActivated = props.robuxStoreActivated,
							text = data2.RobuxStore,
							inputIcon = props.acceptControllerIcon
						}
					}
				}
			}
		})
	end)
end

return extended
