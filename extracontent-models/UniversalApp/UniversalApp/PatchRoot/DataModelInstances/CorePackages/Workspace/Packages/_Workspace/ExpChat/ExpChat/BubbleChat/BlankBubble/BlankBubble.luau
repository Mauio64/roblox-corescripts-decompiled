local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Dictionary = require(ExpChatParent.llama).Dictionary
local Roact = require(ExpChatParent.Roact)
local Otter = require(ExpChatParent.Otter)
local Config = require(ExpChat.Config)
local BubbleChat = script:FindFirstAncestor("BubbleChat")
local getSpringFromSettings = require(BubbleChat.Helpers.getSpringFromSettings)
local ClientSettingsUtility = require(ExpChat.ClientSettings.ClientSettingsUtility)
local v10 = Roact.PureComponent:extend("BlankBubble")

function v10.init(p1, p2) -- line: 23
	-- upvalues: Roact (copy), Otter (copy)
	p1.state = {}

	local v13, v14 = Roact.createBinding(0)

	p1.width = v13
	p1.updateWidth = v14
	p1.widthMotor = Otter.createSingleMotor(0)
	p1.widthMotor:onStep(function(p3) -- line: 27
		-- upvalues: p1 (copy)
		p1.updateWidth((math.round(p3)))
	end)
	p1.frameSize = p1.width:map(function(p4) -- line: 31
		-- upvalues: p1 (copy)
		if p1.props.insertSize then
			return UDim2.fromOffset(p4, p1.props.insertSize.Y + p1.props.chatSettings.Padding * 2)
		end

		return UDim2.fromOffset(p4, 0)
	end)

	local v15, v16 = Roact.createBinding(1)

	p1.transparency = v15
	p1.updateTransparency = v16
	p1.transparencyMotor = Otter.createSingleMotor(1)
	p1.transparencyMotor:onStep(p1.updateTransparency)

	local v17, v18 = Roact.createBinding(1)

	p1.backgroundTransparency = v17
	p1.updateBackgroundTransparency = v18
	p1.backgroundTransparencyMotor = Otter.createSingleMotor(1)
	p1.backgroundTransparencyMotor:onStep(p1.updateBackgroundTransparency)

	if p2.fadingOut then
		p1:fadeOut()
	end
end
function v10.getDerivedStateFromProps(p5, p6) -- line: 54
	local n1 = 0

	if p5.insertSize then
		n1 = p5.insertSize.X + p5.chatSettings.Padding * 2
	end

	if n1 ~= p6.fullWidth then
		return {
			fullWidth = n1
		}
	end

	return nil
end
function v10.render(p7) -- line: 69
	-- upvalues: Config (copy), Roact (copy), Dictionary (copy)
	local chatSettings = p7.props.chatSettings
	local ImageLabel = chatSettings.ImageLabel
	local UIGradient = chatSettings.UIGradient
	local UICorner = chatSettings.UICorner
	local CornerRadius = Config.DefaultBubbleChatChildrenCustomizationProperties.UICorner.CornerRadius
	local n2 = 0

	if p7.props.insertSize then
		n2 = p7.props.insertSize.Y + p7.props.chatSettings.Padding * 2
	end

	return Roact.createElement("Frame", {
		Transparency = 1,
		AnchorPoint = Vector2.new(0.5, 1),
		Size = UDim2.fromOffset(p7.state.fullWidth, n2),
		Position = UDim2.new(0.5, 0, 1, -8)
	}, {
		Scale = Roact.createElement("UIScale", {
			Scale = not p7.props.isDistant and 1 or 0.75
		}),
		Caret = p7.props.chatSettings.TailVisible and Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/InGameChat/Caret.png",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 1, -1),
			Size = UDim2.fromOffset(12, 8),
			ImageColor3 = chatSettings.BackgroundColor3,
			ImageTransparency = p7.backgroundTransparency
		}, {
			Gradient = UIGradient ~= nil and Roact.createElement("UIGradient", UIGradient)
		}),
		RoundedFrame = Roact.createElement("ImageLabel", Dictionary.join(ImageLabel, {
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Size = p7.frameSize,
			BackgroundColor3 = chatSettings.BackgroundColor3,
			BackgroundTransparency = if not ImageLabel or ImageLabel.Image == "" then p7.backgroundTransparency or p7.transparency else 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			ImageTransparency = p7.backgroundTransparency or p7.transparency,
			Image = ImageLabel and ImageLabel.Image or ""
		}), {
			UICorner = UICorner and Roact.createElement("UICorner", {
				CornerRadius = UICorner.CornerRadius
			}) or Roact.createElement("UICorner", {
				CornerRadius = CornerRadius
			}),
			Contents = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, p7.props.chatSettings.Padding),
					PaddingRight = UDim.new(0, p7.props.chatSettings.Padding),
					PaddingBottom = UDim.new(0, p7.props.chatSettings.Padding),
					PaddingLeft = UDim.new(0, p7.props.chatSettings.Padding)
				}),
				Insert = p7.props.renderInsert and p7.props.renderInsert()
			}),
			Gradient = UIGradient ~= nil and Roact.createElement("UIGradient", UIGradient)
		})
	})
