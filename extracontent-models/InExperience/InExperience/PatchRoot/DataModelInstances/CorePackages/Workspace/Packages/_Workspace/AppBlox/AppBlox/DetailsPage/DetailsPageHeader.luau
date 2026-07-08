local Parent = script:FindFirstAncestor("AppBlox").Parent
local UIBlox = require(Parent.UIBlox)
local withStyle = UIBlox.Core.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local LoadableImage = UIBlox.App.Loading.LoadableImage
local ActionBar = UIBlox.App.Button.ActionBar
local DeviceType = require(Parent.RobloxAppEnums).DeviceType
local Roact = require(Parent.Roact)
local t = require(Parent.t)
local DetailsPageTitleContent = require(script.Parent.DetailsPageTitleContent)
local FFlagLuaAppFixDetailsPageThumbnailRenderInPhone = require(Parent.SharedFlags).FFlagLuaAppFixDetailsPageThumbnailRenderInPhone
local v13 = game:DefineFastFlag("LuaAppBottomAlignDetailsHeaderInfoFrame", false)
local FFlagUIBloxEnableActionBarButtonOverride = require(Parent.SharedFlags).UIBlox.FFlagUIBloxEnableActionBarButtonOverride
local FFlagUIBloxAddTestIdToActionBar = require(Parent.SharedFlags).UIBlox.FFlagUIBloxAddTestIdToActionBar
local v16 = game:DefineFastFlag("FFlagFixDetailsPageIconShadowSlicing", false)
local v17 = Roact.PureComponent:extend("DetailsPageHeader")

v17.defaultProps = {
	thumbnailHeight = 200,
	actionBarHeight = 48,
	actionBarWidth = 380,
	thumbnailAspectRatio = Vector2.new(1, 1)
}
v17.validateProps = t.strictInterface({
	thumbnailImageUrl = t.optional(t.string),
	thumbnailAspectRatio = t.optional(t.Vector2),
	thumbnailHeight = t.optional(t.number),
	titleText = t.optional(t.string),
	subTitleText = t.optional(t.string),
	actionBarLabelText = t.optional(t.string),
	renderInfoContent = t.optional(t.callback),
	renderCustomHeader = t.optional(t.callback),
	headerBarBackgroundHeight = t.optional(t.number),
	sideMargin = t.optional(t.number),
	itemPadding = t.optional(t.number),
	bottomMargin = t.optional(t.number),
	gradientHeight = t.optional(t.number),
	thumbnailShadowHeight = t.optional(t.number),
	actionBarHeight = t.optional(t.number),
	actionBarWidth = t.optional(t.number),
	maxContentWidth = t.optional(t.number),
	actionBarProps = t.optional(t.table),
	renderActionBarLabelImpressionsDetector = t.optional(t.callback),
	scrollViewPositionChangedSignal = t.optional(t.table),
	deviceType = t.optional(t.string)
})

function v17.init(p1) -- line: 80
	-- upvalues: Roact (copy)
	p1.actionBarLabelRef = Roact.createRef()
end
function v17.renderThumbnail(p2, p3, p4, p5, p6) -- line: 84
	-- upvalues: Roact (copy), LoadableImage (copy), ImageSetLabel (copy), Images (copy), v16 (copy)
	return Roact.createElement("Frame", {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(p5, p6),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0)
	}, {
		ThumbnailTile = Roact.createElement(LoadableImage, {
			cornerRadius = UDim.new(0, 8),
			Size = UDim2.fromScale(1, 1),
			Image = p2.props.thumbnailImageUrl
		}),
		DropShadow = if not (p4 > 0) then nil else Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 28),
			Position = UDim2.fromScale(0, 1),
			Image = Images["component_assets/dropshadow_thumbnail_28"],
			ImageColor3 = p3.Theme.DropShadow.Color,
			ImageTransparency = p3.Theme.DropShadow.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = if not v16 then Rect.new(32, 0, 33, 28) else Rect.new(32, 0, 33, 1)
		})
	})
