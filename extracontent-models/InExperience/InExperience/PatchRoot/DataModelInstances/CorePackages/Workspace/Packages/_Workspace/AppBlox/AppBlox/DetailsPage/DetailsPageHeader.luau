local parent = script:FindFirstAncestor("AppBlox").Parent
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local withStyle = UIBlox.Core.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Images = UIBlox.App.ImageSet.Images
local LoadableImage = UIBlox.App.Loading.LoadableImage
local ActionBar = UIBlox.App.Button.ActionBar

local RobloxAppEnums = require(parent.RobloxAppEnums)
local DeviceType = RobloxAppEnums.DeviceType

local Roact = require(parent.Roact)
local t = require(parent.t)

local DetailsPageTitleContent = require(script.Parent.DetailsPageTitleContent)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppFixDetailsPageThumbnailRenderInPhone = SharedFlags.FFlagLuaAppFixDetailsPageThumbnailRenderInPhone

local defineFastFlag = game:DefineFastFlag("LuaAppBottomAlignDetailsHeaderInfoFrame", false)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagUIBloxEnableActionBarButtonOverride = SharedFlags2.UIBlox.FFlagUIBloxEnableActionBarButtonOverride
local SharedFlags3 = require(parent.SharedFlags)
local FFlagUIBloxAddTestIdToActionBar = SharedFlags3.UIBlox.FFlagUIBloxAddTestIdToActionBar

local extended = Roact.PureComponent:extend("DetailsPageHeader")

extended.defaultProps = {
	thumbnailHeight = 200,
	thumbnailAspectRatio = Vector2.new(1, 1),
	actionBarHeight = 48,
	actionBarWidth = 380
}

extended.validateProps = t.strictInterface({
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

function extended:init()
	self.actionBarLabelRef = Roact.createRef()
end

function extended:renderThumbnail(p, p2, p3, p4)
	local createElement = Roact.createElement
	local v = {
		Size = UDim2.fromOffset(p3, p4),
		LayoutOrder = 1,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundTransparency = 1
	}

	local v2 = {
		ThumbnailTile = Roact.createElement(LoadableImage, {
			cornerRadius = UDim.new(0, 8),
			Size = UDim2.fromScale(1, 1),
			Image = self.props.thumbnailImageUrl
		}),
		DropShadow = 0
	}
	local dropShadow

	if p2 > 0 then
		dropShadow = Roact.createElement(ImageSetLabel, {
			Size = UDim2.new(1, 0, 0, 28),
			Position = UDim2.fromScale(0, 1),
			BackgroundTransparency = 1,
			Image = Images["component_assets/dropshadow_thumbnail_28"],
			ImageColor3 = p.Theme.DropShadow.Color,
			ImageTransparency = p.Theme.DropShadow.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(32, 0, 33, 1)
		})
	end

	v2.DropShadow = dropShadow
	return createElement("Frame", v, v2)
end

function extended:renderDesktopMode(p)
	local thumbnailHeight = self.props.thumbnailHeight
	local v = thumbnailHeight * (self.props.thumbnailAspectRatio.X / self.props.thumbnailAspectRatio.Y)
	local sideMargin = self.props.sideMargin or 48
	local itemPadding = self.props.itemPadding or 24

	local v2 = self.props.thumbnailShadowHeight == nil and 28 or self.props.thumbnailShadowHeight

	local createElement = Roact.createElement

	local v3 = {
		Size = UDim2.new(1, -(v + sideMargin * 2), 1, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 2
	}
	local children

	if self.props.renderCustomHeader then
		children = self.props.renderCustomHeader()
	else
		children = {
			Layout = 0,
			TitleInfo = 0,
			ActonBarFrame = 0,
			ActionBarLabel = 0,
			ActionBarLabelImpressionsDetector = 0
		}
		local createElement2 = Roact.createElement
		local v4 = {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = 0,
			Padding = 0
		}
		local verticalAlignment

		if defineFastFlag then
			verticalAlignment = Enum.VerticalAlignment.Bottom
		else
			verticalAlignment = Enum.VerticalAlignment.Top
		end

		v4.VerticalAlignment = verticalAlignment

		v4.Padding = UDim.new(0, 16)
		children.Layout = createElement2("UIListLayout", v4)

		children.TitleInfo = Roact.createElement(DetailsPageTitleContent, {
			titleText = self.props.titleText,
			subTitleText = self.props.subTitleText,
			renderInfoContent = self.props.renderInfoContent,
			verticalAlignment = Enum.VerticalAlignment.Top,
			layoutOrder = 1
		})

		local createElement3 = Roact.createElement
		local v5 = {
			Size = UDim2.fromOffset(self.props.actionBarWidth, self.props.actionBarHeight),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}
		local actionBar

		if self.props.actionBarProps then
			local createElement4 = Roact.createElement
			local v6 = {
				button = self.props.actionBarProps.button,
				buttonOverride = 0,
				icons = 0,
				iconSize = 0,
				buttonHeight = 0,
				buttonPadding = 0,
				textButtons = 0,
				enableButtonAtStart = true,
				marginOverride = 0,
				horizontalAlignment = 0,
				testId = 0
			}
			local buttonOverride

			if FFlagUIBloxEnableActionBarButtonOverride then
				buttonOverride = self.props.actionBarProps.buttonOverride
			end

			v6.buttonOverride = buttonOverride

			v6.icons = self.props.actionBarProps.icons
			v6.iconSize = self.props.actionBarProps.iconSize
			v6.buttonHeight = self.props.actionBarProps.buttonHeight
			v6.buttonPadding = self.props.actionBarProps.buttonPadding
			v6.textButtons = self.props.actionBarProps.textButtons

			v6.marginOverride = { left = 0, right = 0, top = 0, bottom = 0 }

			v6.horizontalAlignment = Enum.HorizontalAlignment.Left
			v6.testId = FFlagUIBloxAddTestIdToActionBar and "--experience-details" or nil
			actionBar = createElement4(ActionBar, v6) or nil
		end

		children.ActonBarFrame = createElement3("Frame", v5, { ActionBar = actionBar })
		local actionBarLabel

		if self.props.actionBarLabelText then
			actionBarLabel = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = self.props.actionBarLabelText,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				BackgroundTransparency = 1,
				FontFace = normalizeFontFace(p.Tokens.Typography.BodyLarge.Font),
				TextSize = p.Tokens.FontSize.FontSize_350,
				TextColor3 = p.Tokens.Color.Content.Emphasis.Color3,
				TextTransparency = p.Tokens.Color.Content.Emphasis.Transparency,
				LayoutOrder = 3,
				[Roact.Ref] = self.actionBarLabelRef
			})
		end

		children.ActionBarLabel = actionBarLabel
		local actionBarLabelImpressionsDetector

		if self.props.actionBarLabelText and self.props.renderActionBarLabelImpressionsDetector then
			actionBarLabelImpressionsDetector = self.props.renderActionBarLabelImpressionsDetector(
				self.actionBarLabelRef,
				self.props.scrollViewPositionChangedSignal
			)
		end

		children.ActionBarLabelImpressionsDetector = actionBarLabelImpressionsDetector
	end

	local element = createElement("Frame", v3, children)

	local desktopMode = {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, sideMargin),
			PaddingRight = UDim.new(0, sideMargin),
			PaddingBottom = UDim.new(0, 16)
		}),
		ContentFrame = 0
	}

	local createElement2 = Roact.createElement

	local v4 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.fromScale(0.5, 1),
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundTransparency = 1
	}
	local v5

	if self.props.renderCustomHeader then
		v5 = {
			CustomHeader = self.props.renderCustomHeader(),
			UISizeConstraint = 0
		}
	else
		v5 = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDim.new(0, itemPadding)
			}),
			ThumbnailTileFrame = self:renderThumbnail(p, v2, v, thumbnailHeight),
			InfoFrame = element,
			UISizeConstraint = 0
		}
	end

	local uiSizeConstraint

	if self.props.maxContentWidth then
		uiSizeConstraint = Roact.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(self.props.maxContentWidth, 1e999)
		})
	end

	v5.UISizeConstraint = uiSizeConstraint
	desktopMode.ContentFrame = createElement2("Frame", v4, v5)
	return desktopMode
