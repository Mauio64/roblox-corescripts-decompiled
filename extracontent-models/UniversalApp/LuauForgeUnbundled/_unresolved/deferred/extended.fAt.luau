local CorePackages = game:GetService("CorePackages")
local dateTime = require("@luauforge/bundled/fAu").DateTime

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/edi")
local module2 = require("@luauforge/bundled/edp")

local module3 = require("@luauforge/bundled/edC")
local withStyle = UIBlox.Style.withStyle

local module4 = require("@luauforge/deferred/fAj")
local module5 = require("@luauforge/deferred/fAo")

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
					Font = 0,
					FontFace = 0,
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0,
					Text = 0
				}
				local v8 = if not foundationFontFaceMigration then props.Font.CaptionBody.Font else nil
				v7.Font = v8

				local v9 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodySmall.Font) else nil
				v7.FontFace = v9

				v7.TextSize = props.Font.BaseSize * props.Font.CaptionBody.RelativeSize
				v7.TextColor3 = props.Theme.TextDefault.Color
				v7.TextTransparency = props.Theme.TextDefault.Transparency
				v7.Text = data.renewalDate
			else
				v7 = {
					Font = 0,
					FontFace = 0,
					TextSize = 0,
					TextColor3 = 0,
					TextTransparency = 0,
					Text = 0
				}
				local v8 = if not foundationFontFaceMigration then props.Font.CaptionHeader.Font else nil
				v7.Font = v8

				local v9 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font) else nil
				v7.FontFace = v9

				v7.TextSize = props.Font.BaseSize * props.Font.CaptionHeader.RelativeSize
				v7.TextColor3 = props.Theme.TextEmphasis.Color
				v7.TextTransparency = props.Theme.TextEmphasis.Transparency
				v7.Text = data.expirationDate

				if devSub2.planStatus ~= "Open" then
					v7.Text = data.discontinueDate
				end
			end

			local createElement = Roact.createElement
			local v9 = {
				Size = UDim2.new(1, 0, 0, maxSize.Y),
				LayoutOrder = layoutOrder,
				BackgroundTransparency = 1
			}

			local children = {
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
				TextFrame = 0,
				Divider = 0
			}

			local createElement3 = Roact.createElement
			local v14 = { BackgroundTransparency = 1, Size = UDim2.new(1, -51, 1, 0) }
			local children2 = {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4)
				}),
				Title = 0,
				PriceFrame = 0,
				RenewalDate = 0
			}

			local createElement4 = Roact.createElement
			local v16 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 22),
				LayoutOrder = 1,
				Font = 0,
				FontFace = 0,
				TextSize = 0,
				TextXAlignment = 0,
				TextColor3 = 0,
				TextTransparency = 0,
				TextTruncate = 0,
				Text = 0
			}

			local v17 = if not foundationFontFaceMigration then props.Font.Header2.Font else nil
			v16.Font = v17

			local v18 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.TitleLarge.Font) else nil
			v16.FontFace = v18

			v16.TextSize = props.Font.BaseSize * props.Font.Header2.RelativeSize
			v16.TextXAlignment = Enum.TextXAlignment.Left
			v16.TextColor3 = props.Theme.TextDefault.Color
			v16.TextTransparency = props.Theme.TextDefault.Transparency
			v16.TextTruncate = Enum.TextTruncate.AtEnd

			v16.Text = devSub2.name
			children2.Title = createElement4("TextLabel", v16)

			local createElement5 = Roact.createElement
			local v20 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 17),
				LayoutOrder = 2
			}

			local v21 = {
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
				Text = 0
			}

			local createElement6 = Roact.createElement
			local v23 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -21, 1, 0),
				LayoutOrder = 2,
				Font = 0,
				FontFace = 0,
				TextSize = 0,
				TextXAlignment = 0,
				TextColor3 = 0,
				TextTransparency = 0,
				TextTruncate = 0,
				Text = 0
			}

			local v24 = if not foundationFontFaceMigration then props.Font.CaptionBody.Font else nil
			v23.Font = v24

			local v25 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodySmall.Font) else nil
			v23.FontFace = v25

			v23.TextSize = props.Font.BaseSize * props.Font.CaptionBody.RelativeSize
			v23.TextXAlignment = Enum.TextXAlignment.Left
			v23.TextColor3 = props.Theme.TextDefault.Color
			v23.TextTransparency = props.Theme.TextDefault.Transparency
			v23.TextTruncate = Enum.TextTruncate.AtEnd

			v23.Text = devSub2.price
			v21.Text = createElement6("TextLabel", v23)
			children2.PriceFrame = createElement5("Frame", v20, v21)

			children2.RenewalDate = Roact.createElement("TextLabel", Cryo.Dictionary.join(v7, {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 17),
				LayoutOrder = 3,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd
			}))
			children.TextFrame = createElement3("Frame", v14, children2)

			children.Divider = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundColor3 = props.Theme.Divider.Color,
				BackgroundTransparency = props.Theme.Divider.Transparency,
				Size = udim,
				Position = udim2
			})
			return createElement("Frame", v9, children)
		end)
	end)
end

return extended
