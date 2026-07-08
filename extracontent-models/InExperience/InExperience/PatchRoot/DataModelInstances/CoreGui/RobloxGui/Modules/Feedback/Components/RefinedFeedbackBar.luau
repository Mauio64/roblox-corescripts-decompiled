local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local ParentParent = script.Parent.Parent
local ShowHelpModalThunk = require(ParentParent.Thunks.ShowHelpModalThunk)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local FeedbackBarHint = require(script.Parent.FeedbackBarHint)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local withStyle = UIBlox.Core.Style.withStyle
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local v16 = Roact.PureComponent:extend("RefinedFeedbackBar")

local function GetTextSize(...) -- line: 41
	-- upvalues: TextService (copy)
	return TextService:GetTextSize(...) + Vector2.new(2, 2)
end

local v18 = t.strictInterface({
	text = t.string
})

v16.validateProps = t.strictInterface({
	leftHint = v18
})

function v16.init(p1) -- line: 55
	-- upvalues: ExperienceStateCaptureService (copy)
	p1.state = {
		barWidth = 0,
		hintStringsConcat = nil,
		requiredSpace = nil,
		hintRatios = nil
	}

	function p1.onExitFeedbackMode() -- line: 63
		-- upvalues: ExperienceStateCaptureService (copy)
		ExperienceStateCaptureService:ToggleCaptureMode()
	end
	function p1.openHelpModal() -- line: 67
		-- upvalues: p1 (copy)
		p1.props.showHelpModal(true)
	end
end
function v16.calculateHintRatios(p2) -- line: 73
	-- upvalues: Cryo (copy), GetTextSize (copy)
	local n1 = 84
	local s1 = ""
	local t1 = {}
	local n2 = 0
	local v25 = Cryo.List.join({ p2 }, {})

	for _, v in ipairs(v25) do
		t1[v.text] = GetTextSize(v.text, 17, 2, Vector2.new(10000, 10000)).X
		n2 += t1[v.text]
		n1 = n1 + 36 + 8
		s1 ..= v.text
	end

	for k, v in pairs(t1) do
		t1[k] = v / n2
	end

	return t1, n1 + math.max(#v25 - 2, 0) * 40, s1
end
function v16.getDerivedStateFromProps(p3) -- line: 105
	-- upvalues: v16 (copy)
	local v31, v32, v33 = v16.calculateHintRatios(p3.leftHint)

	return {
		hintRatios = v31,
		requiredSpace = v32,
		hintStringsConcat = v33
	}
end
function v16.calculateHintSize(p4, p5, p6) -- line: 116
	-- upvalues: GetTextSize (copy)
	local v37 = p5 - p4.state.requiredSpace
	local v38 = p6.Header2.RelativeSize * p6.BaseSize
	local v39 = p6.Header2.RelativeMinSize * p6.BaseSize
	local X = GetTextSize(p4.state.hintStringsConcat, v39, p6.Header2.Font, Vector2.new(10000, 10000)).X

	if X <= v37 then
		local X2 = GetTextSize(p4.state.hintStringsConcat, v38, p6.Header2.Font, Vector2.new(10000, 10000)).X
		local v42 = (v38 - v39) / (X2 - X)
		local v43 = v38 - v42 * X2

		return nil, (math.clamp(v37 * v42 + v43, v39, v38))
	end

	local t2 = {}

	for k, v in pairs(p4.state.hintRatios) do
		t2[k] = v * v37
	end

	return t2
end
function v16.render(p7) -- line: 155
	-- upvalues: withStyle (copy), Roact (copy), FeedbackBarHint (copy), withLocalization (copy), ButtonStack (copy), ButtonType (copy)
	return withStyle(function(p8) -- line: 156
		-- upvalues: Roact (copy), FeedbackBarHint (copy), p7 (copy), withLocalization (copy), ButtonStack (copy), ButtonType (copy)
		local Theme = p8.Theme

		local function makeHint(p9) -- line: 158
			-- upvalues: Roact (copy), FeedbackBarHint (copy)
			return Roact.createElement(FeedbackBarHint, p9)
		end

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = Theme.BackgroundUIContrast.Transparency,
			BackgroundColor3 = Theme.BackgroundUIContrast.Color,
			Size = UDim2.new(1, 0, 0, 72),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			[Roact.Change.AbsoluteSize] = function(p10) -- line: 169
				-- upvalues: p7 (copy)
				p7:setState({
					barWidth = p10.AbsoluteSize.X
				})
			end,
			[Roact.Event.AncestryChanged] = function(p11) -- line: 174
				-- upvalues: p7 (copy)
				p7:setState({
					barWidth = p11.AbsoluteSize.X
				})
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
				makeHint(p7.props.leftHint)
			}),
			RightFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0.35, 1),
				Position = UDim2.fromScale(1, 0),
				AnchorPoint = Vector2.new(1, 0)
			}, {
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
				})(function(p12) -- line: 217
					-- upvalues: Roact (copy), ButtonStack (copy), ButtonType (copy), p7 (copy)
					return Roact.createElement(ButtonStack, {
						buttonHeight = 50,
						buttons = {
							{
								buttonType = ButtonType.Secondary,
								props = {
									onActivated = p7.openHelpModal,
									text = p12.helpButtonText
								}
							},
							{
								buttonType = ButtonType.PrimarySystem,
								props = {
									isDisabled = false,
									onActivated = p7.onExitFeedbackMode,
									text = p12.exitFeedbackButtonText
								}
							}
						},
						forcedFillDirection = Enum.FillDirection.Horizontal
					})
				end)
			})
		})
	end)
end

return RoactRodux.connect(function() -- line: 245
	return {}
end, function(p13) -- line: 247
	-- upvalues: ShowHelpModalThunk (copy)
	return {
		showHelpModal = function(p14) -- line: 249
			-- upvalues: p13 (copy), ShowHelpModalThunk (copy)
			p13(ShowHelpModalThunk(p14))
		end
	}
end)(v16)
