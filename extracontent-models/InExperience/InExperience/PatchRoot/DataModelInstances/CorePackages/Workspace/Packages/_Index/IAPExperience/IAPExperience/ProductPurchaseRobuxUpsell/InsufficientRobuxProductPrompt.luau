local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)

local RoactFitComponents = require(parent3.RoactFitComponents)
local FitFrameVertical = RoactFitComponents.FitFrameVertical

local UIBlox = require(parent3.UIBlox)
local Foundation = require(parent3.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Core.Style.withStyle

local MultiTextLocalizer = require(parent2.Locale.MultiTextLocalizer)

local ProductDetails = require(parent.ProductDetails)

local extended = Roact.Component:extend(script.Name)

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function extended:init()
	self.contentRef = Roact.createRef()
	self.state = { contentSize = Vector2.new(0, 0), footerSize = Vector2.new(0, 0) }

	function self.changeContentSize(p)
		if self.state.contentSize ~= p.AbsoluteSize then
			self:setState({ contentSize = p.AbsoluteSize })
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
		render = function(p)
			return self:renderAlert(p)
		end
	})
end

function extended:renderAlert(data)
	local props = self.props

	return withStyle(function(props2)
		local theme = props2.Theme
		local font = props2.Font

		local color = Color3.new(
			math.round(theme.TextEmphasis.Color.R * 255),
			math.round(theme.TextEmphasis.Color.G * 255),
			(math.round(theme.TextEmphasis.Color.B * 255))
		)

		local v = props.itemRobuxCost - props.balanceAmount
		local v2 = string.format(
			"<font color=\"rgb(%s)\">%s%s</font>",
			tostring(color),
			utf8.char(57346),
			(tostring(v))
		)

		local text = data.YouNeed:gsub("{robux}", v2)

		return Roact.createElement(InteractiveAlert, {
			screenSize = props.screenSize,
			position = props.position,
			anchorPoint = props.anchorPoint,
			title = data.InsufficientRobuxTitle,
			middleContent = function()
				local createElement = Roact.createElement
				local v3 = {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					contentPadding = UDim.new(0, 15),
					[Roact.Ref] = self.contentRef,
					[Roact.Change.AbsoluteSize] = self.changeContentSize
				}
				local v4 = {
					ProductDetails = Roact.createElement(ProductDetails, {
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
					AdditionalBuyText = 0
				}

				local createElement2 = Roact.createElement
				local v5 = {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, self.state.contentSize.X, 0, 0),
					RichText = true,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextWrapped = true,
					Font = 0,
					FontFace = 0,
					Text = 0,
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0
				}
				local font2

				if not FoundationFontFaceMigration then
					font2 = font.Body.Font
				end

				v5.Font = font2
				local fontFace

				if FoundationFontFaceMigration then
					fontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font)
				end

				v5.FontFace = fontFace

				v5.Text = text
				v5.TextSize = font.BaseSize * font.Body.RelativeSize
				v5.TextColor3 = theme.TextDefault.Color
				v5.TextTransparency = theme.TextDefault.Transparency
				v4.AdditionalBuyText = createElement2("TextLabel", v5)
				return createElement(FitFrameVertical, v3, v4)
			end,
			buttonStackInfo = {
				buttons = {
					{
						props = {
							onActivated = props.cancelPurchaseActivated,
							text = data.ButtonCancel,
							inputIcon = props.cancelControllerIcon
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = props.robuxStoreActivated,
							text = data.RobuxStore,
							inputIcon = props.acceptControllerIcon
						}
					}
				}
			}
		})
	end)
end

return extended
