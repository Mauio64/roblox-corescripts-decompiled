local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppBtidLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppBtidLayers
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableAddAuthMethodPageFoundationalizeHeader = SharedFlags.FFlagEnableAddAuthMethodPageFoundationalizeHeader
local FFlagEnableAddAuthMethodPageFoundationalizeParagraph = SharedFlags.FFlagEnableAddAuthMethodPageFoundationalizeParagraph
local v12 = game:DefineFastFlag("UseLargerHeaderTextOnMultipageSignup", false)

return function(t1: {[any]: any}) -- line: 23
	-- upvalues: useStyle (copy), useTokens (copy), RoactAppExperiment (copy), AppBtidLayers (copy), FFlagEnableAddAuthMethodPageFoundationalizeHeader (copy), FFlagEnableAddAuthMethodPageFoundationalizeParagraph (copy), v12 (copy), React (copy), FoundationText (copy)
	local v14 = useStyle()
	local v15 = useTokens()
	local v16 = RoactAppExperiment.useBrowserTrackerExperiment({ AppBtidLayers.AuthenticationStylingLayer }, function(p1) -- line: 29
		-- upvalues: AppBtidLayers (copy)
		local v21 = p1[AppBtidLayers.AuthenticationStylingLayer] or {}

		return {
			shouldUseFoundationHeaderText = v21.shouldUseFoundationHeaderText,
			shouldUseFoundationParagraphText = v21.shouldUseFoundationParagraphText
		}
	end)
	local v17 = FFlagEnableAddAuthMethodPageFoundationalizeHeader and v16.shouldUseFoundationHeaderText
	local v18 = FFlagEnableAddAuthMethodPageFoundationalizeParagraph and v16.shouldUseFoundationParagraphText
	local v19 = if not v12 then v14.Font.Header2 else v14.Font.Header1

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 8)
		}),
		TitleText = if not v17 then React.createElement("TextLabel", {
			TextWrapped = true,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = t1.titleText,
			TextColor3 = v14.Theme.TextEmphasis.Color,
			TextSize = v14.Font.BaseSize * v19.RelativeSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = v19.Font
		}) else React.createElement(FoundationText, {
			TextWrapped = true,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = t1.titleText,
			TextXAlignment = Enum.TextXAlignment.Left,
			fontStyle = if not v12 then v15.Typography.HeadingSmall else v15.Typography.HeadingMedium
		}),
		HelpText = if not v18 then React.createElement("TextLabel", {
			TextWrapped = true,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = t1.helpText,
			TextColor3 = v14.Theme.TextDefault.Color,
			TextSize = v14.Font.BaseSize * v14.Font.CaptionBody.RelativeSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = v14.Font.CaptionBody.Font
		}) else React.createElement(FoundationText, {
			TextWrapped = true,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = t1.helpText,
			TextXAlignment = Enum.TextXAlignment.Left,
			fontStyle = v15.Typography.BodyMedium
		})
	})
end
