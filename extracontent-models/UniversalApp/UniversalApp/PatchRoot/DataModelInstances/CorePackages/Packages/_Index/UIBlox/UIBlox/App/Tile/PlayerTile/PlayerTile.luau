local App = script:FindFirstAncestor("App")
local parent = App.Parent

local core = parent.Core
local parent2 = parent.Parent

local t = require(parent2.t)
local Roact = require(parent2.Roact)
local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object
local Cryo = require(parent2.Cryo)
local Dictionary = Cryo.Dictionary
local List = Cryo.List

local Images = require(App.ImageSet.Images)
local validateImageSetData = require(core.ImageSet.Validator.validateImageSetData)
local ControlState = require(core.Control.Enum.ControlState)
local withStyle = require(core.Style.withStyle)
local getContentStyle = require(core.Button.getContentStyle)
local PlayerTileButton = require(App.Tile.PlayerTile.PlayerTileButton)
local PlayerContext = require(App.Indicator.PlayerContext)
local SpringAnimatedItem = require(parent.Utility.SpringAnimatedItem)

local validateFontInfo = require(core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(parent.Core.Style.Validator.validateTypographyInfo)

local Tile = require(App.Tile.BaseTile.Tile)

local extended = Roact.PureComponent:extend("PlayerTile")

local union = t.union(t.string, validateImageSetData)
extended.validateProps = t.strictInterface({
	title = t.optional(t.string),
	subtitle = t.optional(t.string),
	subtitleFontStyle = t.optional(t.union(validateFontInfo, validateTypographyInfo)),
	hasVerifiedBadge = t.optional(t.boolean),
	Selectable = t.optional(t.boolean),
	thumbnail = t.optional(t.union(t.string, t.table)),
	buttons = t.optional(t.array(t.strictInterface({
		icon = t.optional(union),
		onActivated = t.optional(t.callback),
		isSecondary = t.optional(t.boolean),
		isDisabled = t.optional(t.boolean)
	}))),
	relevancyInfo = t.strictInterface({
		text = t.optional(t.string),
		icon = t.optional(t.union(t.string, t.table)),
		iconSize = t.optional(t.UDim2),
		iconColor = t.optional(t.Color3),
		iconTransparency = t.optional(t.number),
		onActivated = t.optional(t.callback),
		fontStyle = t.optional(t.union(validateFontInfo, validateTypographyInfo)),
		horizontalAlignment = t.optional(t.EnumItem),
		textXAlignment = t.optional(t.EnumItem)
	}),
	tileSize = t.optional(t.UDim2),
	thumbnailFrameSize = t.optional(t.UDim2),
	isCircular = t.optional(t.boolean),
	horizontalAlignment = t.optional(t.EnumItem),
	footerTopPadding = t.optional(t.integer),
	onActivated = t.optional(t.callback),
	forwardedRef = t.optional(t.table),
	openTypeFeatures = t.optional(t.string),
	isRoactGamepadEnabled = t.optional(t.boolean),
	buttonRef = t.optional(t.table)
})

extended.defaultProps = {
	buttons = {},
	relevancyInfo = {},
	tileSize = UDim2.new(0, 150, 0, 150),
	onActivated = function() end,
	Selectable = false,
	isCircular = false,
	openTypeFeatures = nil,
	isRoactGamepadEnabled = true
}

local springOptions = { dampingRatio = 1, frequency = 4 }

local v = { [ControlState.Default] = "SystemPrimaryContent" }

local component_assetsvignette_246 = Images["component_assets/vignette_246"]

local function footer(data) -- 1 equivalent call inferred from this helper
	return withStyle(function(p)
		local tokens = p.Tokens

		local assign = Object.assign
		local fontStyle

		if data.playerContext.onActivated then
			fontStyle = tokens.Typography.CaptionMedium
		else
			fontStyle = tokens.Typography.BodySmall
		end

		local v2 = assign({}, {
			fontStyle = fontStyle,
			iconTextSpacing = tokens.Size.Size_100,
			iconPadding = 0,
			iconSize = UDim2.fromOffset(tokens.Size.Size_300, tokens.Size.Size_300),
			textHeight = tokens.Size.Size_700,
			horizontalAlignment = data.horizontalAlignment,
			textXAlignment = data.textXAlignment
		}, data.playerContext)

		return Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			{
				PlayerContext = Roact.createElement(PlayerContext, v2)
			}
		)
	end)
