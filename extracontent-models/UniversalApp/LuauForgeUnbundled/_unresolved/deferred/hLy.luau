local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local module = require("@luauforge/bundled/edC")
local t = require(CorePackages.Packages.t)

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local module2 = require("@luauforge/bundled/edO")
local module3 = require("@luauforge/bundled/edP")
local extended = Roact.PureComponent:extend("UserAgreementsSecondPrompt")

extended.validateProps = t.strictInterface({
	agreements = t.array(t.strictInterface({
		id = t.string,
		agreementType = t.string,
		clientType = t.string,
		displayUrl = t.string,
		regulationType = t.string
	})),
	agreementsListItems = t.table,
	screenSize = t.Vector2,
	showFirstPrompt = t.callback
})

function extended:init()
	function self.onAck()
		local agreements = self.props.agreements
		self.props.showFirstPrompt(agreements)
	end

	function self.renderMiddleContent(p3, p4)
		local theme = p4.Theme
		local font = p4.Font
		local agreementsListItems = self.props.agreementsListItems

		return Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
				Agreements = Roact.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Prefix = Roact.createElement(
						"Frame",
						{
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, 12)
						},
						{
							PrefixText = Roact.createElement("TextLabel", {
								Size = UDim2.new(1, 0, 1, 0),
								BackgroundTransparency = 1,
								Text = p3.bodyTextPart1,
								Font = font.CaptionHeader.Font,
								TextSize = font.BaseSize * font.CaptionHeader.RelativeSize,
								TextColor3 = theme.TextDefault.Color,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Center,
								TextWrapped = true
							}),
							Padding = Roact.createElement("UIPadding", {
								PaddingBottom = UDim.new(0, 12)
							})
						}
					),
					AgreementsList = Roact.createElement(
						"Frame",
						{
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							AutomaticSize = Enum.AutomaticSize.XY
						},
						agreementsListItems
					),
					Suffix = Roact.createElement(
						"Frame",
						{
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, 12)
						},
						{
							Padding = Roact.createElement("UIPadding", {
								PaddingTop = UDim.new(0, 12)
							}),
							PrefixText = Roact.createElement("TextLabel", {
								Size = UDim2.new(1, 0, 1, 0),
								BackgroundTransparency = 1,
								Text = p3.bodyTextPart2,
								Font = font.CaptionHeader.Font,
								TextSize = font.BaseSize * font.CaptionHeader.RelativeSize,
								TextColor3 = theme.TextDefault.Color,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Center,
								TextWrapped = true
							})
						}
					)
				})
			}
		)
	end
end

function extended.render(data)
	local screenSize = data.props.screenSize
	return withStyle(function(p2)
		return module({
			title = "Luobu.Authentication.UserAgreementsSecondPrompt.Title",
			bodyTextPart1 = "Luobu.Authentication.UserAgreementsSecondPrompt.BodyText.Part1",
			bodyTextPart2 = "Luobu.Authentication.UserAgreementsSecondPrompt.BodyText.Part2",
			buttonText = "Luobu.Authentication.UserAgreementsSecondPrompt.Button.Acknowledge"
		})(function(p3)
			return Roact.createElement(interactiveAlert, {
				title = p3.title,
				middleContent = function()
					return data.renderMiddleContent(p3, p2)
				end,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = buttonType.PrimarySystem,
							props = { onActivated = data.onAck, text = p3.buttonText }
						}
					}
				},
				position = UDim2.fromScale(0.5, 0.5),
				screenSize = screenSize
			})
		end)
	end)
end

return (RoactRodux.connect(function(p2)
	return { screenSize = p2.ScreenSize }
end, function(callback)
	return {
		showFirstPrompt = function(p2)
			callback(module3(module2.UserAgreementsPrompt, {
				agreements = p2,
				context = module2.UserAgreementsSecondPrompt
			}))
		end
	}
end)(extended))
