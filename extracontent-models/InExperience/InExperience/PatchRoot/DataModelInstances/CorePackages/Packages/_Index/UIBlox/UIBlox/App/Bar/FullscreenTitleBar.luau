local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local Otter = require(ParentParentParentParent.Otter)
local t = require(ParentParentParentParent.t)
local IconButton = require(ParentParent.Button.IconButton)
local Images = require(ParentParent.ImageSet.Images)
local IconSize = require(ParentParent.ImageSet.Enum.IconSize)
local getIconSize = require(ParentParent.ImageSet.getIconSize)
local ControlState = require(ParentParentParentParent.UIBlox.Core.Control.Enum.ControlState)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local ThreeSectionBar = require(ParentParentParent.Core.Bar.ThreeSectionBar)
local lerp = require(ParentParentParentParent.UIBlox.Utility.lerp)
local divideTransparency = require(ParentParentParentParent.UIBlox.Utility.divideTransparency)
local uDim2 = UDim2.new(0, 0, 0, -88)
local uDim2_2 = UDim2.fromOffset(0, 0)
local t1 = {
	frequency = 5
}
local v19 = Roact.PureComponent:extend("FullscreenTitleBar")

v19.validateProps = t.strictInterface({
	title = t.string,
	isTriggered = t.optional(t.boolean),
	onDisappear = t.optional(t.callback),
	onHover = t.optional(t.callback),
	exitFullscreen = t.optional(t.callback),
	closeRoblox = t.optional(t.callback)
})

function v19.init(p1) -- line: 56
	-- upvalues: Roact (copy), ControlState (copy), uDim2 (copy), uDim2_2 (copy), Otter (copy)
	local v21 = not p1.props.isTriggered and 0 or 1
	local v22, v23 = Roact.createBinding(v21)

	p1.progress = v22

	local v24, v25 = Roact.createBinding(ControlState.Default)

	p1.exitControlState = v24
	p1.setExitControlState = v25

	local v26, v27 = Roact.createBinding(ControlState.Default)

	p1.closeControlState = v26
	p1.setCloseControlState = v27
	p1.titleBarPosition = p1.progress:map(function(p2) -- line: 64
		-- upvalues: uDim2 (copy), uDim2_2 (copy)
		return uDim2:lerp(uDim2_2, p2)
	end)
	p1.progressMotor = Otter.createSingleMotor(v21)
	p1.progressMotor:onStep(v23)