end

local function thumbnailOverlayComponents(joined) -- 1 equivalent call inferred from this helper
	return withStyle(function(p)
		local tokens = p.Tokens

		local size_200 = tokens.Size.Size_200
		local size_200_2 = tokens.Size.Size_200
		local size_900 = tokens.Size.Size_900

		local contentStyle = getContentStyle(v, joined.controlState, p)
		local createElement = Roact.createElement
		local v2 = { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) }
		local children = {
			ButtonBackgroundGradient = not joined.isCircular and not Cryo.isEmpty(joined.buttons) and Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, size_900 + size_200 * 2),
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				LayoutOrder = 1
			}, {
				UIGradient = Roact.createElement("UIGradient", {
					Rotation = 90,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, p.Theme.BackgroundUIContrast.Color),
						ColorSequenceKeypoint.new(1, p.Theme.BackgroundUIContrast.Color)
					}),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, p.Theme.BackgroundUIContrast.Transparency)
					})
				}),
				UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) })
			}),
			HoverTransparency = 0,
			ButtonContainer = 0
		}

		local createElement2 = Roact.createElement
		local animatedImageLabel = SpringAnimatedItem.AnimatedImageLabel
		local v3 = {
			springOptions = springOptions,
			animatedValues = {
				imageTransparency = joined.mouseEntered and 0.6 or 1
			},
			mapValuesToProps = function(p2)
				return { ImageTransparency = p2.imageTransparency }
			end,
			regularProps = {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Image = component_assetsvignette_246.Image,
				ImageRectSize = component_assetsvignette_246.ImageRectSize,
				ImageRectOffset = component_assetsvignette_246.ImageRectOffset,
				ImageColor3 = contentStyle.Color,
				ImageTransparency = 0,
				LayoutOrder = 2,
				[Roact.Event.MouseEnter] = joined.hoverMouseEnter,
				[Roact.Event.MouseLeave] = joined.hoverMouseLeave
			}
		}

		local createElement3 = Roact.createElement
		local cornerRadius

		if joined.isCircular then
			cornerRadius = UDim.new(0.5, 0)
		else
			cornerRadius = UDim.new(0, 8)
		end

		children.HoverTransparency = createElement2(animatedImageLabel, v3, {
			corner = createElement3("UICorner", { CornerRadius = cornerRadius })
		})

		children.ButtonContainer = Roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 2 },
			{
				PlayerTileButtons = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Position = UDim2.new(1, 0, 1, 0),
					Size = UDim2.new(0, joined.tileSize.X.Offset - size_200 * 2, 0, size_900),
					AnchorPoint = Vector2.new(1, 1),
					LayoutOrder = 3,
					ZIndex = 2
				}, List.join(List.map(joined.buttons, function(props)
					return Roact.createElement(PlayerTileButton, {
						buttonHeight = size_900,
						outerButtonPadding = size_200,
						tileSize = joined.tileSize,
						icon = props.icon,
						isSecondary = props.isSecondary,
						isDisabled = props.isDisabled,
						onActivated = props.onActivated,
						mouseEnter = joined.hoverMouseEnter,
						mouseLeave = joined.hoverMouseLeave,
						isRoactGamepadEnabled = joined.isRoactGamepadEnabled
					})
				end), { Roact.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						Padding = UDim.new(0, size_200_2),
						FillDirection = Enum.FillDirection.Horizontal
					}) })),
				UIPadding = Roact.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, size_200),
					PaddingRight = UDim.new(0, size_200)
				})
			}
		)
		return createElement("Frame", v2, children)
	end)
end

