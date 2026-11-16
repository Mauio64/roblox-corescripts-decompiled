local module = require("@luauforge/bundled/hBF")
local module2 = require("@luauforge/bundled/hBM")
local iconButton = module2.App.Button.IconButton
local iconSize = module2.App.Constant.IconSize
local images = module2.App.ImageSet.Images
local textButton = module2.App.Button.TextButton
local useStyle = module2.Core.Style.useStyle
local styledTextLabel = module2.App.Text.StyledTextLabel

local text = require("@luauforge/bundled/hBN").Text
local getFFlagEnableSignupFoundationText = require("@luauforge/bundled/hBO").GetFFlagEnableSignupFoundationText

local useDesignTokens = require("@luauforge/bundled/hBP").useDesignTokens
local useLocalization = require("@luauforge/bundled/hBQ").Hooks.useLocalization
require("@luauforge/bundled/hBB")
require("@luauforge/bundled/hBR")
local module3 = require("@luauforge/bundled/hBE")

local function FullPageNavigationHeader(props)
	local v5 = useLocalization({
		headingText = props.headingTextKey,
		titleText = props.titleTextKey,
		bodyText = props.bodyTextKey,
		ixpTitleText = props.ixpTitleTextKey,
		ixpBodyText = props.ixpBodyTextKey,
		skipText = props.skipProps.skipButtonTextKey
	})

	local v6 = v5.titleText
	local v7 = v5.bodyText

	if type(v5.ixpTitleText) == "string" and #v5.ixpTitleText > 0 then
		v6 = v5.ixpTitleText
	end

	if type(v5.ixpBodyText) == "string" and #v5.ixpBodyText > 0 then
		v7 = v5.ixpBodyText
	end

	local v8 = useStyle()
	local activationFramework = useDesignTokens().LuaApps.ActivationFramework

	local activationFrameworkState = module.useContext(module3).activationFrameworkState

	local function onActivated()
		if activationFrameworkState.isLoading then
			return
		end

		props.backProps.onBack()
	end

	local function onActivated2()
		if activationFrameworkState.isLoading then
			return
		end

		props.skipProps.onSkip()
	end

	local v9

	if props.skipProps.shouldShowSkipButton then
		v9 = module.createElement(textButton, {
				text = v5.skipText,
				onActivated = onActivated2,
				Size = UDim2.new(1, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.XY
			})
			or nil
	end

	local v10

	if props.backProps.shouldShowBackButton then
		v10 = module.createElement(iconButton, {
				iconSize = iconSize.Medium,
				icon = images[props.backProps.icon],
				onActivated = onActivated
			})
			or nil
	end

	local function fn()
		if props.headingTextKey == nil then
			return nil
		end

		return module.createElement(styledTextLabel, {
			text = v5.headingText,
			fontStyle = v8.Font.Header1,
			colorStyle = v8.Theme.TextEmphasis,
			textXAlignment = Enum.TextXAlignment.Center,
			textYAlignment = Enum.TextYAlignment.Center
		})
	end

	local createElement = module.createElement
	local v12 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}
	local v13 = {
		Layout = module.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 10)
		}),
		TopRow = module.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, activationFramework.headerIconSize + 8),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1
		}, {
			BackButton = module.createElement("Frame", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, -8, 0.5, 0),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				BorderSizePixel = 0,
				LayoutOrder = 1
			}, { BackButtonContent = v10 }),
			HeadingFrame = module.createElement("Frame", {
				LayoutOrder = 2,
				Size = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AutomaticSize = Enum.AutomaticSize.X
			}, { HeadingTextContent = fn() }),
			SkipButton = module.createElement("Frame", {
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(1, 0.5),
				AutomaticSize = Enum.AutomaticSize.XY,
				BorderSizePixel = 0,
				LayoutOrder = 3
			}, { SkipButtonContent = v9 })
		}),
		BottomRow = 0
	}

	local createElement2 = module.createElement
	local v15 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 2
	}

	local v16 = {
		Layout = module.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 5)
		}),
		Title = 0,
		Body = 0
	}

	local v17 = if getFFlagEnableSignupFoundationText() then module.createElement(text, {
		Text = v6,
		fontStyle = { LineHeight = 1 },
		TextWrapped = true,
		tag = "text-heading-medium text-align-x-left auto-xy content-emphasis"
	}) else module.createElement(styledTextLabel, {
		text = v6,
		fontStyle = v8.Font.Title,
		colorStyle = v8.Theme.TextEmphasis,
		textWrapped = true,
		automaticSize = Enum.AutomaticSize.XY,
		lineHeight = 1
	})
	v16.Title = v17

	local v18 = if getFFlagEnableSignupFoundationText() then module.createElement(text, {
		Text = v7,
		fontStyle = { LineHeight = 1 },
		tag = "text-body-medium text-align-x-left auto-xy content-default",
		TextWrapped = true
	}) else module.createElement(styledTextLabel, {
		text = v7,
		fontStyle = v8.Font.Body,
		colorStyle = v8.Theme.TextEmphasis,
		automaticSize = Enum.AutomaticSize.XY,
		textWrapped = true,
		lineHeight = 1
	})
	v16.Body = v18
	v13.BottomRow = createElement2("Frame", v15, v16)
	return createElement("Frame", v12, v13)
end

return FullPageNavigationHeader
