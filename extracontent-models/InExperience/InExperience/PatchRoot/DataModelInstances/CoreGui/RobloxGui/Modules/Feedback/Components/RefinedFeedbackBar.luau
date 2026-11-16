local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local parent = script.Parent.Parent

local ShowHelpModalThunk = require(parent.Thunks.ShowHelpModalThunk)

local Localization = require(CorePackages.Workspace.Packages.Localization)
local withLocalization = Localization.withLocalization

local FeedbackBarHint = require(script.Parent.FeedbackBarHint)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)

local withStyle = UIBlox.Core.Style.withStyle
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local extended = Roact.PureComponent:extend("RefinedFeedbackBar")

local function GetTextSize(...)
	return TextService:GetTextSize(...) + Vector2.new(2, 2)
end

local strictInterface = t.strictInterface({ text = t.string })

extended.validateProps = t.strictInterface({ leftHint = strictInterface })

function extended:init()
	self.state = { barWidth = 0, hintStringsConcat = nil, requiredSpace = nil, hintRatios = nil }

	function self.onExitFeedbackMode()
		ExperienceStateCaptureService:ToggleCaptureMode()
	end

	function self.openHelpModal()
		self.props.showHelpModal(true)
	end
end

function extended.calculateHintRatios(p)
	local joined = Cryo.List.join({ p }, {})
	local result = {}
	local total = 0
	local v = 84
	local v2 = ""

	for _, v3 in ipairs(joined) do
		result[v3.text] = GetTextSize(v3.text, 17, 2, Vector2.new(10000, 10000)).X

		total += result[v3.text]

		v = v + 36 + 8

		v2 ..= v3.text
	end

	for k, v3 in pairs(result) do
		result[k] = v3 / total
	end

	return result, v + math.max(#joined - 2, 0) * 40, v2
end

function extended.getDerivedStateFromProps(p)
	local hintRatios, requiredSpace, hintStringsConcat = extended.calculateHintRatios(p.leftHint)

	return {
		hintRatios = hintRatios,
		requiredSpace = requiredSpace,
		hintStringsConcat = hintStringsConcat
	}
end

function extended.calculateHintSize(p, p2, p3)
	local v = p2 - p.state.requiredSpace

	local v2 = p3.Header2.RelativeSize * p3.BaseSize
	local v3 = p3.Header2.RelativeMinSize * p3.BaseSize

	local x = GetTextSize(p.state.hintStringsConcat, v3, p3.Header2.Font, Vector2.new(10000, 10000)).X

	if x <= v then
		local x2 = GetTextSize(p.state.hintStringsConcat, v2, p3.Header2.Font, Vector2.new(10000, 10000)).X
		local v4 = (v2 - v3) / (x2 - x)
		local v5 = v2 - v4 * x2

		return nil, (math.clamp(v * v4 + v5, v3, v2))
	else
		local result = {}

		for k, hintRatio in pairs(p.state.hintRatios) do
			result[k] = hintRatio * v
		end

		return result
	end
end

function extended.render(object)
	return withStyle(function(p)
		local theme = p.Theme
		local function makeHint(leftHint)
			return Roact.createElement(FeedbackBarHint, leftHint)
		end

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = theme.BackgroundUIContrast.Transparency,
			BackgroundColor3 = theme.BackgroundUIContrast.Color,
			Size = UDim2.new(1, 0, 0, 72),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			[Roact.Change.AbsoluteSize] = function(p2)
				object:setState({ barWidth = p2.AbsoluteSize.X })
			end,
			[Roact.Event.AncestryChanged] = function(p2)
				object:setState({ barWidth = p2.AbsoluteSize.X })
			end
		}, {
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 24),
				PaddingRight = UDim.new(0, 24)
			}),
			LeftFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0.5, 1)
			}, {
				Roact.createElement("UIListLayout", {
					key = "Layout",
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 40)
				}),
				makeHint(object.props.leftHint)
			}),
			RightFrame = Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(0.35, 1),
					Position = UDim2.fromScale(1, 0),
					AnchorPoint = Vector2.new(1, 0)
				},
				{
					Layout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 40)
					}),
					Buttons = withLocalization({
						helpButtonText = "CoreScripts.Feedback.FeedbackBar.HelpButton",
						exitFeedbackButtonText = "CoreScripts.Feedback.FeedbackBar.ExitFeedbackButton"
					})(function(p2)
						return Roact.createElement(ButtonStack, {
							buttonHeight = 50,
							buttons = {
								{
									buttonType = ButtonType.Secondary,
									props = {
										onActivated = object.openHelpModal,
										text = p2.helpButtonText
									}
								},
								{
									buttonType = ButtonType.PrimarySystem,
									props = {
										isDisabled = false,
										onActivated = object.onExitFeedbackMode,
										text = p2.exitFeedbackButtonText
									}
								}
							},
							forcedFillDirection = Enum.FillDirection.Horizontal
						})
					end)
				}
			)
		})
	end)
end

return RoactRodux.connect(function()
	return {}
end, function(callback)
	return {
		showHelpModal = function(p)
			callback(ShowHelpModalThunk(p))
		end
	}
end)(extended)