end
function v10.fadeIn(p8) -- line: 143
	-- upvalues: getSpringFromSettings (copy), ClientSettingsUtility (copy)
	local v30 = getSpringFromSettings(p8.props.chatSettings, "transparency")

	p8.transparencyMotor:setGoal(v30(p8.props.chatSettings.Transparency))

	local v31 = ClientSettingsUtility.getBackgroundTransparency(p8.props.chatSettings, p8.props.clientSettings)

	p8.backgroundTransparencyMotor:setGoal(v30(v31))

	local v32 = getSpringFromSettings(p8.props.chatSettings, "size")

	p8.widthMotor:setGoal(v32(p8.state.fullWidth))
end
function v10.fadeOut(p9) -- line: 157
	-- upvalues: getSpringFromSettings (copy)
	p9.transparencyMotor:onComplete(function() -- line: 158
		-- upvalues: p9 (copy)
		if p9.props.onFadeOut then
			p9.props.onFadeOut()
		end
	end)

	local v34 = getSpringFromSettings(p9.props.chatSettings, "transparency")

	p9.transparencyMotor:setGoal(v34(1))
	p9.backgroundTransparencyMotor:setGoal(v34(1))
end
function v10.didUpdate(p10, p11, p12) -- line: 169
	-- upvalues: getSpringFromSettings (copy)
	if p11.fadingOut ~= p10.props.fadingOut then
		if p10.props.fadingOut then
			p10:fadeOut()
		else
			p10:fadeIn()
		end
	end

	if p10.state.fullWidth ~= p12.fullWidth then
		local v38 = getSpringFromSettings(p10.props.chatSettings, "size")

		p10.widthMotor:setGoal(v38(p10.state.fullWidth))
	end
end
function v10.didMount(p13) -- line: 183
	-- upvalues: getSpringFromSettings (copy), ClientSettingsUtility (copy)
	if not p13.props.fadingOut then
		local v40 = getSpringFromSettings(p13.props.chatSettings, "size")
		local v41 = getSpringFromSettings(p13.props.chatSettings, "transparency")

		p13.transparencyMotor:setGoal(v41(p13.props.chatSettings.Transparency))

		local v42 = ClientSettingsUtility.getBackgroundTransparency(p13.props.chatSettings, p13.props.clientSettings)

		p13.backgroundTransparencyMotor:setGoal(v41(v42))
		p13.widthMotor:setGoal(v40(p13.state.fullWidth))
	end
end
function v10.willUnmount(p14) -- line: 199
	p14.transparencyMotor:destroy()
	p14.backgroundTransparencyMotor:destroy()
	p14.widthMotor:destroy()
end

return v10