end
function v19.render(p3) -- line: 72
	-- upvalues: withStyle (copy), lerp (copy), Roact (copy), ControlState (copy), divideTransparency (copy), IconButton (copy), Images (copy), IconSize (copy), getIconSize (copy), ThreeSectionBar (copy)
	return withStyle(function(p4) -- line: 73
		-- upvalues: p3 (copy), lerp (copy), Roact (copy), ControlState (copy), divideTransparency (copy), IconButton (copy), Images (copy), IconSize (copy), getIconSize (copy), ThreeSectionBar (copy)
		local Theme = p4.Theme
		local p4Font = p4.Font
		local BackgroundUIDefault = Theme.BackgroundUIDefault
		local TextEmphasis = Theme.TextEmphasis
		local Header2 = p4Font.Header2
		local v42 = Header2.RelativeSize * p4Font.BaseSize
		local v43 = p3.progress:map(function(p5) -- line: 83
			-- upvalues: BackgroundUIDefault (copy), lerp (copy)
			local BackgroundUIDefaultTransparency = BackgroundUIDefault.Transparency

			return lerp(1, BackgroundUIDefaultTransparency, p5)
		end)
		local v44 = Roact.joinBindings({
			progress = p3.progress,
			controlState = p3.exitControlState
		}):map(function(p6) -- line: 91
			-- upvalues: Theme (copy), ControlState (copy), lerp (copy), divideTransparency (copy)
			local ContextualPrimaryDefaultTransparency = Theme.ContextualPrimaryDefault.Transparency
			local v54 = p6.controlState ~= ControlState.Pressed and 1 or 2

			return lerp(1, divideTransparency(ContextualPrimaryDefaultTransparency, v54), p6.progress)
		end)
		local v45 = Roact.joinBindings({
			progress = p3.progress,
			controlState = p3.closeControlState
		}):map(function(p7) -- line: 100
			-- upvalues: Theme (copy), ControlState (copy), lerp (copy), divideTransparency (copy)
			local ContextualPrimaryDefaultTransparency = Theme.ContextualPrimaryDefault.Transparency
			local v57 = p7.controlState ~= ControlState.Pressed and 1 or 2

			return lerp(1, divideTransparency(ContextualPrimaryDefaultTransparency, v57), p7.progress)
		end)
		local v46 = p3.progress:map(function(p8) -- line: 106
			-- upvalues: TextEmphasis (copy), lerp (copy)
			local TextEmphasisTransparency = TextEmphasis.Transparency

			return lerp(1, TextEmphasisTransparency, p8)
		end)

		local function renderCenterText() -- line: 111
			-- upvalues: Roact (copy), Header2 (copy), v42 (copy), p3 (copy), TextEmphasis (copy), v46 (copy)
			return Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = false,
				Font = Header2.Font,
				Size = UDim2.new(1, 0, 0, v42),
				Text = p3.props.title,
				TextColor3 = TextEmphasis.Color,
				TextSize = v42,
				TextTransparency = v46,
				TextTruncate = Enum.TextTruncate.AtEnd
			})
		end
		local function renderRightButtons() -- line: 125
			-- upvalues: Roact (copy), IconButton (copy), Images (copy), IconSize (copy), v44 (copy), p3 (copy), v45 (copy)
			return Roact.createFragment({
				ExitButton = Roact.createElement(IconButton, {
					layoutOrder = 1,
					icon = Images["icons/actions/previewShrink"],
					iconSize = IconSize.Medium,
					iconTransparency = v44,
					onActivated = p3.props.exitFullscreen,
					onStateChanged = function(_, p10) -- line: 133
						-- upvalues: p3 (copy)
						p3.setExitControlState(p10)
					end
				}),
				CloseButton = Roact.createElement(IconButton, {
					layoutOrder = 2,
					icon = Images["icons/navigation/close"],
					iconSize = IconSize.Medium,
					iconTransparency = v45,
					onActivated = p3.props.closeRoblox,
					onStateChanged = function(_, p12) -- line: 143
						-- upvalues: p3 (copy)
						p3.setCloseControlState(p12)
					end
				})
			})
		end
		local function renderMirrorButtons() -- line: 150
			-- upvalues: getIconSize (copy), IconSize (copy), Roact (copy)
			local v60 = getIconSize(IconSize.Medium)

			return Roact.createFragment({
				First = Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(v60, v60)
				}),
				Second = Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(v60, v60)
				})
			})
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = p3.titleBarPosition,
			Size = UDim2.new(1, 0, 0, 88)
		}, {
			BarFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(0, 0),
				Size = UDim2.new(1, 0, 0, 64),
				[Roact.Event.MouseLeave] = p3.props.onDisappear,
				[Roact.Event.MouseEnter] = p3.props.onHover
			}, {
				ThreeSectionBar = Roact.createElement(ThreeSectionBar, {
					barHeight = 64,
					marginLeft = 20,
					marginRight = 20,
					BackgroundColor3 = BackgroundUIDefault.Color,
					BackgroundTransparency = v43,
					contentPaddingLeft = UDim.new(0, 12),
					renderLeft = renderMirrorButtons,
					renderCenter = renderCenterText,
					contentPaddingRight = UDim.new(0, 12),
					renderRight = renderRightButtons
				})
			}),
			ShadowFrame = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = BackgroundUIDefault.Transparency,
				BackgroundColor3 = BackgroundUIDefault.Color,
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
		})
	end)
end
function v19.didMount(p13) -- line: 214
	p13.progressMotor:start()
end
function v19.didUpdate(p14, p15, _) -- line: 218
	-- upvalues: Otter (copy), t1 (copy)
	if p15.isTriggered ~= p14.props.isTriggered then
		local v33 = not p14.props.isTriggered and 0 or 1

		p14.progressMotor:setGoal(Otter.spring(v33, t1))
	end
end
function v19.willUnmount(p17) -- line: 225
	p17.progressMotor:destroy()
end

return v19
