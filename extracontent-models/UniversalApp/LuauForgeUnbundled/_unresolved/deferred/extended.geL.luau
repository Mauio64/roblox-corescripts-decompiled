local CorePackages = game:GetService("CorePackages")
local dateTime = require("@luauforge/bundled/geM").DateTime

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/egF")
local module2 = require("@luauforge/bundled/egM")

local module3 = require("@luauforge/bundled/egZ")
local withStyle = UIBlox.Style.withStyle

local module4 = require("@luauforge/deferred/geB")
local module5 = require("@luauforge/deferred/geG")

local extended = Roact.PureComponent:extend("DevSubListItem")

local v5 = { TOP = 15, LEFT = 24, RIGHT = 25 }

extended.defaultProps = { layoutOrder = 0 }

function extended.getRenewalText(p2, p3, p4)
	if p3.isAutoRenewing then
		return p4.renewalDate
	end

	return p4.expirationDate
end

function extended.render(p2)
	local devSub = p2.props.devSub

	local values = dateTime.fromIsoDate(devSub.expirationDate):GetValues()
	local v6 = string.format("%d/%d/%d", values.Month, values.Day, values.Year)

	return module3({
		monthlyPrice = {
			"Feature.DevSubs.UserManagement.MonthlyPrice",
			robuxAmount = devSub.price
		},
		renewalDate = {
			"Feature.DevSubs.Label.RenewalDate",
			date = v6
		},
		expirationDate = {
			"Feature.DevSubs.Label.ExpirationDate",
			date = v6
		},
		discontinueDate = {
			"Feature.DevSubs.Label.DiscontinueDate",
			date = v6
		}
	})(function(data)
		return withStyle(function(props)
			local props2 = p2.props
			local devSub2 = props2.devSub
			local layoutOrder = props2.layoutOrder
			local maxSize = props2.maxSize
			local hasFullDivider = props2.hasFullDivider
			local onActivated = props2.onActivated
			local udim, udim2

			if hasFullDivider then
				udim = UDim2.new(1, 49, 0, 1)
				udim2 = UDim2.new(0, -24, 0, -15)
			else
				udim = UDim2.new(1, 25, 0, 1)
				udim2 = UDim2.new(0, 0, 0, -15)
			end

			local v7

			if devSub2.isAutoRenewing then
				v7 = {
					FontFace = normalizeFontFace(props.Tokens.Typography.BodySmall.Font),
					TextSize = props.Font.BaseSize * props.Font.CaptionBody.RelativeSize,
					TextColor3 = props.Theme.TextDefault.Color,
					TextTransparency = props.Theme.TextDefault.Transparency,
					Text = data.renewalDate
				}
			else
				v7 = {
					FontFace = normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font),
					TextSize = props.Font.BaseSize * props.Font.CaptionHeader.RelativeSize,
					TextColor3 = props.Theme.TextEmphasis.Color,
					TextTransparency = props.Theme.TextEmphasis.Transparency,
					Text = data.expirationDate
				}

				if devSub2.planStatus ~= "Open" then
					v7.Text = data.discontinueDate
				end
			end

			return Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, maxSize.Y),
					LayoutOrder = layoutOrder,
					BackgroundTransparency = 1
				},
				{
					SizeConstraint = Roact.createElement("UISizeConstraint", {
						MaxSize = maxSize
					}),
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 15),
						PaddingLeft = UDim.new(0, 24),
						PaddingRight = UDim.new(0, 25)
					}),
					MoreButton = Roact.createElement(module2, {
						Image = "LuaApp/icons/navbar_more",
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 26, 0, 26),
						Position = UDim2.new(1, 0, 0, 18),
						BackgroundTransparency = 1,
						Visible = devSub2.status == module4.Active and devSub2.planStatus == module5.Open,
						[Roact.Event.Activated] = function(p3)
							onActivated(p3.AbsolutePosition, p3.AbsoluteSize)
						end
					}),
					TextFrame = Roact.createElement(
						"Frame",
						{ BackgroundTransparency = 1, Size = UDim2.new(1, -51, 1, 0) },
						{
							Layout = Roact.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, 4)
							}),
							Title = Roact.createElement("TextLabel", {
								BackgroundTransparency = 1,
								Size = UDim2.new(1, 0, 0, 22),
								LayoutOrder = 1,
								FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
								TextSize = props.Font.BaseSize * props.Font.Header2.RelativeSize,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextColor3 = props.Theme.TextDefault.Color,
								TextTransparency = props.Theme.TextDefault.Transparency,
								TextTruncate = Enum.TextTruncate.AtEnd,
								Text = devSub2.name
							}),
							PriceFrame = Roact.createElement(
								"Frame",
								{
									BackgroundTransparency = 1,
									Size = UDim2.new(1, 0, 0, 17),
									LayoutOrder = 2
								},
								{
									Layout = Roact.createElement("UIListLayout", {
										FillDirection = Enum.FillDirection.Horizontal,
										HorizontalAlignment = Enum.HorizontalAlignment.Left,
										SortOrder = Enum.SortOrder.LayoutOrder,
										Padding = UDim.new(0, 4)
									}),
									Icon = Roact.createElement(module, {
										BackgroundTransparency = 1,
										Image = "LuaApp/icons/robux-hex",
										Size = UDim2.new(0, 17, 0, 17),
										LayoutOrder = 1
									}),
									Text = Roact.createElement("TextLabel", {
										BackgroundTransparency = 1,
										Size = UDim2.new(1, -21, 1, 0),
										LayoutOrder = 2,
										FontFace = normalizeFontFace(props.Tokens.Typography.BodySmall.Font),
										TextSize = props.Font.BaseSize * props.Font.CaptionBody.RelativeSize,
										TextXAlignment = Enum.TextXAlignment.Left,
										TextColor3 = props.Theme.TextDefault.Color,
										TextTransparency = props.Theme.TextDefault.Transparency,
										TextTruncate = Enum.TextTruncate.AtEnd,
										Text = devSub2.price
									})
								}
							),
							RenewalDate = Roact.createElement("TextLabel", Cryo.Dictionary.join(v7, {
								BackgroundTransparency = 1,
								Size = UDim2.new(1, 0, 0, 17),
								LayoutOrder = 3,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextTruncate = Enum.TextTruncate.AtEnd
							}))
						}
					),
					Divider = Roact.createElement("Frame", {
						BorderSizePixel = 0,
						BackgroundColor3 = props.Theme.Divider.Color,
						BackgroundTransparency = props.Theme.Divider.Transparency,
						Size = udim,
						Position = udim2
					})
				}
			)
		end)
	end)
end

return extended
