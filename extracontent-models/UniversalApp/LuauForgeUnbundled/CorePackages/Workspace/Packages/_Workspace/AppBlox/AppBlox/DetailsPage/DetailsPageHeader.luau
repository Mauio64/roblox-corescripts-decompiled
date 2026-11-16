local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local withStyle = UIBlox.Core.Style.withStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local images = UIBlox.App.ImageSet.Images
local loadableImage = UIBlox.App.Loading.LoadableImage
local actionBar = UIBlox.App.Button.ActionBar

local deviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RobloxAppEnums").DeviceType

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Roact")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/t")

local DetailsPageTitleContent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/DetailsPageTitleContent")

local fFlagLuaAppFixDetailsPageThumbnailRenderInPhone = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").FFlagLuaAppFixDetailsPageThumbnailRenderInPhone

local defineFastFlag = game:DefineFastFlag("LuaAppBottomAlignDetailsHeaderInfoFrame", false)

local fFlagUIBloxEnableActionBarButtonOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").UIBlox.FFlagUIBloxEnableActionBarButtonOverride
local fFlagUIBloxAddTestIdToActionBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").UIBlox.FFlagUIBloxAddTestIdToActionBar
local defineFastFlag2 = game:DefineFastFlag("FFlagFixDetailsPageIconShadowSlicing", false)

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

function extended:renderThumbnail(p3, p4, p5, p6)
	local createElement = Roact.createElement
	local v6 = {
		Size = UDim2.fromOffset(p5, p6),
		LayoutOrder = 1,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundTransparency = 1
	}

	local v7 = {
		ThumbnailTile = Roact.createElement(loadableImage, {
			cornerRadius = UDim.new(0, 8),
			Size = UDim2.fromScale(1, 1),
			Image = self.props.thumbnailImageUrl
		}),
		DropShadow = 0
	}
	local v8

	if p4 > 0 then
		local createElement2 = Roact.createElement
		local v10 = {
			Size = UDim2.new(1, 0, 0, 28),
			Position = UDim2.fromScale(0, 1),
			BackgroundTransparency = 1,
			Image = images["component_assets/dropshadow_thumbnail_28"],
			ImageColor3 = p3.Theme.DropShadow.Color,
			ImageTransparency = p3.Theme.DropShadow.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = 0
		}

		local v11 = if defineFastFlag2 then Rect.new(32, 0, 33, 1) else Rect.new(32, 0, 33, 28)
		v10.SliceCenter = v11
		v8 = createElement2(imageSetLabel, v10)
	end

	v7.DropShadow = v8
	return createElement("Frame", v6, v7)
end