end
function v17.renderDesktopMode(p7, p8) -- line: 114
	-- upvalues: Roact (copy), v13 (copy), DetailsPageTitleContent (copy), ActionBar (copy), FFlagUIBloxEnableActionBarButtonOverride (copy), FFlagUIBloxAddTestIdToActionBar (copy)
	local thumbnailHeight = p7.props.thumbnailHeight
	local v27 = thumbnailHeight * (p7.props.thumbnailAspectRatio.X / p7.props.thumbnailAspectRatio.Y)
	local v28 = p7.props.sideMargin or 48
	local v29 = p7.props.itemPadding or 24
	local n1 = 28

	if p7.props.thumbnailShadowHeight ~= nil then
		n1 = p7.props.thumbnailShadowHeight
	end

	local v31 = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, -(v27 + v28 * 2), 1, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, if not p7.props.renderCustomHeader then {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = if not v13 then Enum.VerticalAlignment.Top else Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, 16)
		}),
		TitleInfo = Roact.createElement(DetailsPageTitleContent, {
			layoutOrder = 1,
			titleText = p7.props.titleText,
			subTitleText = p7.props.subTitleText,
			renderInfoContent = p7.props.renderInfoContent,
			verticalAlignment = Enum.VerticalAlignment.Top
		}),
		ActonBarFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.fromOffset(p7.props.actionBarWidth, p7.props.actionBarHeight)
		}, {
			ActionBar = p7.props.actionBarProps and Roact.createElement(ActionBar, {
				enableButtonAtStart = true,
				button = p7.props.actionBarProps.button,
				buttonOverride = if not FFlagUIBloxEnableActionBarButtonOverride then nil else p7.props.actionBarProps.buttonOverride,
				icons = p7.props.actionBarProps.icons,
				iconSize = p7.props.actionBarProps.iconSize,
				buttonHeight = p7.props.actionBarProps.buttonHeight,
				buttonPadding = p7.props.actionBarProps.buttonPadding,
				textButtons = p7.props.actionBarProps.textButtons,
				marginOverride = {
					left = 0,
					right = 0,
					top = 0,
					bottom = 0
				},
				horizontalAlignment = Enum.HorizontalAlignment.Left,
				testId = if not FFlagUIBloxAddTestIdToActionBar then nil else "--experience-details"
			}) or nil
		}),
		ActionBarLabel = if not p7.props.actionBarLabelText then nil else Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = p7.props.actionBarLabelText,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			BackgroundTransparency = 1,
			Font = p8.Tokens.Typography.BodyLarge.Font,
			TextSize = p8.Tokens.FontSize.FontSize_350,
			TextColor3 = p8.Tokens.Color.Content.Emphasis.Color3,
			TextTransparency = p8.Tokens.Color.Content.Emphasis.Transparency,
			LayoutOrder = 3,
			[Roact.Ref] = p7.actionBarLabelRef
		}),
		ActionBarLabelImpressionsDetector = if not p7.props.actionBarLabelText or not p7.props.renderActionBarLabelImpressionsDetector then nil else p7.props.renderActionBarLabelImpressionsDetector(p7.actionBarLabelRef, p7.props.scrollViewPositionChangedSignal)
	} else p7.props.renderCustomHeader())

	return {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v28),
			PaddingRight = UDim.new(0, v28),
			PaddingBottom = UDim.new(0, 16)
		}),
		ContentFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.fromScale(0.5, 1),
			AnchorPoint = Vector2.new(0.5, 1)
		}, if not p7.props.renderCustomHeader then {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDim.new(0, v29)
			}),
			ThumbnailTileFrame = p7:renderThumbnail(p8, n1, v27, thumbnailHeight),
			InfoFrame = v31,
			UISizeConstraint = if not p7.props.maxContentWidth then nil else Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(p7.props.maxContentWidth, 1e999)
			})
		} else {
			CustomHeader = p7.props.renderCustomHeader(),
			UISizeConstraint = if not p7.props.maxContentWidth then nil else Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(p7.props.maxContentWidth, 1e999)
			})
		})
	}
end
function v17.renderisPhone(p9, p10) -- line: 251
	-- upvalues: Roact (copy), FFlagLuaAppFixDetailsPageThumbnailRenderInPhone (copy)
	local thumbnailHeight = p9.props.thumbnailHeight
	local v35 = thumbnailHeight * (p9.props.thumbnailAspectRatio.X / p9.props.thumbnailAspectRatio.Y)
	local v36 = p9.props.sideMargin or 24

	if p9.props.renderCustomHeader then
		return {
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v36),
				PaddingRight = UDim.new(0, v36),
				PaddingBottom = UDim.new(0, 16)
			}),
			ContentFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1)
			}, {
				Content = p9.props.renderCustomHeader()
			})
		}
	end

	return {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v36),
			PaddingRight = UDim.new(0, v36),
			PaddingBottom = UDim.new(0, 16)
		}),
		ThumbnailTileFrame = if not FFlagLuaAppFixDetailsPageThumbnailRenderInPhone then p9:renderThumbnail(p10, v35, thumbnailHeight) else p9:renderThumbnail(p10, 0, v35, thumbnailHeight)
	}
end
function v17.render(p11) -- line: 289
	-- upvalues: DeviceType (copy), withStyle (copy), Roact (copy)
	local v38 = p11.props.deviceType == DeviceType.Phone
	local thumbnailHeight = p11.props.thumbnailHeight
	local v40 = p11.props.headerBarBackgroundHeight or 80
	local v41 = p11.props.gradientHeight or thumbnailHeight + 16 - v40 + 44
	local bottomMargin = p11.props.bottomMargin

	return withStyle(function(p12) -- line: 299
		-- upvalues: Roact (copy), v41 (copy), v40 (copy), v38 (copy), p11 (copy), thumbnailHeight (copy), bottomMargin (copy)
		local Theme = p12.Theme

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			GradientBar = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, v41),
				BackgroundColor3 = Theme.BackgroundDefault.Color,
				AnchorPoint = Vector2.new(0, 1)
			}, {
				Gradient = Roact.createElement("UIGradient", {
					Rotation = 270,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(0.5, 0.25),
						NumberSequenceKeypoint.new(1, 1)
					})
				})
			}),
			BackgroundBar = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, v40),
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = Theme.BackgroundDefault.Color,
				BackgroundTransparency = Theme.BackgroundDefault.Transparency
			}, v38 and p11:renderisPhone(p12, thumbnailHeight) or p11:renderDesktopMode(p12, thumbnailHeight)),
			Padding = if not bottomMargin then nil else Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, bottomMargin)
			})
		})
	end)
end

return v17
