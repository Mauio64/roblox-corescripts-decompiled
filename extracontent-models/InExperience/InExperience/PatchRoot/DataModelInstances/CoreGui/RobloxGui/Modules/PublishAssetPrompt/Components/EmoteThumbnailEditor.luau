local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local EmoteUtility = require(CorePackages.Packages.Thumbnailing).EmoteUtility
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local SystemSlider = UIBlox.App.Slider.SystemSlider
local EmoteThumbnailParameters = require(script.Parent.EmoteThumbnailParameters)
local EmoteThumbnailView = require(script.Parent.EmoteThumbnailView)
local _ = {
	CurveAnimationTimeIncrements = 0.01
}
local t1 = {
	Rotation = {
		Precision = 0,
		Default = 0,
		Increments = 361,
		Range = NumberRange.new(0, 360)
	}
}
local v16 = Roact.PureComponent:extend("EmoteThumbnailEditor")

v16.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	animationClip = t.instanceIsA("AnimationClip"),
	initialThumbnailParameters = t.optional(EmoteThumbnailParameters.validate),
	closePromptCallback = t.callback,
	updateThumbnailCallback = t.callback
})

function v16.init(p1) -- line: 62
	-- upvalues: EmoteThumbnailParameters (copy), Roact (copy)
	p1:setState({
		thumbnailParameters = p1.props.initialThumbnailParameters or EmoteThumbnailParameters.defaultParameters
	})

	function p1.onCancelPressed() -- line: 70
		-- upvalues: p1 (copy)
		p1.props.closePromptCallback()
	end
	function p1.onUpdatePressed() -- line: 74
		-- upvalues: p1 (copy)
		local thumbnailParameters = p1.state.thumbnailParameters

		p1.props.updateThumbnailCallback(thumbnailParameters)
		p1.props.closePromptCallback()
	end
	function p1.onRotateChanged(p2) -- line: 80
		-- upvalues: p1 (copy)
		local v33 = table.clone(p1.state.thumbnailParameters)

		v33.thumbnailCharacterRotation = p2
		p1:updateThumbnailParameters(v33)
	end
	function p1.onKeyframeOrTimeChanged(p3) -- line: 86
		-- upvalues: p1 (copy)
		local v35 = table.clone(p1.state.thumbnailParameters)

		v35.thumbnailTime = p3
		v35.thumbnailKeyframe = p3
		p1:updateThumbnailParameters(v35)
	end

	p1.rotationSliderRef = Roact.createRef()
	p1.timeSliderRef = Roact.createRef()
	p1:updateSliderValuesForAnimationClip()
end
function v16.updateSliderValuesForAnimationClip(p4) -- line: 100
	-- upvalues: EmoteUtility (copy)
	local props = p4.props
	local n1 = nil
	local v22 = nil
	local n2 = nil

	if props.animationClip:IsA("KeyframeSequence") then
		n1 = 1
		v22 = #props.animationClip:GetKeyframes()
		n2 = 1
	elseif props.animationClip:IsA("CurveAnimation") then
		n1 = 0
		v22 = math.floor(EmoteUtility.GetCurveAnimationTimeLength(props.animationClip) / 0.01) * 0.01
		n2 = 0.01
	else
		error("Unsupported animation type:", props.animationClip.ClassName)
	end

	p4:setState({
		timeSliderMin = n1,
		timeSliderMax = v22,
		timeSliderStepInterval = n2
	})
end
function v16.updateThumbnailParameters(p5, p6) -- line: 128
	p5:setState({
		thumbnailParameters = p6
	})
