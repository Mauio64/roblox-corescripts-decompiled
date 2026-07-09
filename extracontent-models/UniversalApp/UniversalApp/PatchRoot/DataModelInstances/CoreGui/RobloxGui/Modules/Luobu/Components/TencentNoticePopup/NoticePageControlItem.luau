local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local LoadableImage = UIBlox.App.Loading.LoadableImage
local Text = require(Modules.Common.Text)
local TencentNoticeType = require(Modules.Luobu.Enum.TencentNoticeType)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local v12 = Roact.PureComponent:extend("NoticePageControlItem")

v12.validateProps = t.strictInterface({
	headerHeight = t.number,
	contentHeight = t.number,
	width = t.number,
	notice = t.table,
	layoutOrder = t.number,
	formFactor = t.string,
	hasOneNotice = t.boolean
})

function v12.render(p1) -- line: 32
	-- upvalues: withStyle (copy), TencentNoticeType (copy), Roact (copy)
	local headerHeight = p1.props.headerHeight
	local contentHeight = p1.props.contentHeight
	local width = p1.props.width
	local title = p1.props.notice.title
	local layoutOrder = p1.props.layoutOrder

	return withStyle(function(t1: {[any]: any}) -- line: 38
		-- upvalues: width (copy), p1 (copy), TencentNoticeType (copy), Roact (copy), headerHeight (copy), contentHeight (copy), layoutOrder (copy), title (copy)
		local t1Font = t1.Font
		local Theme = t1.Theme
		local Header1Font = t1Font.Header1.Font
		local TextEmphasisColor = Theme.TextEmphasis.Color
		local v58 = t1.Font.BaseSize * t1.Font.Header2.RelativeSize
		local v59 = width - 48
		local v60 = p1.props.notice.type == TencentNoticeType.Text

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = Theme.BackgroundUIDefault.Transparency,
			BackgroundColor3 = Theme.BackgroundUIDefault.Color,
			Size = UDim2.fromOffset(width, headerHeight + contentHeight),
			AnchorPoint = Vector2.new(0, 0),
			LayoutOrder = layoutOrder
		}, {
			TopFrame = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 3,
				Size = UDim2.fromOffset(width, headerHeight + 10),
				BackgroundTransparency = Theme.BackgroundUIDefault.Transparency,
				BackgroundColor3 = Theme.BackgroundUIDefault.Color
			}, {
				TitleLabel = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0.7, 0, 1, 0),
					Text = title,
					TextColor3 = TextEmphasisColor,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Font = Header1Font,
					TextSize = v58
				}),
				DividerLine = v60 and Roact.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.Divider.Color,
					BackgroundTransparency = Theme.Divider.Transparency,
					Size = UDim2.fromOffset(v59, 1),
					Position = UDim2.fromOffset(24, headerHeight + 10)
				})
			}),
			ContentFrame = p1:renderContent(t1, headerHeight, width, contentHeight)
		})
	end)
end
function v12.renderContent(p2, p3, p4, p5, p6) -- line: 86
	-- upvalues: TencentNoticeType (copy)
	local type = p2.props.notice.type

	if type == TencentNoticeType.Text then
		return p2:renderTextContent(p3, p4, p5, p6)
	end

	if type == TencentNoticeType.Image then
		return p2:renderImageContent(p3, p4, p5, p6)
	end

	warn("Error: TencentNoticeType is incorrect! Please fix or add new type:" .. type)

	return nil
end
function v12.renderTextContent(t2: {[any]: any}, t3: {[any]: any}, p7, p8, p9) -- line: 98
	-- upvalues: Text (copy), Roact (copy)
	local content = t2.props.notice.content

	if content == nil then
		return nil
	end

	local v32 = p8 - 48
	local Theme = t3.Theme
	local BodyFont = t3.Font.Body.Font
	local v35 = t3.Font.BaseSize * t3.Font.Body.RelativeSize
	local TextDefault = Theme.TextDefault
	local v37 = Text.GetTextHeight(content, BodyFont, v35, 10000)
	local v38 = v37 < p9 and p9 or v37
	local v39 = p9 + 10

	if t2.props.hasOneNotice then
		v39 -= 48
	end

	return Roact.createElement("ScrollingFrame", {
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		Size = UDim2.fromOffset(p8, v39),
		Position = UDim2.new(0, 0, 0, p7 - 10),
		BackgroundColor3 = Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = Theme.BackgroundUIDefault.Transparency,
		CanvasSize = UDim2.new(0, p8, 0, v38),
		ScrollingDirection = Enum.ScrollingDirection.Y
	}, {
		Content = Roact.createElement("TextLabel", {
			TextWrapped = true,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(v32, v38),
			Position = UDim2.fromOffset(24, 34),
			Text = content,
			Font = BodyFont,
			TextSize = v35,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = TextDefault.Color,
			TextTransparency = TextDefault.Transparency,
			TextTruncate = Enum.TextTruncate.AtEnd
		})
	})
end
function v12.renderImageContent(p10, p11, p12, p13, p14) -- line: 141
	-- upvalues: FormFactor (copy), Roact (copy), LoadableImage (copy)
	local Theme = p11.Theme
	local landscapePicUrl = p10.props.notice.landscapePicUrl
	local portraitPicUrl = p10.props.notice.portraitPicUrl
	local v48 = p10.props.formFactor == FormFactor.WIDE and landscapePicUrl or portraitPicUrl
	local hasOneNotice = p10.props.hasOneNotice
	local v50 = Roact.createElement("Frame", {
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ZIndex = 3,
		BackgroundColor3 = Theme.Overlay.Color,
		Size = UDim2.fromOffset(p13, 48),
		Position = UDim2.fromOffset(0, p14 - 48)
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
	local v51 = Roact.createElement(LoadableImage, {
		useShimmerAnimationWhileLoading = true,
		showFailedStateWhenLoadingFailed = true,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(p13, p14),
		Position = UDim2.fromOffset(0, 0),
		Image = v48
	}, {
		gradientLayer = not hasOneNotice and v50
	})

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(p13, p14),
		Position = UDim2.fromOffset(0, p12)
	}, {
		TopCoverLayer = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 2,
			BackgroundTransparency = Theme.BackgroundUIDefault.Transparency,
			BackgroundColor3 = Theme.BackgroundUIDefault.Color,
			Size = UDim2.fromOffset(p13, 10),
			Position = UDim2.fromOffset(0, 0)
		}),
		ImageView = v51
	})
end

local function mapStateToProps(p15) -- line: 202
	return {
		formFactor = p15.FormFactor
	}
end

return (RoactRodux.connect(mapStateToProps, nil)(v12))
