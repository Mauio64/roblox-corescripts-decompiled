local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local ChatActions = require(BuildExperience.Components.Chat.ChatActions)
local FFlagBuildExperienceAnswerForm = require(BuildExperience.Flags.FFlagBuildExperienceAnswerForm)
local AnswerFormContainer

if FFlagBuildExperienceAnswerForm then
	AnswerFormContainer = require(BuildExperience.Components.AnswerForm.AnswerFormContainer)
else
	AnswerFormContainer = nil
end

require(BuildExperience.Components.Chat.ChatComposer)
require(BuildExperience.Components.Library.LibraryTypes)
local ModelViewport = require(BuildExperience.Components.Library.ModelViewport)
local LibraryAudioPlayerContainer = require(BuildExperience.Components.Library.LibraryAudioPlayer.LibraryAudioPlayerContainer)
local useHardwareInsets = require(BuildExperience.Components.ChatSheet.useHardwareInsets)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary

local Image = Foundation.Image
local Skeleton = Foundation.Skeleton
local ScrollView = Foundation.ScrollView
local Text = Foundation.Text
local View = Foundation.View

local Radius = Foundation.Enums.Radius

local function LibraryDetailView(props)
	local bottom = useHardwareInsets().bottom
	local v, v2, v3

	if FFlagBuildExperienceAnswerForm then
		v = Foundation.Hooks.useScaledValue(400)
		v2, v3 = React.useBinding(0)
	else
		v = nil
		v3 = nil
	end

	local state, setState = React.useState(false)
	local onAbsoluteSizeChanged = React.useCallback(function(p)
		setState(p.AbsoluteSize.Y < 400)
	end, {})
	local ref = React.useRef(nil)
	local clone

	if props.chatActions ~= nil then
		clone = table.clone(props.chatActions)
	end

	if clone ~= nil then
		clone.textBoxRef = ref
		clone.allowsTypingWhileResponding = true

		if FFlagBuildExperienceLibrary then
			clone.onRemoveResourceAttachment = nil
		end

		local onSend = clone.onSend
		function clone.onSend()
			local v4 = onSend()

			if v4 and ref.current ~= nil then
				ref.current.releaseFocus()
			end

			return v4
		end
	end

	local v4 = FFlagBuildExperienceAnswerForm

	if v4 then
		if props.isActive == false or clone == nil then
			v4 = false
		else
			v4 = clone.answerForm ~= nil
		end
	end

	local liveModel = props.liveModel
	local title

	if liveModel == nil then
		title = props.modelName or ""
	else
		title = liveModel.displayName
	end

	local body

	if props.status == "Ready" and liveModel ~= nil then
		body = React.createElement(View, {
			tag = "col size-full clip",
			testId = "Library.Preview.ModelRegion"
		}, {
			Viewport = React.createElement(
				View,
				{
					LayoutOrder = 1,
					tag = "fill size-full-0 clip",
					testId = "Library.Preview.ViewportRegion"
				},
				{
					Model = React.createElement(ModelViewport, {
						model = liveModel.model,
						size = UDim2.fromScale(1, 1),
						backgroundTransparency = 1,
						cameraDistanceScale = 1.25,
						isInteractive = props.isActive ~= false,
						testId = "Library.Preview.Model",
						unavailableText = props.unavailableText
					})
				}
			)
		})
	elseif props.status == "Ready" and props.image ~= nil then
		if props.imageLoadFailed then
			body = React.createElement(Text, {
				Text = props.unavailableText,
				tag = "size-full-0 auto-y padding-large text-body-medium text-align-x-center content-default"
			})
		else
			body = React.createElement(Image, {
				Image = props.image,
				onLoaded = props.onImageLoaded,
				ScaleType = Enum.ScaleType.Fit,
				tag = "size-full",
				testId = "Library.Preview.Image"
			})
		end
	elseif props.status == "Ready" and props.soundId ~= nil then
		body = React.createElement(ScrollView, {
			tag = "size-full clip",
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			},
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			testId = "Library.Preview.Sound"
		}, {
			Content = React.createElement(
				View,
				{
					tag = "col align-x-center align-y-center size-full auto-y padding-x-large padding-y-medium"
				},
				{
					[props.soundId] = React.createElement(LibraryAudioPlayerContainer, {
						soundId = props.soundId,
						unavailableText = props.unavailableText,
						soundLabel = props.soundLabel,
						title = title,
						isActive = props.isActive,
						isCompact = state
					})
				}
			)
		})
	elseif props.status == "Failed" then
		body = React.createElement(Text, {
			Text = props.unavailableText,
			tag = "size-full-0 auto-y padding-large text-body-medium text-align-x-center content-default"
		})
	else
		body = React.createElement(
			View,
			{
				tag = "col align-x-center gap-large size-full-0 auto-y padding-y-xlarge",
				testId = "Library.Preview.Skeleton"
			},
			{
				Preview = React.createElement(Skeleton, {
					Size = UDim2.fromOffset(320, 320),
					radius = Radius.Medium
				})
			}
		)
	end

	local createElement = React.createElement
	local v5 = {
		onAbsolutePositionChanged = props.onPageMetricsChanged,
		onAbsoluteSizeChanged = props.onPageMetricsChanged,
		padding = {
			bottom = UDim.new(0, (math.max(props.keyboardOverlap or 0, bottom)))
		},
		tag = "col size-full",
		testId = "Library.Preview"
	}

	local v6 = {
		Content = React.createElement(View, { LayoutOrder = 1, tag = "fill size-full-0" }, {
			Body = body
		}),
		Description = 0,
		AnswerForm = 0,
		Composer = 0
	}
	local description

	if not (props.description == nil or props.status ~= "Ready") then
		description = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "col size-full-0 auto-y padding-x-xlarge padding-bottom-xlarge padding-top-medium"
			},
			{
				Text = React.createElement(Text, {
					Text = props.description,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted",
					testId = "Library.Preview.Description"
				})
			}
		)
	end

	v6.Description = description
	local answerForm

	if v4 then
		answerForm = React.createElement(ScrollView, {
			LayoutOrder = 3,
			Size = v2:map(function(p: number)
				return UDim2.new(1, 0, 0, (math.min(p, v)))
			end),
			onAbsoluteCanvasSizeChanged = function(p)
				v3(p.AbsoluteCanvasSize.Y)
			end,
			tag = "shrink size-full-0 padding-x-medium",
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(),
				ScrollingDirection = Enum.ScrollingDirection.Y
			},
			testId = "Library.Preview.AnswerFormScroll"
		}, React.createElement(AnswerFormContainer, {
			state = clone.answerForm,
			actions = clone.localToolActions,
			onSubmitText = clone.onSubmitAnswerText,
			onStop = clone.onStop,
			errorText = clone.composerErrorText,
			isReadOnly = clone.isReadOnly
		}))
	end

	v6.AnswerForm = answerForm
	local composer

	if not (clone == nil or props.isActive == false or v4) then
		composer = React.createElement(
			View,
			{
				LayoutOrder = 3,
				tag = "col size-full-0 auto-y padding-x-medium padding-bottom-medium",
				testId = "Library.Preview.Composer"
			},
			{
				Actions = React.createElement(ChatActions, clone)
			}
		)
	end

	v6.Composer = composer
	return (createElement(View, v5, v6))
end

return LibraryDetailView
