local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local withStyle = UIBlox.Style.withStyle
local loadableImage = UIBlox.App.Loading.LoadableImage
require("@luauforge/deferred/geQ")
require("@luauforge/bundled/dFu")
local module = require("@luauforge/bundled/fvR")
local module2 = require("@luauforge/bundled/fGj")
local module3 = require("@luauforge/bundled/fzL")
local t = require(CorePackages.Packages.t)
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local module4 = require("@luauforge/bundled/geV")

local extended = Roact.PureComponent:extend("TencentNoticeContentPage")

extended.validateProps = t.strictInterface({
	notice = t.table,
	dateText = t.string,
	screenWidth = t.number,
	screenHeight = t.number,
	formFactor = t.string,
	openNoticeDetail = t.callback
})

function extended:init()
	function self.onNoticeClicked()
		local title = self.props.notice.title
		local noticeUrl = self.props.notice.noticeUrl
		self.props.openNoticeDetail(noticeUrl, title)
	end
end

function extended:render()
	local title = self.props.notice.title
	local dateText = self.props.dateText
	local screenWidth = self.props.screenWidth
	local screenHeight = self.props.screenHeight
	local v5 = screenWidth - 48
	return withStyle(function(props)
		local backgroundUIDefault = props.Theme.BackgroundUIDefault
		local theme = props.Theme
		local v6 = props.Font.BaseSize * props.Font.Header2.RelativeSize
		local color = theme.TextEmphasis.Color
		local v7 = props.Font.BaseSize * props.Font.CaptionBody.RelativeSize
		local color2 = theme.TextDefault.Color

		return Roact.createElement(
			"Frame",
			{
				Size = UDim2.fromOffset(screenWidth, screenHeight),
				BorderSizePixel = 0,
				BackgroundColor3 = backgroundUIDefault.Color,
				BackgroundTransparency = backgroundUIDefault.Transparency
			},
			{
				TopBarFrame = Roact.createElement(module.Container, {
					titleText = "",
					leftItem = module.BackButton
				}),
				PageContent = Roact.createElement(module.PageContent, {}, {
					Scroller = Roact.createElement(
						module2,
						{
							Position = UDim2.fromScale(0, 0),
							Size = UDim2.fromScale(1, 1)
						},
						{
							Title = Roact.createElement("TextLabel", {
								Size = UDim2.new(0.85, 0, 0, 28),
								Position = UDim2.fromOffset(24, 24),
								Text = title,
								FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
								TextSize = v6,
								TextColor3 = color,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextTruncate = Enum.TextTruncate.AtEnd,
								BackgroundTransparency = 1
							}),
							DateLabel = Roact.createElement("TextLabel", {
								Size = UDim2.fromOffset(v5, 14),
								Position = UDim2.fromOffset(24, 64),
								Text = dateText,
								TextColor3 = color2,
								FontFace = normalizeFontFace(props.Tokens.Typography.BodySmall.Font),
								TextSize = v7,
								TextXAlignment = Enum.TextXAlignment.Left,
								BackgroundTransparency = 1
							}),
							DividerLine = Roact.createElement("Frame", {
								BorderSizePixel = 0,
								BackgroundColor3 = theme.Divider.Color,
								BackgroundTransparency = theme.Divider.Transparency,
								Size = UDim2.fromOffset(v5, 1),
								Position = UDim2.fromOffset(24, 90)
							}),
							ContentFrame = self:renderContent(screenWidth, props)
						}
					)
				})
			}
		)
	end)
end

function extended.renderContent(p2, p3, props)
	local content = p2.props.notice.content
	local kind = p2.props.notice.type
	local v5 = p2.props.notice.portraitPicUrl
	local landscapePicUrl = p2.props.notice.landscapePicUrl
	local formFactor2 = p2.props.formFactor
	local v6 = props.Font.BaseSize * props.Font.Body.RelativeSize
	local textDefault = props.Theme.TextDefault
	local noticeUrl = p2.props.notice.noticeUrl

	if kind == module4.Text then
		local v7 = p3 - 48
		local v8 = content ~= nil
		local v9 = getTextSize(
			content,
			v6,
			props.Tokens.Typography.BodyLarge.Font,
			Vector2.new(10000, 10000)
		).Y
		local screenHeight = p2.props.screenHeight
		v9 = v9 < screenHeight and screenHeight or v9
		return Roact.createElement("TextButton", {
			Position = UDim2.fromOffset(24, 115),
			Size = UDim2.fromOffset(v7, v9),
			Text = content,
			FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
			TextSize = v6,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = textDefault.Color,
			TextWrapped = true,
			BackgroundTransparency = 1,
			[Roact.Event.Activated] = p2.onNoticeClicked,
			Active = v8
		})
	else
		if kind ~= module4.Image then
			warn("Error: TencentNoticeType is incorrect. Please fix or add new type:" .. kind)
			return
		end

		local v7 = noticeUrl ~= nil
		local v8 = p3 - 64
		local v9 = formFactor2 == formFactor.WIDE
		local v10 = (v9 and 0.4074 or 1.4516) * v8
		v5 = v9 and landscapePicUrl or v5
		local element = Roact.createElement(loadableImage, {
			Size = UDim2.new(1, 0, 1, 0),
			Image = v5,
			useShimmerAnimationWhileLoading = true,
			showFailedStateWhenLoadingFailed = true
		})

		return Roact.createElement("TextButton", {
			Size = UDim2.fromOffset(v8, v10),
			Position = UDim2.fromOffset(32, 115),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Active = v7,
			[Roact.Event.Activated] = p2.onNoticeClicked
		}, element)
	end
end

local function mapStateToProps(p2)
	return {
		formFactor = p2.FormFactor,
		screenWidth = p2.ScreenSize.X,
		screenHeight = p2.ScreenSize.Y
	}
end

local function mapDispatchToProps(callback)
	return {
		openNoticeDetail = function(p2, p3)
			callback(module3(p2, p3))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