end
function v16.renderMiddle(p7, p8) -- line: 134
	-- upvalues: withStyle (copy), Roact (copy), RoactGamepad (copy), EmoteThumbnailView (copy), SystemSlider (copy), t1 (copy)
	return withStyle(function(p9) -- line: 135
		-- upvalues: p7 (copy), Roact (copy), RoactGamepad (copy), EmoteThumbnailView (copy), p8 (copy), SystemSlider (copy), t1 (copy)
		local p9Font = p9.Font
		local Theme = p9.Theme
		local t2 = {}

		if p7.props.screenSize.Y > 481 then
			t2.contentSize = UDim2.new(1, 0, 0, 262)
			t2.thumbnailPosition = UDim2.new(0.5, 0, 0, 0)
			t2.thumbnailAnchorPoint = Vector2.new(0.5, 0)
			t2.leversPosition = UDim2.new(0, 0, 0, 160)
			t2.leversSize = UDim2.new(1, 0, 0, 102)
		else
			t2.contentSize = UDim2.new(1, 0, 0, 150)
			t2.thumbnailPosition = UDim2.new(0, 0, 0, 0)
			t2.thumbnailAnchorPoint = Vector2.new(0, 0)
			t2.leversPosition = UDim2.new(0, 160, 0, 0)
			t2.leversSize = UDim2.new(1, -160, 0, 102)
		end

		local thumbnailParameters = p7.state.thumbnailParameters
		local thumbnailKeyframe = thumbnailParameters.thumbnailKeyframe
		local thumbnailCharacterRotation = thumbnailParameters.thumbnailCharacterRotation

		local function getStepIntervalForOption(t3: {[any]: any}) -- line: 161
			return (t3.Range.Max - t3.Range.Min) / (t3.Increments - 1)
		end

		local createElement = Roact.createElement
		local Frame = RoactGamepad.Focusable.Frame
		local t4 = {
			Size = t2.contentSize,
			BackgroundColor3 = Color3.new(1, 0, 1),
			BackgroundTransparency = 1,
			[Roact.Ref] = p7.middleContentRef
		}
		local t5 = {}
		local createElement2 = Roact.createElement
		local t6 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}
		local t7 = {
			ThumbnailViewParent = Roact.createElement("Frame", {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				Position = t2.thumbnailPosition,
				AnchorPoint = t2.thumbnailAnchorPoint,
				Size = UDim2.new(0, 150, 0, 150),
				BackgroundColor3 = Color3.new(1, 1, 0)
			}, {
				EmoteThumbnailView = Roact.createElement(EmoteThumbnailView, {
					position = UDim2.new(0.5, 0, 0.5, 0),
					anchorPoint = Vector2.new(0.5, 0.5),
					animationClip = p7.props.animationClip,
					thumbnailParameters = p7.state.thumbnailParameters
				})
			})
		}
		local createElement3 = Roact.createElement
		local t8 = {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = t2.leversSize,
			AnchorPoint = Vector2.new(0, 0),
			Position = t2.leversPosition,
			BackgroundColor3 = Color3.new(1, 0, 0)
		}
		local t9 = {
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			FrameDescriptionLabel = Roact.createElement("TextLabel", {
				LayoutOrder = 0,
				TextSize = 12,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 15),
				Font = p9Font.Body.Font,
				Text = p8.timeLabelText,
				TextColor3 = Theme.TextDefault.Color,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			TimeSlider = Roact.createElement(SystemSlider, {
				layoutOrder = 1,
				min = p7.state.timeSliderMin,
				max = p7.state.timeSliderMax,
				stepInterval = p7.state.timeSliderStepInterval,
				value = thumbnailKeyframe,
				onValueChanged = p7.onKeyframeOrTimeChanged,
				width = UDim.new(1, 0),
				position = UDim2.new(0, 0, 0.5, 0),
				anchorPoint = Vector2.new(0, 0.5),
				NextSelectionDown = p7.rotationSliderRef,
				[Roact.Ref] = p7.timeSliderRef
			}),
			RotationDescriptionLabel = Roact.createElement("TextLabel", {
				LayoutOrder = 2,
				TextSize = 12,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 15),
				Font = p9Font.Body.Font,
				Text = p8.rotationLabelText,
				TextColor3 = Theme.TextDefault.Color,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		}
		local createElement4 = Roact.createElement
		local v55 = SystemSlider
		local t10 = {
			layoutOrder = 3,
			min = t1.Rotation.Range.Min,
			max = t1.Rotation.Range.Max
		}
		local t1Rotation = t1.Rotation

		t10.stepInterval = (t1Rotation.Range.Max - t1Rotation.Range.Min) / (t1Rotation.Increments - 1)
		t10.value = thumbnailCharacterRotation
		t10.onValueChanged = p7.onRotateChanged
		t10.width = UDim.new(1, 0)
		t10.position = UDim2.new(0, 0, 0.5, 0)
		t10.anchorPoint = Vector2.new(0, 0.5)
		t10.NextSelectionUp = p7.timeSliderRef
		t10[Roact.Ref] = p7.rotationSliderRef
		t9.RotationSlider = createElement4(v55, t10)
		t7.Levers = createElement3("Frame", t8, t9)
		t5.TopSection = createElement2("Frame", t6, t7)

		return createElement(Frame, t4, t5)
	end)
end
function v16.renderAlertLocalized(p10, p11) -- line: 258
	-- upvalues: Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	return Roact.createElement(InteractiveAlert, {
		isMiddleContentFocusable = true,
		title = p11.titleText or "",
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = p10.onCancelPressed,
						text = p11.cancelButtonText
					}
				},
				{
					isDefaultChild = false,
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p10.onUpdatePressed,
						text = p11.updateButtonText
					}
				}
			}
		},
		middleContent = function() -- line: 280
			-- upvalues: p10 (copy), p11 (copy)
			return p10:renderMiddle(p11)
		end,
		screenSize = p10.props.screenSize,
		defaultChildRef = p10.props.defaultChildRef
	})
end

local function GetLocalizedStrings() -- line: 289
	-- upvalues: RobloxTranslator (copy)
	return {
		cancelButtonText = RobloxTranslator:FormatByKey("CoreScripts.EmoteThumbnailEditor.Action.Cancel"),
		updateButtonText = RobloxTranslator:FormatByKey("CoreScripts.EmoteThumbnailEditor.Action.Update"),
		titleText = RobloxTranslator:FormatByKey("CoreScripts.EmoteThumbnailEditor.Heading.EditThumbnail"),
		rotationLabelText = RobloxTranslator:FormatByKey("CoreScripts.EmoteThumbnailEditor.Label.Rotation"),
		timeLabelText = RobloxTranslator:FormatByKey("CoreScripts.EmoteThumbnailEditor.Label.Time")
	}
end

function v16.render(p12) -- line: 301
	-- upvalues: GetLocalizedStrings (copy)
	return p12:renderAlertLocalized((GetLocalizedStrings()))
end

return v16
