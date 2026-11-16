local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local withStyle = UIBlox.Style.withStyle
local loadableImage = UIBlox.App.Loading.LoadableImage
local module = require("@luauforge/bundled/fpF")
local module2 = require("@luauforge/bundled/fAD")
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor

local extended = Roact.PureComponent:extend("NoticePageControlItem")

extended.validateProps = t.strictInterface({
	headerHeight = t.number,
	contentHeight = t.number,
	width = t.number,
	notice = t.table,
	layoutOrder = t.number,
	formFactor = t.string,
	hasOneNotice = t.boolean
})

function extended:render()
	local headerHeight = self.props.headerHeight
	local contentHeight = self.props.contentHeight
	local width = self.props.width
	local title = self.props.notice.title
	local layoutOrder = self.props.layoutOrder
	return withStyle(function(props)
		local font = props.Font
		local theme = props.Theme
		local font2 = font.Header1.Font
		local color = theme.TextEmphasis.Color
		local v5 = props.Font.BaseSize * props.Font.Header2.RelativeSize
		local v6 = width - 48
		local v7 = self.props.notice.type == module2.Text
		local createElement = Roact.createElement
		local v9 = {
			BackgroundTransparency = theme.BackgroundUIDefault.Transparency,
			BackgroundColor3 = theme.BackgroundUIDefault.Color,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(width, headerHeight + contentHeight),
			AnchorPoint = Vector2.new(0, 0),
			LayoutOrder = layoutOrder
		}

		local createElement2 = Roact.createElement
		local v12 = {
			Size = UDim2.fromOffset(width, headerHeight + 10),
			BackgroundTransparency = theme.BackgroundUIDefault.Transparency,
			BackgroundColor3 = theme.BackgroundUIDefault.Color,
			BorderSizePixel = 0,
			ZIndex = 3
		}

		local createElement3 = Roact.createElement
		local v15 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.7, 0, 1, 0),
			Text = title,
			TextColor3 = color,
			BackgroundTransparency = 1,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			BorderSizePixel = 0
		}

		if foundationFontFaceMigration then
			font2 = nil
		end

		v15.Font = font2

		local v16 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.HeadingSmall.Font) else nil
		v15.FontFace = v16

		v15.TextSize = v5
		return createElement("Frame", v9, {
			TopFrame = createElement2("Frame", v12, {
				TitleLabel = createElement3("TextLabel", v15),
				DividerLine = v7 and Roact.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundColor3 = theme.Divider.Color,
					BackgroundTransparency = theme.Divider.Transparency,
					Size = UDim2.fromOffset(v6, 1),
					Position = UDim2.fromOffset(24, headerHeight + 10)
				})
			}),
			ContentFrame = self:renderContent(props, headerHeight, width, contentHeight)
		})
	end)
end

function extended:renderContent(p2, p3, p4, p5)
	local kind = self.props.notice.type

	if kind == module2.Text then
		return self:renderTextContent(p2, p3, p4, p5)
	end

	if kind == module2.Image then
		return self:renderImageContent(p2, p3, p4, p5)
	end

	warn("Error: TencentNoticeType is incorrect! Please fix or add new type:" .. kind)
	return nil
end

function extended:renderTextContent(props, p3, p4, p5)
	local content = self.props.notice.content

	if content == nil then
		return nil
	end

	local v5 = p4 - 48
	local theme = props.Theme
	local font = props.Font.Body.Font
	local v6 = props.Font.BaseSize * props.Font.Body.RelativeSize
	local textDefault = theme.TextDefault
	local v7

	if foundationFontFaceMigration then
		v7 = getTextSize(content, v6, props.Tokens.Typography.BodyLarge.Font, Vector2.new(10000, 10000)).Y
	else
		v7 = module.GetTextHeight(content, font, v6, 10000)
	end

	local v8 = v7 < p5 and p5 or v7
	local v9 = p5 + 10

	if self.props.hasOneNotice then
		v9 -= 48
	end

	local createElement = Roact.createElement
	local v11 = {
		Size = UDim2.fromOffset(p4, v9),
		Position = UDim2.new(0, 0, 0, p3 - 10),
		BorderSizePixel = 0,
		BackgroundColor3 = theme.BackgroundUIDefault.Color,
		BackgroundTransparency = theme.BackgroundUIDefault.Transparency,
		CanvasSize = UDim2.new(0, p4, 0, v8),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 0
	}

	local createElement2 = Roact.createElement
	local v14 = {
		Size = UDim2.fromOffset(v5, v8),
		Position = UDim2.fromOffset(24, 34),
		Text = content,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextWrapped = true,
		BackgroundTransparency = 1,
		TextTruncate = 0
	}

	if foundationFontFaceMigration then
		font = nil
	end

	v14.Font = font

	local v15 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
	v14.FontFace = v15

	v14.TextSize = v6
	v14.TextXAlignment = Enum.TextXAlignment.Left
	v14.TextYAlignment = Enum.TextYAlignment.Top
	v14.TextColor3 = textDefault.Color
	v14.TextTransparency = textDefault.Transparency

	v14.TextTruncate = Enum.TextTruncate.AtEnd
	return createElement("ScrollingFrame", v11, {
		Content = createElement2("TextLabel", v14)
	})
end

function extended:renderImageContent(p3, p4, p5, p6)
	local theme = p3.Theme
	local landscapePicUrl = self.props.notice.landscapePicUrl
	local v5 = self.props.notice.portraitPicUrl
	v5 = self.props.formFactor == formFactor.WIDE and landscapePicUrl or v5

	local v6 = not self.props.hasOneNotice
	local element = Roact.createElement("Frame", {
		BackgroundTransparency = 0,
		BackgroundColor3 = theme.Overlay.Color,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(p5, 48),
		Position = UDim2.fromOffset(0, p6 - 48),
		ZIndex = 3
	}, {
		UIGradient = Roact.createElement("UIGradient", {
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
				ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.1, 1),
				NumberSequenceKeypoint.new(1, 0)
			})
		})
	})

	local element2 = Roact.createElement(loadableImage, {
		Size = UDim2.fromOffset(p5, p6),
		Position = UDim2.fromOffset(0, 0),
		Image = v5,
		useShimmerAnimationWhileLoading = true,
		showFailedStateWhenLoadingFailed = true,
		BackgroundTransparency = 1
	}, {
		gradientLayer = v6 and element
	})

	return Roact.createElement(
		"Frame",
		{
			Size = UDim2.fromOffset(p5, p6),
			Position = UDim2.fromOffset(0, p4),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		},
		{
			TopCoverLayer = Roact.createElement("Frame", {
				BackgroundTransparency = theme.BackgroundUIDefault.Transparency,
				BackgroundColor3 = theme.BackgroundUIDefault.Color,
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(p5, 10),
				Position = UDim2.fromOffset(0, 0),
				ZIndex = 2
			}),
			ImageView = element2
		}
	)
end

local function mapStateToProps(p2)
	return { formFactor = p2.FormFactor }
end

return (RoactRodux.connect(mapStateToProps, nil)(extended))
