local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local withStyle = UIBlox.Style.withStyle
local loadableImage = UIBlox.App.Loading.LoadableImage
require("@luauforge/deferred/fAy")
require("@luauforge/bundled/dCp")
local module = require("@luauforge/bundled/fox")
local module2 = require("@luauforge/bundled/fys")
local module3 = require("@luauforge/bundled/fsr")
local t = require(CorePackages.Packages.t)
local module4 = require("@luauforge/bundled/fpF")
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local module5 = require("@luauforge/bundled/fAD")

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
		local font = props.Font
		local theme = props.Theme
		local font2 = font.Header2.Font
		local v6 = props.Font.BaseSize * props.Font.Header2.RelativeSize
		local color = theme.TextEmphasis.Color
		local font3 = props.Font.CaptionBody.Font
		local v7 = props.Font.BaseSize * props.Font.CaptionBody.RelativeSize
		local color2 = theme.TextDefault.Color

		local createElement = Roact.createElement
		local v9 = {
			Size = UDim2.fromOffset(screenWidth, screenHeight),
			BorderSizePixel = 0,
			BackgroundColor3 = backgroundUIDefault.Color,
			BackgroundTransparency = backgroundUIDefault.Transparency
		}
		local v10 = {
			TopBarFrame = Roact.createElement(module.Container, {
				titleText = "",
				leftItem = module.BackButton
			}),
			PageContent = 0
		}

		local createElement2 = Roact.createElement
		local pageContent = module.PageContent
		local createElement3 = Roact.createElement
		local v14 = { Position = UDim2.fromScale(0, 0), Size = UDim2.fromScale(1, 1) }

		local createElement4 = Roact.createElement
		local v16 = {
			Size = UDim2.new(0.85, 0, 0, 28),
			Position = UDim2.fromOffset(24, 24),
			Text = title,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextXAlignment = 0,
			TextTruncate = 0,
			BackgroundTransparency = 1
		}

		if foundationFontFaceMigration then
			font2 = nil
		end

		v16.Font = font2

		local v17 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.TitleLarge.Font) else nil
		v16.FontFace = v17

		v16.TextSize = v6
		v16.TextColor3 = color
		v16.TextXAlignment = Enum.TextXAlignment.Left
		v16.TextTruncate = Enum.TextTruncate.AtEnd
		local children = {
			Title = createElement4("TextLabel", v16),
			DateLabel = 0,
			DividerLine = 0,
			ContentFrame = 0
		}

		local createElement5 = Roact.createElement
		local v19 = {
			Size = UDim2.fromOffset(v5, 14),
			Position = UDim2.fromOffset(24, 64),
			Text = dateText,
			TextColor3 = color2,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextXAlignment = 0,
			BackgroundTransparency = 1
		}

		if foundationFontFaceMigration then
			font3 = nil
		end

		v19.Font = font3

		local v20 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodySmall.Font) else nil
		v19.FontFace = v20

		v19.TextSize = v7
		v19.TextXAlignment = Enum.TextXAlignment.Left
		children.DateLabel = createElement5("TextLabel", v19)

		children.DividerLine = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = theme.Divider.Color,
			BackgroundTransparency = theme.Divider.Transparency,
			Size = UDim2.fromOffset(v5, 1),
			Position = UDim2.fromOffset(24, 90)
		})

		children.ContentFrame = self:renderContent(screenWidth, props)
		v10.PageContent = createElement2(pageContent, {}, {
			Scroller = createElement3(module2, v14, children)
		})
		return createElement("Frame", v9, v10)
	end)
end

function extended.renderContent(p2, p3, props)
	local content = p2.props.notice.content
	local kind = p2.props.notice.type
	local v5 = p2.props.notice.portraitPicUrl
	local landscapePicUrl = p2.props.notice.landscapePicUrl
	local formFactor2 = p2.props.formFactor
	local font = props.Font.Body.Font
	local v6 = props.Font.BaseSize * props.Font.Body.RelativeSize
	local textDefault = props.Theme.TextDefault
	local noticeUrl = p2.props.notice.noticeUrl

	if kind == module5.Text then
		local v7 = p3 - 48
		local v8 = content ~= nil
		local v9

		if foundationFontFaceMigration then
			v9 = getTextSize(content, v6, props.Tokens.Typography.BodyLarge.Font, Vector2.new(10000, 10000)).Y
		else
			v9 = module4.GetTextHeight(content, font, v6, 10000)
		end

		local screenHeight = p2.props.screenHeight
		v9 = v9 < screenHeight and screenHeight or v9
		local createElement = Roact.createElement
		local onNoticeClickedsByActivated = {}
		onNoticeClickedsByActivated.Position = UDim2.fromOffset(24, 115)
		onNoticeClickedsByActivated.Size = UDim2.fromOffset(v7, v9)
		onNoticeClickedsByActivated.Text = content

		if foundationFontFaceMigration then
			font = nil
		end

		onNoticeClickedsByActivated.Font = font

		local v11 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
		onNoticeClickedsByActivated.FontFace = v11

		onNoticeClickedsByActivated.TextSize = v6
		onNoticeClickedsByActivated.TextXAlignment = Enum.TextXAlignment.Left
		onNoticeClickedsByActivated.TextYAlignment = Enum.TextYAlignment.Top
		onNoticeClickedsByActivated.TextColor3 = textDefault.Color
		onNoticeClickedsByActivated.TextWrapped = true
		onNoticeClickedsByActivated.BackgroundTransparency = 1
		onNoticeClickedsByActivated[Roact.Event.Activated] = p2.onNoticeClicked
		onNoticeClickedsByActivated.Active = v8
		return createElement("TextButton", onNoticeClickedsByActivated)
	else
		if kind ~= module5.Image then
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