function extended:renderDesktopMode(p2)
	local thumbnailHeight = self.props.thumbnailHeight
	local v5 = thumbnailHeight * (self.props.thumbnailAspectRatio.X / self.props.thumbnailAspectRatio.Y)
	local sideMargin = self.props.sideMargin or 48
	local itemPadding = self.props.itemPadding or 24

	local v6 = self.props.thumbnailShadowHeight == nil and 28 or self.props.thumbnailShadowHeight

	local createElement = Roact.createElement

	local v8 = {
		Size = UDim2.new(1, -(v5 + sideMargin * 2), 1, 0),
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
		local v10 = {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = 0,
			Padding = 0
		}

		local v11 = if defineFastFlag then Enum.VerticalAlignment.Bottom else Enum.VerticalAlignment.Top
		v10.VerticalAlignment = v11

		v10.Padding = UDim.new(0, 16)
		children.Layout = createElement2("UIListLayout", v10)

		children.TitleInfo = Roact.createElement(DetailsPageTitleContent, {
			titleText = self.props.titleText,
			subTitleText = self.props.subTitleText,
			renderInfoContent = self.props.renderInfoContent,
			verticalAlignment = Enum.VerticalAlignment.Top,
			layoutOrder = 1
		})

		local createElement3 = Roact.createElement
		local v13 = {
			Size = UDim2.fromOffset(self.props.actionBarWidth, self.props.actionBarHeight),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}
		local v15

		if self.props.actionBarProps then
			local createElement4 = Roact.createElement
			local v17 = {
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

			local v18 = if fFlagUIBloxEnableActionBarButtonOverride then self.props.actionBarProps.buttonOverride else nil
			v17.buttonOverride = v18

			v17.icons = self.props.actionBarProps.icons
			v17.iconSize = self.props.actionBarProps.iconSize
			v17.buttonHeight = self.props.actionBarProps.buttonHeight
			v17.buttonPadding = self.props.actionBarProps.buttonPadding
			v17.textButtons = self.props.actionBarProps.textButtons

			v17.marginOverride = { left = 0, right = 0, top = 0, bottom = 0 }

			v17.horizontalAlignment = Enum.HorizontalAlignment.Left
			v17.testId = fFlagUIBloxAddTestIdToActionBar and "--experience-details" or nil
			v15 = createElement4(actionBar, v17) or nil
		end

		children.ActonBarFrame = createElement3("Frame", v13, { ActionBar = v15 })
		local v16

		if self.props.actionBarLabelText then
			local createElement4 = Roact.createElement
			local actionBarLabelRefsByRef = {}
			actionBarLabelRefsByRef.Size = UDim2.new(1, 0, 0, 0)
			actionBarLabelRefsByRef.AutomaticSize = Enum.AutomaticSize.Y
			actionBarLabelRefsByRef.Text = self.props.actionBarLabelText
			actionBarLabelRefsByRef.TextXAlignment = Enum.TextXAlignment.Left
			actionBarLabelRefsByRef.TextWrapped = true
			actionBarLabelRefsByRef.BackgroundTransparency = 1
			local v18 = if not foundationFontFaceMigration then p2.Tokens.Typography.BodyLarge.Font else nil
			actionBarLabelRefsByRef.Font = v18

			local v19 = if foundationFontFaceMigration then normalizeFontFace(p2.Tokens.Typography.BodyLarge.Font) else nil
			actionBarLabelRefsByRef.FontFace = v19

			actionBarLabelRefsByRef.TextSize = p2.Tokens.FontSize.FontSize_350
			actionBarLabelRefsByRef.TextColor3 = p2.Tokens.Color.Content.Emphasis.Color3
			actionBarLabelRefsByRef.TextTransparency = p2.Tokens.Color.Content.Emphasis.Transparency
			actionBarLabelRefsByRef.LayoutOrder = 3
			actionBarLabelRefsByRef[Roact.Ref] = self.actionBarLabelRef
			v16 = createElement4("TextLabel", actionBarLabelRefsByRef)
		end

		children.ActionBarLabel = v16

		local v17 = if self.props.actionBarLabelText and self.props.renderActionBarLabelImpressionsDetector then self.props.renderActionBarLabelImpressionsDetector(
			self.actionBarLabelRef,
			self.props.scrollViewPositionChangedSignal
		) else nil
		children.ActionBarLabelImpressionsDetector = v17
	end

	local element = createElement("Frame", v8, children)

	local desktopMode = {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, sideMargin),
			PaddingRight = UDim.new(0, sideMargin),
			PaddingBottom = UDim.new(0, 16)
		}),
		ContentFrame = 0
	}

	local createElement2 = Roact.createElement

	local v10 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.fromScale(0.5, 1),
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundTransparency = 1
	}
	local v11

	if self.props.renderCustomHeader then
		v11 = {
			CustomHeader = self.props.renderCustomHeader(),
			UISizeConstraint = 0
		}
	else
		v11 = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDim.new(0, itemPadding)
			}),
			ThumbnailTileFrame = self:renderThumbnail(p2, v6, v5, thumbnailHeight),
			InfoFrame = element,
			UISizeConstraint = 0
		}
	end

	local v12 = if self.props.maxContentWidth then Roact.createElement("UISizeConstraint", {
		MaxSize = Vector2.new(self.props.maxContentWidth, 1e999)
	}) else nil
	v11.UISizeConstraint = v12
	desktopMode.ContentFrame = createElement2("Frame", v10, v11)
	return desktopMode
end

function extended:renderisPhone(p2)
	local thumbnailHeight = self.props.thumbnailHeight
	local v5 = thumbnailHeight * (self.props.thumbnailAspectRatio.X / self.props.thumbnailAspectRatio.Y)
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

	local v6 = {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, sideMargin),
			PaddingRight = UDim.new(0, sideMargin),
			PaddingBottom = UDim.new(0, 16)
		}),
		ThumbnailTileFrame = 0
	}

	local v7 = if fFlagLuaAppFixDetailsPageThumbnailRenderInPhone then self:renderThumbnail(p2, 0, v5, thumbnailHeight) else self:renderThumbnail(p2, v5, thumbnailHeight)
	v6.ThumbnailTileFrame = v7
	return v6
end

function extended:render()
	local v5 = self.props.deviceType == deviceType.Phone

	local thumbnailHeight = self.props.thumbnailHeight
	local headerBarBackgroundHeight = self.props.headerBarBackgroundHeight or 80

	local gradientHeight = self.props.gradientHeight
		or thumbnailHeight + 16 - headerBarBackgroundHeight + 44
	local bottomMargin = self.props.bottomMargin

	return withStyle(function(p2)
		local theme = p2.Theme

		local createElement = Roact.createElement
		local v7 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

		local v8 = {
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
			}, v5 and self:renderisPhone(p2, thumbnailHeight) or self:renderDesktopMode(p2, thumbnailHeight)),
			Padding = 0
		}

		local v9 = if bottomMargin then Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, bottomMargin),
			BackgroundTransparency = 1,
			LayoutOrder = 3
		}) else nil
		v8.Padding = v9
		return createElement("Frame", v7, v8)
	end)
end

return extended
