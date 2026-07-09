local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local CoreGui = game:GetService("CoreGui")
local Localization = require(ParentParentParent.Localization)
local React = require(ParentParentParent.React)
local UIBlox = require(ParentParentParent.UIBlox)
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local useLocalization = Localization.Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local EventNames = require(ParentParent.Analytics.EventNames)
local v13 = game:DefineFastFlag("CapturesAddLegacyVideoRecordingLogging_v2", false)

return function(t1: {[any]: any}) -- line: 32
	-- upvalues: useAnalytics (copy), useStyle (copy), useLocalization (copy), React (copy), v13 (copy), EventNames (copy), CoreGui (copy), Button (copy), ButtonType (copy)
	local v15 = useAnalytics()
	local v16 = useStyle()
	local v17 = useLocalization({
		videoCTATitle = "Feature.Captures.Title.VideoCTA",
		videoEducationalText = "Feature.Captures.Label.VideoEducationalText",
		startRecording = "Feature.Captures.Control.StartRecordingVideo",
		stopRecording = "Feature.Captures.Control.StopRecordingVideo"
	})
	local v18, v19 = React.useState(false)
	local v20 = React.useRef(nil)

	React.useEffect(function() -- line: 46
		-- upvalues: v13 (copy), v20 (copy), v15 (copy), EventNames (copy), v19 (copy)
		local u30 = nil
		local v31 = settings():FindFirstChild("Game Options")

		if v31 then
			u30 = v31.VideoRecordingChangeRequest:connect(function(p1) -- line: 50
				-- upvalues: v13 (copy), v20 (copy), v15 (copy), EventNames (copy), v19 (copy)
				if v13 then
					if p1 then
						v20.current = os.clock()
						v15.fireEvent(EventNames.CapturesLegacyVideoRecordBeginSignalFired)
					else
						if v20.current then
							local v33 = os.clock() - v20.current

							v15.fireEvent(EventNames.CapturesLegacyVideoRecordingDuration, {
								statValue = v33
							})
						end

						v15.fireEvent(EventNames.CapturesLegacyVideoRecordEndSignalFired)
					end
				end

				v19(p1)
			end)
		end

		return function() -- line: 70
			-- upvalues: u30 (ref)
			if u30 then
				u30:disconnect()
			end
		end
	end, { v15.fireEvent })

	local v21 = React.useCallback(function() -- line: 77
		-- upvalues: v18 (copy), t1 (copy), v15 (copy), EventNames (copy), CoreGui (copy)
		if not v18 then
			t1.closeSettingsMenu()
			v15.fireEvent(EventNames.CapturesMigratedLegacyVideoRecordActivated)
		else
			v15.fireEvent(EventNames.CapturesMigratedLegacyVideoRecordDeactivated)
		end

		CoreGui:ToggleRecording()
	end, {
		v15.fireEvent,
		v18,
		t1.closeSettingsMenu
	})
	local BackgroundDefaultColor = v16.Theme.BackgroundDefault.Color
	local BackgroundDefaultTransparency = v16.Theme.BackgroundDefault.Transparency
	local TextDefaultColor = v16.Theme.TextDefault.Color
	local CaptionBodyFont = v16.Font.CaptionBody.Font
	local v26 = v16.Font.BaseSize * v16.Font.CaptionBody.RelativeSize
	local TextEmphasisColor = v16.Theme.TextEmphasis.Color
	local Header2Font = v16.Font.Header2.Font
	local v29 = v16.Font.BaseSize * v16.Font.Header2.RelativeSize

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		LayoutOrder = 3,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = BackgroundDefaultColor,
		BackgroundTransparency = BackgroundDefaultTransparency,
		Size = UDim2.fromScale(1, 0)
	}, {
		TextFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(0.7, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			Title = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Font = Header2Font,
				Size = UDim2.new(1, 0, 0, 30),
				Text = v17.videoCTATitle,
				TextColor3 = TextEmphasisColor,
				TextSize = v29,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			EducationalLabel = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				TextWrapped = true,
				Font = CaptionBodyFont,
				Size = UDim2.new(1, 0, 0, 40),
				Text = v17.videoEducationalText,
				TextColor3 = TextDefaultColor,
				TextSize = v26,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		}),
		CapturesToggleFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.fromScale(1, 0.5),
			Size = UDim2.fromOffset(224, 44)
		}, {
			RecordButton = React.createElement(Button, {
				buttonType = ButtonType.Secondary,
				onActivated = v21,
				size = UDim2.fromScale(1, 1),
				text = if not v18 then v17.startRecording else v17.stopRecording
			})
		})
	})
end
