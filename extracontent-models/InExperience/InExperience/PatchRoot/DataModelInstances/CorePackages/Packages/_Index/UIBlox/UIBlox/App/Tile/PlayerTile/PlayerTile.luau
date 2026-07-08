local App = script:FindFirstAncestor("App")
local AppParent = App.Parent
local Core = AppParent.Core
local AppParentParent = AppParent.Parent
local t = require(AppParentParent.t)
local Roact = require(AppParentParent.Roact)
local Object = require(AppParentParent.LuauPolyfill).Object
local Cryo = require(AppParentParent.Cryo)
local Dictionary = Cryo.Dictionary
local List = Cryo.List
local Images = require(App.ImageSet.Images)
local validateImageSetData = require(Core.ImageSet.Validator.validateImageSetData)
local ControlState = require(Core.Control.Enum.ControlState)
local withStyle = require(Core.Style.withStyle)
local getContentStyle = require(Core.Button.getContentStyle)
local PlayerTileButton = require(App.Tile.PlayerTile.PlayerTileButton)
local PlayerContext = require(App.Indicator.PlayerContext)
local SpringAnimatedItem = require(AppParent.Utility.SpringAnimatedItem)
local validateFontInfo = require(Core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(AppParent.Core.Style.Validator.validateTypographyInfo)
local Tile = require(App.Tile.BaseTile.Tile)
local v22 = Roact.PureComponent:extend("PlayerTile")
local v23 = t.union(t.string, validateImageSetData)

v22.validateProps = t.strictInterface({
	title = t.optional(t.string),
	subtitle = t.optional(t.string),
	subtitleFontStyle = t.optional(t.union(validateFontInfo, validateTypographyInfo)),
	hasVerifiedBadge = t.optional(t.boolean),
	Selectable = t.optional(t.boolean),
	thumbnail = t.optional(t.union(t.string, t.table)),
	buttons = t.optional(t.array(t.strictInterface({
		icon = t.optional(v23),
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
v22.defaultProps = {
	Selectable = false,
	isCircular = false,
	openTypeFeatures = nil,
	isRoactGamepadEnabled = true,
	buttons = {},
	relevancyInfo = {},
	tileSize = UDim2.new(0, 150, 0, 150),
	onActivated = function() -- line: 88
	end
}

local t1 = {
	dampingRatio = 1,
	frequency = 4
}
local t2 = {
	[ControlState.Default] = "SystemPrimaryContent"
}
local v26 = Images["component_assets/vignette_246"]

local function footer(p1) -- line: 107
	-- upvalues: withStyle (copy), Object (copy), Roact (copy), PlayerContext (copy)
	return withStyle(function(p2) -- line: 108
		-- upvalues: Object (copy), p1 (copy), Roact (copy), PlayerContext (copy)
		local Tokens = p2.Tokens
		local v41 = Object.assign({}, {
			iconPadding = 0,
			fontStyle = if not p1.playerContext.onActivated then Tokens.Semantic.Typography.CaptionBody else Tokens.Semantic.Typography.CaptionHeader,
			iconTextSpacing = Tokens.Global.Space_50,
			iconSize = UDim2.fromOffset(Tokens.Global.Size_150, Tokens.Global.Size_150),
			textHeight = Tokens.Global.Size_350,
			horizontalAlignment = p1.horizontalAlignment,
			textXAlignment = p1.textXAlignment
		}, p1.playerContext)

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			PlayerContext = Roact.createElement(PlayerContext, v41)
		})
	end)
end
local function thumbnailOverlayComponents(p3) -- line: 137
	-- upvalues: withStyle (copy), getContentStyle (copy), t2 (copy), Roact (copy), Cryo (copy), SpringAnimatedItem (copy), t1 (copy), v26 (copy), List (copy), PlayerTileButton (copy)
	return withStyle(function(p4) -- line: 138
		-- upvalues: getContentStyle (copy), t2 (copy), p3 (copy), Roact (copy), Cryo (copy), SpringAnimatedItem (copy), t1 (copy), v26 (copy), List (copy), PlayerTileButton (copy)
		local Tokens = p4.Tokens
		local Space_100 = Tokens.Global.Space_100
		local Space_100_2 = Tokens.Global.Space_100
		local Size_450 = Tokens.Global.Size_450
		local v47 = getContentStyle(t2, p3.controlState, p4)

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			ButtonBackgroundGradient = not p3.isCircular and (not Cryo.isEmpty(p3.buttons) and Roact.createElement("Frame", {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, Size_450 + Space_100 * 2),
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0)
			}, {
				UIGradient = Roact.createElement("UIGradient", {
					Rotation = 90,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, p4.Theme.BackgroundUIContrast.Color),
						ColorSequenceKeypoint.new(1, p4.Theme.BackgroundUIContrast.Color)
					}),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, p4.Theme.BackgroundUIContrast.Transparency)
					})
				}),
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 8)
				})
			})),
			HoverTransparency = Roact.createElement(SpringAnimatedItem.AnimatedImageLabel, {
				springOptions = t1,
				animatedValues = {
					imageTransparency = not p3.mouseEntered and 1 or 0.6
				},
				mapValuesToProps = function(p5) -- line: 177
					return {
						ImageTransparency = p5.imageTransparency
					}
				end,
				regularProps = {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Image = v26.Image,
					ImageRectSize = v26.ImageRectSize,
					ImageRectOffset = v26.ImageRectOffset,
					ImageColor3 = v47.Color,
					ImageTransparency = 0,
					LayoutOrder = 2,
					[Roact.Event.MouseEnter] = p3.hoverMouseEnter,
					[Roact.Event.MouseLeave] = p3.hoverMouseLeave
				}
			}, {
				corner = Roact.createElement("UICorner", {
					CornerRadius = if not p3.isCircular then UDim.new(0, 8) else UDim.new(0.5, 0)
				})
			}),
			ButtonContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				PlayerTileButtons = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					ZIndex = 2,
					Position = UDim2.new(1, 0, 1, 0),
					Size = UDim2.new(0, p3.tileSize.X.Offset - Space_100 * 2, 0, Size_450),
					AnchorPoint = Vector2.new(1, 1)
				}, List.join(List.map(p3.buttons, function(p6) -- line: 215
					-- upvalues: Roact (copy), PlayerTileButton (copy), Size_450 (copy), Space_100 (copy), p3 (copy)
					return Roact.createElement(PlayerTileButton, {
						buttonHeight = Size_450,
						outerButtonPadding = Space_100,
						tileSize = p3.tileSize,
						icon = p6.icon,
						isSecondary = p6.isSecondary,
						isDisabled = p6.isDisabled,
						onActivated = p6.onActivated,
						mouseEnter = p3.hoverMouseEnter,
						mouseLeave = p3.hoverMouseLeave,
						isRoactGamepadEnabled = p3.isRoactGamepadEnabled
					})
				end), { Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					Padding = UDim.new(0, Space_100_2),
					FillDirection = Enum.FillDirection.Horizontal
				}) })),
				UIPadding = Roact.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, Space_100),
					PaddingRight = UDim.new(0, Space_100)
				})
			})
		})
	end)