end

function extended:renderisPhone(p)
	local thumbnailHeight = self.props.thumbnailHeight
	local v = thumbnailHeight * (self.props.thumbnailAspectRatio.X / self.props.thumbnailAspectRatio.Y)
	local sideMargin = self.props.sideMargin or 24

	if self.props.renderCustomHeader then
		return {
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, sideMargin),
				PaddingRight = UDim.new(0, sideMargin),
				PaddingBottom = UDim.new(0, 16)
			}),
			ContentFrame = Roact.createElement("Frame", {
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				BackgroundTransparency = 1
			}, {
				Content = self.props.renderCustomHeader()
			})
		}
	end

	local v2 = {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, sideMargin),
			PaddingRight = UDim.new(0, sideMargin),
			PaddingBottom = UDim.new(0, 16)
		}),
		ThumbnailTileFrame = 0
	}
	local thumbnailTileFrame

	if FFlagLuaAppFixDetailsPageThumbnailRenderInPhone then
		thumbnailTileFrame = self:renderThumbnail(p, 0, v, thumbnailHeight)
	else
		thumbnailTileFrame = self:renderThumbnail(p, v, thumbnailHeight)
	end

	v2.ThumbnailTileFrame = thumbnailTileFrame
	return v2
end

function extended:render()
	local v = self.props.deviceType == DeviceType.Phone

	local thumbnailHeight = self.props.thumbnailHeight
	local headerBarBackgroundHeight = self.props.headerBarBackgroundHeight or 80

	local gradientHeight = self.props.gradientHeight or thumbnailHeight + 16 - headerBarBackgroundHeight + 44
	local bottomMargin = self.props.bottomMargin

	return withStyle(function(p)
		local theme = p.Theme

		local createElement = Roact.createElement
		local v2 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

		local v3 = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			GradientBar = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, gradientHeight),
				BackgroundColor3 = theme.BackgroundDefault.Color,
				AnchorPoint = Vector2.new(0, 1),
				BorderSizePixel = 0,
				LayoutOrder = 1
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
				Size = UDim2.new(1, 0, 0, headerBarBackgroundHeight),
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BackgroundTransparency = theme.BackgroundDefault.Transparency,
				BorderSizePixel = 0,
				LayoutOrder = 2
			}, v and self:renderisPhone(p, thumbnailHeight) or self:renderDesktopMode(p, thumbnailHeight)),
			Padding = 0
		}
		local padding

		if bottomMargin then
			padding = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, bottomMargin),
				BackgroundTransparency = 1,
				LayoutOrder = 3
			})
		end

		v3.Padding = padding
		return createElement("Frame", v2, v3)
	end)
end

return extended
