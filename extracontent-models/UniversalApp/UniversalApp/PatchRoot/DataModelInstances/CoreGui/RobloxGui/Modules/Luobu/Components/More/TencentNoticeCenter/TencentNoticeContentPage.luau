local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local LoadableImage = UIBlox.App.Loading.LoadableImage

require(Modules.Luobu.Constants)
require(Modules.LuaApp.AppPage)

local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local MorePageScrollingFrame = require(Modules.LuaApp.Components.More.MorePageScrollingFrame)
local OpenWebview = require(Modules.LuaApp.Thunks.OpenWebview)
local t = require(CorePackages.Packages.t)
local Text = require(Modules.Common.Text)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local TencentNoticeType = require(Modules.Luobu.Enum.TencentNoticeType)
local v15 = Roact.PureComponent:extend("TencentNoticeContentPage")

v15.validateProps = t.strictInterface({
	notice = t.table,
	dateText = t.string,
	screenWidth = t.number,
	screenHeight = t.number,
	formFactor = t.string,
	openNoticeDetail = t.callback
})

function v15.init(p1) -- line: 40
	function p1.onNoticeClicked() -- line: 41
		-- upvalues: p1 (copy)
		local title = p1.props.notice.title
		local noticeUrl = p1.props.notice.noticeUrl

		p1.props.openNoticeDetail(noticeUrl, title)
	end
end
function v15.render(p2) -- line: 48
	-- upvalues: withStyle (copy), Roact (copy), TopBar (copy), MorePageScrollingFrame (copy)
	local title = p2.props.notice.title
	local dateText = p2.props.dateText
	local screenWidth = p2.props.screenWidth
	local screenHeight = p2.props.screenHeight
	local v24 = screenWidth - 48

	return withStyle(function(t1: {[any]: any}) -- line: 54
		-- upvalues: Roact (copy), screenWidth (copy), screenHeight (copy), TopBar (copy), MorePageScrollingFrame (copy), title (copy), v24 (copy), dateText (copy), p2 (copy)
		local BackgroundUIDefault = t1.Theme.BackgroundUIDefault
		local t1Font = t1.Font
		local Theme = t1.Theme
		local Header2Font = t1Font.Header2.Font
		local v57 = t1.Font.BaseSize * t1.Font.Header2.RelativeSize
		local TextEmphasisColor = Theme.TextEmphasis.Color
		local CaptionBodyFont = t1.Font.CaptionBody.Font
		local v60 = t1.Font.BaseSize * t1.Font.CaptionBody.RelativeSize
		local TextDefaultColor = Theme.TextDefault.Color

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(screenWidth, screenHeight),
			BackgroundColor3 = BackgroundUIDefault.Color,
			BackgroundTransparency = BackgroundUIDefault.Transparency
		}, {
			TopBarFrame = Roact.createElement(TopBar.Container, {
				titleText = "",
				leftItem = TopBar.BackButton
			}),
			PageContent = Roact.createElement(TopBar.PageContent, {}, {
				Scroller = Roact.createElement(MorePageScrollingFrame, {
					Position = UDim2.fromScale(0, 0),
					Size = UDim2.fromScale(1, 1)
				}, {
					Title = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(0.85, 0, 0, 28),
						Position = UDim2.fromOffset(24, 24),
						Text = title,
						Font = Header2Font,
						TextSize = v57,
						TextColor3 = TextEmphasisColor,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd
					}),
					DateLabel = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.fromOffset(v24, 14),
						Position = UDim2.fromOffset(24, 64),
						Text = dateText,
						TextColor3 = TextDefaultColor,
						Font = CaptionBodyFont,
						TextSize = v60,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					DividerLine = Roact.createElement("Frame", {
						BorderSizePixel = 0,
						BackgroundColor3 = Theme.Divider.Color,
						BackgroundTransparency = Theme.Divider.Transparency,
						Size = UDim2.fromOffset(v24, 1),
						Position = UDim2.fromOffset(24, 90)
					}),
					ContentFrame = p2:renderContent(screenWidth, t1)
				})
			})
		})
	end)
end
function v15.renderContent(p3, p4, p5) -- line: 115
	-- upvalues: TencentNoticeType (copy), Text (copy), Roact (copy), FormFactor (copy), LoadableImage (copy)
	local content = p3.props.notice.content
	local type = p3.props.notice.type
	local portraitPicUrl = p3.props.notice.portraitPicUrl
	local landscapePicUrl = p3.props.notice.landscapePicUrl
	local formFactor = p3.props.formFactor
	local BodyFont = p5.Font.Body.Font
	local v34 = p5.Font.BaseSize * p5.Font.Body.RelativeSize
	local TextDefault = p5.Theme.TextDefault
	local noticeUrl = p3.props.notice.noticeUrl

	if type == TencentNoticeType.Text then
		local v37 = p4 - 48
		local v38 = content ~= nil
		local v39 = Text.GetTextHeight(content, BodyFont, v34, 10000)
		local screenHeight = p3.props.screenHeight
		local v41 = v39 < screenHeight and screenHeight or v39

		return Roact.createElement("TextButton", {
			Position = UDim2.fromOffset(24, 115),
			Size = UDim2.fromOffset(v37, v41),
			Text = content,
			Font = BodyFont,
			TextSize = v34,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = TextDefault.Color,
			TextWrapped = true,
			BackgroundTransparency = 1,
			[Roact.Event.Activated] = p3.onNoticeClicked,
			Active = v38
		})
	end

	if type == TencentNoticeType.Image then
		local v42 = noticeUrl ~= nil
		local v43 = p4 - 64
		local v44 = formFactor == FormFactor.WIDE
		local v45 = (not v44 and 1.4516 or 0.4074) * v43
		local v46 = v44 and landscapePicUrl or portraitPicUrl
		local v47 = Roact.createElement(LoadableImage, {
			useShimmerAnimationWhileLoading = true,
			showFailedStateWhenLoadingFailed = true,
			Size = UDim2.new(1, 0, 1, 0),
			Image = v46
		})

		return Roact.createElement("TextButton", {
			Size = UDim2.fromOffset(v43, v45),
			Position = UDim2.fromOffset(32, 115),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Active = v42,
			[Roact.Event.Activated] = p3.onNoticeClicked
		}, v47)
	end

	warn("Error: TencentNoticeType is incorrect. Please fix or add new type:" .. type)
end

local function mapStateToProps(p6) -- line: 174
	return {
		formFactor = p6.FormFactor,
		screenWidth = p6.ScreenSize.X,
		screenHeight = p6.ScreenSize.Y
	}
end
local function mapDispatchToProps(p7) -- line: 182
	-- upvalues: OpenWebview (copy)
	return {
		openNoticeDetail = function(p8, p9) -- line: 184
			-- upvalues: p7 (copy), OpenWebview (copy)
			p7(OpenWebview(p8, p9))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v15)