end

function v22.init(p7) -- line: 247
	-- upvalues: Roact (copy), ControlState (copy)
	p7.firstButtonIcon = Roact.createRef()
	p7.secondButtonIcon = Roact.createRef()
	p7.mouseEntered = false
	p7.state = {
		mouseEntered = false,
		controlState = ControlState.Initialize
	}

	function p7.onStateChanged(p8, p9) -- line: 256
		-- upvalues: p7 (copy)
		p7:setState({
			controlState = p9
		})

		if p7.props.onStateChanged then
			p7.props.onStateChanged(p8, p9)
		end
	end
	function p7.hoverMouseEnter() -- line: 265
		-- upvalues: p7 (copy)
		p7:setState({
			mouseEntered = true
		})
	end
	function p7.hoverMouseLeave() -- line: 271
		-- upvalues: p7 (copy)
		p7:setState({
			mouseEntered = false
		})
	end
end
function v22.render(p10) -- line: 278
	-- upvalues: withStyle (copy), Roact (copy), Tile (copy), Dictionary (copy), Object (copy), PlayerContext (copy), Images (copy), getContentStyle (copy), t2 (copy), Cryo (copy), SpringAnimatedItem (copy), t1 (copy), v26 (copy), List (copy), PlayerTileButton (copy)
	local tileSize = p10.props.tileSize
	local title = p10.props.title
	local onActivated = p10.props.onActivated
	local thumbnail = p10.props.thumbnail

	return withStyle(function(p11) -- line: 284
		-- upvalues: p10 (copy), Roact (copy), tileSize (copy), Tile (copy), Dictionary (copy), withStyle (copy), Object (copy), PlayerContext (copy), title (copy), onActivated (copy), thumbnail (copy), Images (copy), getContentStyle (copy), t2 (copy), Cryo (copy), SpringAnimatedItem (copy), t1 (copy), v26 (copy), List (copy), PlayerTileButton (copy)
		local Tokens = p11.Tokens
		local v52 = p10.props.subtitleFontStyle or Tokens.Semantic.Typography.CaptionHeader
		local v53 = p10.props.footerTopPadding or Tokens.Global.Space_50
		local createElement = Roact.createElement
		local t3 = {
			Size = tileSize,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			[Roact.Ref] = p10.props.forwardedRef
		}
		local t4 = {}
		local createElement2 = Roact.createElement
		local v58 = Tile
		local t5 = {
			hasRoundedCorners = true,
			innerPadding = 0,
			titleRichText = true,
			titleTextLineCount = 1,
			textButtonRef = p10.props.buttonRef
		}
		local t6 = {
			playerContext = if not p10.props.Selectable then p10.props.relevancyInfo else Dictionary.join(p10.props.relevancyInfo, {
				Selectable = false
			}),
			controlState = p10.state.controlState
		}

		t5.footer = withStyle(function(p12) -- line: 108
			-- upvalues: Object (copy), t6 (copy), Roact (copy), PlayerContext (copy)
			local Tokens2 = p12.Tokens
			local v66 = Object.assign({}, {
				iconPadding = 0,
				fontStyle = if not t6.playerContext.onActivated then Tokens2.Semantic.Typography.CaptionBody else Tokens2.Semantic.Typography.CaptionHeader,
				iconTextSpacing = Tokens2.Global.Space_50,
				iconSize = UDim2.fromOffset(Tokens2.Global.Size_150, Tokens2.Global.Size_150),
				textHeight = Tokens2.Global.Size_350,
				horizontalAlignment = t6.horizontalAlignment,
				textXAlignment = t6.textXAlignment
			}, t6.playerContext)

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				PlayerContext = Roact.createElement(PlayerContext, v66)
			})
		end)
		t5.Selectable = p10.props.Selectable
		t5.titleTopPadding = Tokens.Global.Space_100
		t5.subtitleTopPadding = Tokens.Global.Space_25
		t5.footerTopPadding = v53
		t5.name = title
		t5.nameTextColor = Tokens.Semantic.Color.Text.Emphasis.Color3
		t5.titleFontStyle = Tokens.Semantic.Typography.Subheader
		t5.hasVerifiedBadge = p10.props.hasVerifiedBadge
		t5.subtitle = p10.props.subtitle
		t5.subtitleFontStyle = v52
		t5.onActivated = onActivated
		t5.thumbnail = thumbnail
		t5.backgroundImage = Images[p11.Theme.PlayerBackgroundDefault.Image]

		local v61 = Dictionary.join(p10.props, {
			hoverMouseEnter = p10.hoverMouseEnter,
			hoverMouseLeave = p10.hoverMouseLeave,
			mouseEntered = p10.state.mouseEntered
		})

		t5.thumbnailOverlayComponents = withStyle(function(p13) -- line: 138
			-- upvalues: getContentStyle (copy), t2 (copy), v61 (copy), Roact (copy), Cryo (copy), SpringAnimatedItem (copy), t1 (copy), v26 (copy), List (copy), PlayerTileButton (copy)
			local Tokens3 = p13.Tokens
			local Space_100 = Tokens3.Global.Space_100
			local Space_100_3 = Tokens3.Global.Space_100
			local Size_450 = Tokens3.Global.Size_450
			local v72 = getContentStyle(t2, v61.controlState, p13)

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				ButtonBackgroundGradient = not v61.isCircular and (not Cryo.isEmpty(v61.buttons) and Roact.createElement("Frame", {
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, Size_450 + Space_100 * 2),
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0, 0, 1, 0)
				}, {
					UIGradient = Roact.createElement("UIGradient", {
						Rotation = 90,
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, p13.Theme.BackgroundUIContrast.Color),
							ColorSequenceKeypoint.new(1, p13.Theme.BackgroundUIContrast.Color)
						}),
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 1),
							NumberSequenceKeypoint.new(1, p13.Theme.BackgroundUIContrast.Transparency)
						})
					}),
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 8)
					})
				})),
				HoverTransparency = Roact.createElement(SpringAnimatedItem.AnimatedImageLabel, {
					springOptions = t1,
					animatedValues = {
						imageTransparency = not v61.mouseEntered and 1 or 0.6
					},
					mapValuesToProps = function(p14) -- line: 177
						return {
							ImageTransparency = p14.imageTransparency
						}
					end,
					regularProps = {
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Image = v26.Image,
						ImageRectSize = v26.ImageRectSize,
						ImageRectOffset = v26.ImageRectOffset,
						ImageColor3 = v72.Color,
						ImageTransparency = 0,
						LayoutOrder = 2,
						[Roact.Event.MouseEnter] = v61.hoverMouseEnter,
						[Roact.Event.MouseLeave] = v61.hoverMouseLeave
					}
				}, {
					corner = Roact.createElement("UICorner", {
						CornerRadius = if not v61.isCircular then UDim.new(0, 8) else UDim.new(0.5, 0)
					})
				}),
				ButtonContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					ZIndex = 2,
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					PlayerTileButtons = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 3,
						ZIndex = 2,
						Position = UDim2.new(1, 0, 1, 0),
						Size = UDim2.new(0, v61.tileSize.X.Offset - Space_100 * 2, 0, Size_450),
						AnchorPoint = Vector2.new(1, 1)
					}, List.join(List.map(v61.buttons, function(p15) -- line: 215
						-- upvalues: Roact (copy), PlayerTileButton (copy), Size_450 (copy), Space_100 (copy), v61 (copy)
						return Roact.createElement(PlayerTileButton, {
							buttonHeight = Size_450,
							outerButtonPadding = Space_100,
							tileSize = v61.tileSize,
							icon = p15.icon,
							isSecondary = p15.isSecondary,
							isDisabled = p15.isDisabled,
							onActivated = p15.onActivated,
							mouseEnter = v61.hoverMouseEnter,
							mouseLeave = v61.hoverMouseLeave,
							isRoactGamepadEnabled = v61.isRoactGamepadEnabled
						})
					end), { Roact.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						Padding = UDim.new(0, Space_100_3),
						FillDirection = Enum.FillDirection.Horizontal
					}) })),
					UIPadding = Roact.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, Space_100),
						PaddingRight = UDim.new(0, Space_100)
					})
				})
			})
		end)
		t5.addSubtitleSpace = title == nil
		t5.isCircular = p10.props.isCircular
		t5.horizontalAlignment = p10.props.horizontalAlignment
		t5.thumbnailFrameSize = p10.props.thumbnailFrameSize
		t5.openTypeFeatures = p10.props.openTypeFeatures
		t4.Tile = createElement2(v58, t5)

		return createElement("Frame", t3, t4)
	end)
end

return Roact.forwardRef(function(p16, p17) -- line: 337
	-- upvalues: Roact (copy), v22 (copy), Dictionary (copy)
	return Roact.createElement(v22, Dictionary.join(p16, {
		forwardedRef = p17
	}))
end)
