local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local CoreGui = game:GetService("CoreGui")

local Localization = require(parent2.Localization)
local React = require(parent2.React)
local UIBlox = require(parent2.UIBlox)
local Foundation = require(parent2.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useAnalytics = require(parent.Analytics.useAnalytics)
local useLocalization = Localization.Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle

local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local EventNames = require(parent.Analytics.EventNames)

return function(p)
	local v = useAnalytics()
	local v2 = useStyle()

	local v3 = useLocalization({
		videoCTATitle = "Feature.Captures.Title.VideoCTA",
		videoEducationalText = "Feature.Captures.Label.VideoEducationalText",
		startRecording = "Feature.Captures.Control.StartRecordingVideo",
		stopRecording = "Feature.Captures.Control.StopRecordingVideo"
	})

	local state, setState = React.useState(false)

	React.useEffect(function()
		local gameOptions = settings():FindFirstChild("Game Options")
		local videoRecordingChangeRequestConnection

		if gameOptions then
			videoRecordingChangeRequestConnection = gameOptions.VideoRecordingChangeRequest:connect(function(p2)
				setState(p2)
			end)
		else
			videoRecordingChangeRequestConnection = nil
		end

		return function()
			if videoRecordingChangeRequestConnection then
				videoRecordingChangeRequestConnection:disconnect()
			end
		end
	end, { v.fireEvent })

	local onActivated = React.useCallback(function()
		if state then
			v.fireEvent(EventNames.CapturesMigratedLegacyVideoRecordDeactivated)
		else
			p.closeSettingsMenu()
			v.fireEvent(EventNames.CapturesMigratedLegacyVideoRecordActivated)
		end

		CoreGui:ToggleRecording()
	end, { v.fireEvent, state, p.closeSettingsMenu })

	local color = v2.Theme.BackgroundDefault.Color
	local transparency = v2.Theme.BackgroundDefault.Transparency

	local color2 = v2.Theme.TextDefault.Color
	local font = v2.Font.CaptionBody.Font
	local textSize = v2.Font.BaseSize * v2.Font.CaptionBody.RelativeSize

	local color3 = v2.Theme.TextEmphasis.Color
	local font2 = v2.Font.Header2.Font
	local textSize2 = v2.Font.BaseSize * v2.Font.Header2.RelativeSize

	local createElement = React.createElement
	local v4 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = color,
		BackgroundTransparency = transparency,
		BorderSizePixel = 0,
		LayoutOrder = 3,
		Size = UDim2.fromScale(1, 0)
	}

	local createElement2 = React.createElement
	local v5 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(0.7, 0)
	}
	local children2 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		Title = 0,
		EducationalLabel = 0
	}

	local createElement3 = React.createElement

	if FoundationFontFaceMigration then
		font2 = nil
	end

	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v2.Tokens.Typography.TitleLarge.Font)
	end

	children2.Title = createElement3("TextLabel", {
		BackgroundTransparency = 1,
		Font = font2,
		FontFace = fontFace,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 30),
		Text = v3.videoCTATitle,
		TextColor3 = color3,
		TextSize = textSize2,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local createElement4 = React.createElement

	if FoundationFontFaceMigration then
		font = nil
	end

	local fontFace2

	if FoundationFontFaceMigration then
		fontFace2 = normalizeFontFace(v2.Tokens.Typography.BodySmall.Font)
	end

	children2.EducationalLabel = createElement4("TextLabel", {
		BackgroundTransparency = 1,
		Font = font,
		FontFace = fontFace2,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 40),
		Text = v3.videoEducationalText,
		TextColor3 = color2,
		TextSize = textSize,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	local children = {
		TextFrame = createElement2("Frame", v5, children2),
		CapturesToggleFrame = 0
	}

	local createElement5 = React.createElement
	local v6 = {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(1, 0.5),
		Size = UDim2.fromOffset(224, 44)
	}

	local createElement6 = React.createElement
	local v7 = {
		buttonType = ButtonType.Secondary,
		onActivated = onActivated,
		size = UDim2.fromScale(1, 1),
		text = 0
	}
	local text = if state then v3.stopRecording else v3.startRecording
	v7.text = text
	children.CapturesToggleFrame = createElement5("Frame", v6, {
		RecordButton = createElement6(Button, v7)
	})
	return createElement("Frame", v4, children)
end
