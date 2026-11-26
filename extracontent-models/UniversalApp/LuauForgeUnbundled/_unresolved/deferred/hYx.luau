local module = require("@luauforge/deferred/hYy")
local useDefaultFocusBehavior = require("@luauforge/deferred/hYz").useDefaultFocusBehavior
local useDispatch = require("@luauforge/deferred/hYA").Hooks.RoactRodux.useDispatch
local useScreenSize = require("@luauforge/deferred/hYB").useScreenSize

local module2 = require("@luauforge/deferred/hYC")
local interactiveAlert = module2.App.Dialog.Alert.InteractiveAlert
local buttonType = module2.App.Button.Enum.ButtonType
local styledTextLabel = module2.App.Text.StyledTextLabel
local useDesignTokens = require("@luauforge/deferred/hYD").useDesignTokens

return function(props)
	local v5 = useScreenSize()
	local v6, v7 = useDefaultFocusBehavior()
	local v8 = useDispatch()
	local v9 = useDesignTokens(function(data)
		return {
			listPadding = data.Size.Size_400,
			thumbnailContainerTransparency = 0.92,
			thumbnailContainerRadius = data.Size.Size_300,
			bodyTextFont = data.Typography.BodyLarge,
			bodyTextColor = data.Color.Content.Default,
			buttonStackSpacing = data.Size.Size_300,
			buttonTextFont = data.Typography.BodyLarge
		}
	end)

	local v10 = module.useCallback(function()
		local createElement = module.createElement
		local v12 = {
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local v13 = {
			ListLayout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v9.listPadding)
			}),
			AvatarThumbnailContainer = module.createElement("Frame", {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, props.avatarThumbnailDisplayHeight),
				BackgroundTransparency = v9.thumbnailContainerTransparency,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0
			}, {
				UICorner = module.createElement("UICorner", {
					CornerRadius = UDim.new(0, v9.thumbnailContainerRadius)
				}),
				AvatarThumbnail = module.createElement("ImageLabel", {
					Image = props.avatarThumbnail,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Fit,
					Size = UDim2.fromScale(1, 1)
				})
			}),
			BodyText = 0
		}

		local v14 = if props.bodyText then module.createElement(styledTextLabel, {
			layoutOrder = 2,
			automaticSize = Enum.AutomaticSize.XY,
			fontStyle = v9.bodyTextFont,
			colorStyle = v9.bodyTextColor,
			text = props.bodyText,
			richText = true,
			textWrapped = true,
			textXAlignment = Enum.TextXAlignment.Center
		}) else nil
		v13.BodyText = v14
		return createElement("Frame", v12, v13)
	end, {
		props.avatarThumbnail,
		props.avatarThumbnailDisplayHeight,
		props.bodyText,
		v9
	})

	local v11 = {
		buttonType = buttonType.PrimarySystem,
		props = {
			onActivated = function()
				if props.onPrimaryButtonActivated then
					props.onPrimaryButtonActivated()
				elseif props.closeCentralOverlayThunk then
					v8(props.closeCentralOverlayThunk())
				end
			end,
			text = props.primaryButtonText,
			buttonRef = v6,
			fontStyle = v9.buttonTextFont
		}
	}

	local v12 = props.secondaryButtonText and {
		buttonType = buttonType.Secondary,
		props = {
			onActivated = function()
				if props.onSecondaryButtonActivated then
					props.onSecondaryButtonActivated()
				elseif props.closeCentralOverlayThunk then
					v8(props.closeCentralOverlayThunk())
				end
			end,
			text = props.secondaryButtonText,
			fontStyle = v9.buttonTextFont
		}
	}

	return module.createElement(interactiveAlert, {
		defaultChildRef = v7,
		screenSize = v5,
		title = props.titleText,
		middleContent = v10,
		buttonStackInfo = {
			disableGamepadRefs = true,
			marginBetween = v9.buttonStackSpacing,
			buttons = props.secondaryButtonText and { v12, v11 } or { v11 }
		}
	})
end