function extended:init()
	self.firstButtonIcon = Roact.createRef()
	self.secondButtonIcon = Roact.createRef()
	self.mouseEntered = false
	self.state = { controlState = ControlState.Initialize, mouseEntered = false }

	function self.onStateChanged(p, controlState)
		self:setState({ controlState = controlState })

		if self.props.onStateChanged then
			self.props.onStateChanged(p, controlState)
		end
	end

	function self.hoverMouseEnter()
		self:setState({ mouseEntered = true })
	end

	function self.hoverMouseLeave()
		self:setState({ mouseEntered = false })
	end
end

function extended.render(data)
	local tileSize = data.props.tileSize
	local title = data.props.title
	local onActivated = data.props.onActivated
	local thumbnail = data.props.thumbnail

	return withStyle(function(p)
		local tokens = p.Tokens
		local subtitleFontStyle = data.props.subtitleFontStyle or tokens.Typography.CaptionMedium
		local footerTopPadding = data.props.footerTopPadding or tokens.Size.Size_100

		local createElement = Roact.createElement
		local forwardedRefsByRef = {
			Size = tileSize,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			[Roact.Ref] = data.props.forwardedRef
		}

		local createElement2 = Roact.createElement
		local v2 = {
			textButtonRef = data.props.buttonRef,
			footer = 0,
			Selectable = 0,
			hasRoundedCorners = true,
			innerPadding = 0,
			titleTopPadding = 0,
			subtitleTopPadding = 0,
			footerTopPadding = 0,
			name = 0,
			nameTextColor = 0,
			titleRichText = true,
			titleFontStyle = 0,
			hasVerifiedBadge = 0,
			titleTextLineCount = 1,
			subtitle = 0,
			subtitleFontStyle = 0,
			onActivated = 0,
			thumbnail = 0,
			backgroundImage = 0,
			thumbnailOverlayComponents = 0,
			addSubtitleSpace = 0,
			isCircular = 0,
			horizontalAlignment = 0,
			thumbnailFrameSize = 0,
			openTypeFeatures = 0
		}
		local playerContext

		if data.props.Selectable then
			playerContext = Dictionary.join(data.props.relevancyInfo, { Selectable = false })
		else
			playerContext = data.props.relevancyInfo
		end

		v2.footer = footer({ playerContext = playerContext, controlState = data.state.controlState }) -- inferred equivalent call

		v2.Selectable = data.props.Selectable

		v2.titleTopPadding = tokens.Size.Size_200
		v2.subtitleTopPadding = tokens.Size.Size_50
		v2.footerTopPadding = footerTopPadding
		v2.name = title
		v2.nameTextColor = tokens.Color.Content.Emphasis.Color3

		v2.titleFontStyle = tokens.Typography.TitleLarge
		v2.hasVerifiedBadge = data.props.hasVerifiedBadge

		v2.subtitle = data.props.subtitle
		v2.subtitleFontStyle = subtitleFontStyle
		v2.onActivated = onActivated
		v2.thumbnail = thumbnail
		v2.backgroundImage = Images[p.Theme.PlayerBackgroundDefault.Image]
		v2.thumbnailOverlayComponents = thumbnailOverlayComponents(Dictionary.join(data.props, { -- inferred equivalent call
			hoverMouseEnter = data.hoverMouseEnter,
			hoverMouseLeave = data.hoverMouseLeave,
			mouseEntered = data.state.mouseEntered
		}))

		v2.addSubtitleSpace = title == nil
		v2.isCircular = data.props.isCircular
		v2.horizontalAlignment = data.props.horizontalAlignment
		v2.thumbnailFrameSize = data.props.thumbnailFrameSize
		v2.openTypeFeatures = data.props.openTypeFeatures
		return createElement("Frame", forwardedRefsByRef, { Tile = createElement2(Tile, v2) })
	end)
end

return Roact.forwardRef(function(p, forwardedRef)
	return Roact.createElement(extended, Dictionary.join(p, { forwardedRef = forwardedRef }))
end)
