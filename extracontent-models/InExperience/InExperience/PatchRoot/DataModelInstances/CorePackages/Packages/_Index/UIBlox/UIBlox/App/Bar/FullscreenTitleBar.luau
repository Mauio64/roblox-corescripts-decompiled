local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local Foundation = require(parent3.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local Roact = require(parent3.Roact)
local Otter = require(parent3.Otter)
local t = require(parent3.t)

local IconButton = require(parent.Button.IconButton)
local Images = require(parent.ImageSet.Images)
local IconSize = require(parent.ImageSet.Enum.IconSize)
local getIconSize = require(parent.ImageSet.getIconSize)
local ControlState = require(parent3.UIBlox.Core.Control.Enum.ControlState)
local withStyle = require(parent2.Core.Style.withStyle)
local ThreeSectionBar = require(parent2.Core.Bar.ThreeSectionBar)

local lerp = require(parent3.UIBlox.Utility.lerp)
local divideTransparency = require(parent3.UIBlox.Utility.divideTransparency)

local udim = UDim2.new(0, 0, 0, -88)
local udim2 = UDim2.fromOffset(0, 0)

local v = { frequency = 5 }

local extended = Roact.PureComponent:extend("FullscreenTitleBar")

extended.validateProps = t.strictInterface({
	title = t.string,
	isTriggered = t.optional(t.boolean),
	onDisappear = t.optional(t.callback),
	onHover = t.optional(t.callback),
	exitFullscreen = t.optional(t.callback),
	closeRoblox = t.optional(t.callback)
})

function extended:init()
	local v2 = self.props.isTriggered and 1 or 0

	local binding, v3 = Roact.createBinding(v2)
	self.progress = binding

	local binding2, setExitControlState = Roact.createBinding(ControlState.Default)
	self.exitControlState = binding2
	self.setExitControlState = setExitControlState
	local binding3, setCloseControlState = Roact.createBinding(ControlState.Default)
	self.closeControlState = binding3
	self.setCloseControlState = setCloseControlState

	self.titleBarPosition = self.progress:map(function(p)
		return udim:lerp(udim2, p)
	end)

	self.progressMotor = Otter.createSingleMotor(v2)
	self.progressMotor:onStep(v3)
end

function extended.render(data)
	return withStyle(function(p)
		local theme = p.Theme
		local font = p.Font

		local backgroundUIDefault = theme.BackgroundUIDefault
		local textEmphasis = theme.TextEmphasis

		local header2 = font.Header2
		local textSize = header2.RelativeSize * font.BaseSize

		local mapped = data.progress:map(function(p2)
			return lerp(1, backgroundUIDefault.Transparency, p2)
		end)

		local mapped2 = Roact.joinBindings({
			progress = data.progress,
			controlState = data.exitControlState
		}):map(function(p2)
			return lerp(
				1,
				divideTransparency(
					theme.ContextualPrimaryDefault.Transparency,
					p2.controlState == ControlState.Pressed and 2 or 1
				),
				p2.progress
			)
		end)

		local mapped3 = Roact.joinBindings({
			progress = data.progress,
			controlState = data.closeControlState
		}):map(function(p2)
			return lerp(
				1,
				divideTransparency(
					theme.ContextualPrimaryDefault.Transparency,
					p2.controlState == ControlState.Pressed and 2 or 1
				),
				p2.progress
			)
		end)

		local mapped4 = data.progress:map(function(p2)
			return lerp(1, textEmphasis.Transparency, p2)
		end)

		local function renderCenterText()
			return Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				FontFace = normalizeFontFace(header2.Font),
				Size = UDim2.new(1, 0, 0, textSize),
				Text = data.props.title,
				TextColor3 = textEmphasis.Color,
				TextSize = textSize,
				TextTransparency = mapped4,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextWrapped = false
			})
		end

		local function renderRightButtons()
			return Roact.createFragment({
				ExitButton = Roact.createElement(IconButton, {
					icon = Images["icons/actions/previewShrink"],
					iconSize = IconSize.Medium,
					iconTransparency = mapped2,
					onActivated = data.props.exitFullscreen,
					layoutOrder = 1,
					onStateChanged = function(_, p2)
						data.setExitControlState(p2)
					end
				}),
				CloseButton = Roact.createElement(IconButton, {
					icon = Images["icons/navigation/close"],
					iconSize = IconSize.Medium,
					iconTransparency = mapped3,
					onActivated = data.props.closeRoblox,
					layoutOrder = 2,
					onStateChanged = function(_, p2)
						data.setCloseControlState(p2)
					end
				})
			})
		end

		local function renderMirrorButtons()
			local iconSize = getIconSize(IconSize.Medium)
			return Roact.createFragment({
				First = Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(iconSize, iconSize)
				}),
				Second = Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(iconSize, iconSize)
				})
			})
		end

		return Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = data.titleBarPosition,
				Size = UDim2.new(1, 0, 0, 88)
			},
			{
				BarFrame = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.fromOffset(0, 0),
					Size = UDim2.new(1, 0, 0, 64),
					[Roact.Event.MouseLeave] = data.props.onDisappear,
					[Roact.Event.MouseEnter] = data.props.onHover
				}, {
					ThreeSectionBar = Roact.createElement(ThreeSectionBar, {
						BackgroundColor3 = backgroundUIDefault.Color,
						BackgroundTransparency = mapped,
						barHeight = 64,
						marginLeft = 20,
						contentPaddingLeft = UDim.new(0, 12),
						renderLeft = renderMirrorButtons,
						renderCenter = renderCenterText,
						marginRight = 20,
						contentPaddingRight = UDim.new(0, 12),
						renderRight = renderRightButtons
					})
				}),
				ShadowFrame = Roact.createElement("Frame", {
					BackgroundTransparency = backgroundUIDefault.Transparency,
					BackgroundColor3 = backgroundUIDefault.Color,
					BorderSizePixel = 0,
					Position = UDim2.fromOffset(0, 64),
					Size = UDim2.new(1, 0, 0, 24)
				}, {
					UIGradient = Roact.createElement("UIGradient", {
						Rotation = 90,
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
							ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
						}),
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0.75),
							NumberSequenceKeypoint.new(1, 1)
						})
					})
				})
			}
		)
	end)
end

function extended.didMount(p)
	p.progressMotor:start()
end

function extended.didUpdate(p, p2, _)
	if p2.isTriggered ~= p.props.isTriggered then
		local v2 = p.props.isTriggered and 1 or 0
		p.progressMotor:setGoal(Otter.spring(v2, v))
	end
end

function extended.willUnmount(p)
	p.progressMotor:destroy()
end

return extended
