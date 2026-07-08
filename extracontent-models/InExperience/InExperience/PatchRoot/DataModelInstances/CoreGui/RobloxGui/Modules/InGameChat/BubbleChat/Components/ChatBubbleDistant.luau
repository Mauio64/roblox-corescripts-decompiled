local CorePackages = game:GetService("CorePackages")
local Otter = require(CorePackages.Packages.Otter)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local ParentParent = script.Parent.Parent
local Types = require(ParentParent.Types)
local getSizeSpringFromSettings = require(ParentParent.Helpers.getSizeSpringFromSettings)
local getTransparencySpringFromSettings = require(ParentParent.Helpers.getTransparencySpringFromSettings)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts

game:GetService("CoreGui"):WaitForChild("RobloxGui")

local v11 = Roact.PureComponent:extend("ChatBubbleDistant")

v11.validateProps = t.strictInterface({
	width = t.optional(t.number),
	height = t.optional(t.number),
	fadingOut = t.optional(t.boolean),
	onFadeOut = t.optional(t.callback),
	chatSettings = Types.IChatSettings,
	renderInsert = t.optional(t.callback),
	insertSize = t.optional(t.Vector2)
})
v11.defaultProps = {
	width = 32,
	height = 16
}

local function getFullHeight(p1) -- line: 41
	local height = p1.height

	if p1.renderInsert then
		height = math.max(height, p1.insertSize.Y)
	end

	return height + p1.chatSettings.Padding * 2
end

function v11.init(p2, p3) -- line: 50
	-- upvalues: Roact (copy), Otter (copy)
	local v17, v18 = Roact.createBinding(0)

	p2.width = v17
	p2.updateWidth = v18
	p2.widthMotor = Otter.createSingleMotor(0)
	p2.widthMotor:onStep(function(p4) -- line: 53
		-- upvalues: p2 (copy)
		p2.updateWidth((math.round(p4)))
	end)

	local createBinding = Roact.createBinding
	local height = p3.height

	if p3.renderInsert then
		height = math.max(height, p3.insertSize.Y)
	end

	local v21, v22 = createBinding(height + p3.chatSettings.Padding * 2)

	p2.height = v21
	p2.updateHeight = v22
	p2.frameSize = Roact.joinBindings({
		p2.width,
		p2.height
	}):map(function(p5) -- line: 59
		return UDim2.fromOffset(p5[1], p5[2])
	end)

	local v23, v24 = Roact.createBinding(1)

	p2.transparency = v23
	p2.updateTransparency = v24
	p2.transparencyMotor = Otter.createSingleMotor(1)
	p2.transparencyMotor:onStep(p2.updateTransparency)

	if p3.fadingOut then
		p2:fadeOut()
	end
end
function v11.getDerivedStateFromProps(p6, p7) -- line: 74
	local chatSettings = p6.chatSettings
	local v28 = if not p6.renderInsert then p6.width + chatSettings.Padding * 2 else p6.width + p6.insertSize.X + chatSettings.Padding * 2
	local height = p6.height

	if p6.renderInsert then
		height = math.max(height, p6.insertSize.Y)
	end

	local v30 = height + p6.chatSettings.Padding * 2

	if v28 ~= p7.fullWidth or v30 ~= p7.fullHeight then
		return {
			fullWidth = v28,
			fullHeight = v30
		}
	end

	return nil
end
function v11.render(p8) -- line: 96
	-- upvalues: Roact (copy), Cryo (copy), AppFonts (copy)
	local chatSettings = p8.props.chatSettings
	local BackgroundImage = chatSettings.BackgroundImage
	local BackgroundGradient = chatSettings.BackgroundGradient
	local v35 = p8.props.renderInsert and p8.props.insertSize.X or 0

	return Roact.createElement("Frame", {
		Transparency = 1,
		AnchorPoint = Vector2.new(0.5, 1),
		Size = UDim2.fromOffset(p8.state.fullWidth, p8.state.fullHeight),
		Position = UDim2.new(0.5, 0, 1, -8)
	}, {
		Scale = Roact.createElement("UIScale", {
			Scale = 0.75
		}),
		Carat = chatSettings.TailVisible and Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/InGameChat/Caret.png",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 1, -1),
			Size = UDim2.fromOffset(12, 8),
			ImageColor3 = chatSettings.BackgroundColor3,
			ImageTransparency = p8.transparency
		}),
		RoundedFrame = Roact.createElement("ImageLabel", Cryo.Dictionary.join(BackgroundImage, {
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Size = p8.frameSize,
			BackgroundColor3 = chatSettings.BackgroundColor3,
			BackgroundTransparency = BackgroundImage.Image == "" and p8.transparency or 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			ImageTransparency = p8.transparency
		}), {
			UICorner = chatSettings.CornerEnabled and Roact.createElement("UICorner", {
				CornerRadius = chatSettings.CornerRadius
			}),
			Contents = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, chatSettings.Padding),
					PaddingRight = UDim.new(0, chatSettings.Padding),
					PaddingBottom = UDim.new(0, chatSettings.Padding),
					PaddingLeft = UDim.new(0, chatSettings.Padding)
				}),
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Insert = p8.props.renderInsert and p8.props.renderInsert(),
				Ellipsis = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = "…",
					TextScaled = true,
					LayoutOrder = 2,
					TextColor3 = chatSettings.TextColor3,
					TextTransparency = p8.transparency,
					Font = AppFonts.default:getBlack(),
					Size = UDim2.new(1, -v35, 1, 0)
				})
			}),
			Gradient = BackgroundGradient.Enabled and Roact.createElement("UIGradient", BackgroundGradient)
		})
	})
end
function v11.fadeOut(p9) -- line: 175
	-- upvalues: getTransparencySpringFromSettings (copy)
	if not p9.isFadingOut then
		p9.isFadingOut = true
		p9.transparencyMotor:onComplete(function() -- line: 179
			-- upvalues: p9 (copy)
			if p9.props.onFadeOut then
				p9.props.onFadeOut()
			end
		end)

		local v37 = getTransparencySpringFromSettings(p9.props.chatSettings)

		p9.transparencyMotor:setGoal(v37(1))
	end
end
function v11.didUpdate(p10, _, p12) -- line: 190
	-- upvalues: getSizeSpringFromSettings (copy)
	if p10.props.fadingOut then
		p10:fadeOut()

		return
	end

	if p10.state.fullHeight ~= p12.fullHeight then
		p10.updateHeight(p10.state.fullHeight)
	end

	if p10.state.fullWidth ~= p12.fullWidth then
		local chatSettings = p10.props.chatSettings
		local v42 = getSizeSpringFromSettings(chatSettings)

		p10.widthMotor:setGoal(v42(p10.state.fullWidth))
	end
end
function v11.didMount(p13) -- line: 205
	-- upvalues: getSizeSpringFromSettings (copy), getTransparencySpringFromSettings (copy)
	if not p13.props.fadingOut then
		local chatSettings = p13.props.chatSettings
		local v45 = getSizeSpringFromSettings(chatSettings)
		local v46 = getTransparencySpringFromSettings(chatSettings)

		p13.transparencyMotor:setGoal(v46(p13.props.chatSettings.Transparency))
		p13.widthMotor:setGoal(v45(p13.state.fullWidth))
	end
end
function v11.willUnmount(p14) -- line: 216
	p14.transparencyMotor:destroy()
	p14.widthMotor:destroy()
end

return v11
