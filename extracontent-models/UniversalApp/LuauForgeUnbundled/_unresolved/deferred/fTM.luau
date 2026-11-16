local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Foundation = require(CorePackages.Packages.Foundation)
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appBtidLayers = require("@luauforge/bundled/dMA").AppBtidLayers
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableAddAuthMethodPageFoundationalizeHeader = SharedFlags.FFlagEnableAddAuthMethodPageFoundationalizeHeader

local fFlagEnableAddAuthMethodPageFoundationalizeParagraph = SharedFlags.FFlagEnableAddAuthMethodPageFoundationalizeParagraph
local defineFastFlag = game:DefineFastFlag("UseLargerHeaderTextOnMultipageSignup", false)

return function(props)
	local v5 = useStyle()
	local v6 = useTokens()

	local v7 = RoactAppExperiment.useBrowserTrackerExperiment(
		{ appBtidLayers.AuthenticationStylingLayer },
		function(p2)
			local v8 = p2[appBtidLayers.AuthenticationStylingLayer] or {}
			return {
				shouldUseFoundationHeaderText = v8.shouldUseFoundationHeaderText,
				shouldUseFoundationParagraphText = v8.shouldUseFoundationParagraphText
			}
		end
	)

	local shouldUseFoundationHeaderText = fFlagEnableAddAuthMethodPageFoundationalizeHeader
		and v7.shouldUseFoundationHeaderText

	local shouldUseFoundationParagraphText = fFlagEnableAddAuthMethodPageFoundationalizeParagraph
		and v7.shouldUseFoundationParagraphText

	local v8 = if defineFastFlag then v5.Font.Header1 else v5.Font.Header2
	local createElement = React.createElement
	local v10 = {
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v11 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 8)
		}),
		TitleText = 0,
		HelpText = 0
	}
	local v12

	if shouldUseFoundationHeaderText then
		local createElement2 = React.createElement
		local v14 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = props.titleText,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			fontStyle = 0,
			LayoutOrder = 1
		}

		local v15 = if defineFastFlag then v6.Typography.HeadingMedium else v6.Typography.HeadingSmall
		v14.fontStyle = v15
		v12 = createElement2(text, v14)
	else
		local createElement2 = React.createElement
		local v14 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = props.titleText,
			TextColor3 = v5.Theme.TextEmphasis.Color,
			TextSize = v5.Font.BaseSize * v8.RelativeSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = 0,
			FontFace = 0,
			TextWrapped = true,
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}
		local v15 = if not foundationFontFaceMigration then v8.Font else nil
		v14.Font = v15
		local v16

		if foundationFontFaceMigration then
			local v18 = if defineFastFlag then v6.Typography.HeadingSmall.Font else v6.Typography.TitleLarge.Font
			v16 = normalizeFontFace(v18)
		end

		v14.FontFace = v16
		v12 = createElement2("TextLabel", v14)
	end

	v11.TitleText = v12
	local v13

	if shouldUseFoundationParagraphText then
		v13 = React.createElement(text, {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = props.helpText,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			fontStyle = v6.Typography.BodyMedium,
			LayoutOrder = 2
		})
	else
		local createElement2 = React.createElement
		local v15 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = props.helpText,
			TextColor3 = v5.Theme.TextDefault.Color,
			TextSize = v5.Font.BaseSize * v5.Font.CaptionBody.RelativeSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = 0,
			FontFace = 0,
			TextWrapped = true,
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}
		local v16 = if not foundationFontFaceMigration then v5.Font.CaptionBody.Font else nil
		v15.Font = v16

		local v17 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.BodySmall.Font) else nil
		v15.FontFace = v17
		v13 = createElement2("TextLabel", v15)
	end

	v11.HelpText = v13
	return createElement("Frame", v10, v11)
end
