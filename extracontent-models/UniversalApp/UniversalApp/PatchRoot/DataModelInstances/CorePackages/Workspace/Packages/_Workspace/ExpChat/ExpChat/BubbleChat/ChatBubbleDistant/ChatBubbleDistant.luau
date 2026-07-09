local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Roact = require(ExpChatParent.Roact)
local Otter = require(ExpChatParent.Otter)
local Dictionary = require(ExpChatParent.llama).Dictionary
local Config = require(ExpChat.Config)
local Helpers = ExpChat.BubbleChat.Helpers
local getSpringFromSettings = require(Helpers.getSpringFromSettings)
local getAbsolutePaddingbyDimension = require(Helpers.getAbsolutePaddingbyDimension)
local ClientSettingsUtility = require(ExpChat.ClientSettings.ClientSettingsUtility)
local v11 = Roact.Component:extend("ChatBubbleDistant")

v11.defaultProps = {
	width = 32,
	height = 16
}

local function getFullHeight(p1) -- line: 21
	-- upvalues: getAbsolutePaddingbyDimension (copy)
	local height = p1.height

	if p1.renderInsert then
		height = math.max(height, p1.insertSize.Y)
	end

	if p1.chatSettings.UIPadding then
		local UIPadding = p1.chatSettings.UIPadding
		local v16 = getAbsolutePaddingbyDimension(UIPadding.PaddingTop, height)
		local v17 = getAbsolutePaddingbyDimension(UIPadding.PaddingBottom, height)

		if p1.renderInsert then
			height = math.max(height, p1.insertSize.Y)
		end

		return height + (v16 + v17)
	end

	if p1.renderInsert then
		height = math.max(height, p1.insertSize.Y)
	end

	return height + p1.chatSettings.Padding * 2
end

function v11.init(p2) -- line: 49
	-- upvalues: Roact (copy), Otter (copy), getFullHeight (copy)
	p2.state = {}

	local v19, v20 = Roact.createBinding(0)

	p2.width = v19
	p2.updateWidth = v20
	p2.widthMotor = Otter.createSingleMotor(0)
	p2.widthMotor:onStep(function(p3) -- line: 54
		-- upvalues: p2 (copy)
		p2.updateWidth((math.round(p3)))
	end)

	local v21, v22 = Roact.createBinding((getFullHeight(p2.props)))

	p2.height = v21
	p2.updateHeight = v22
	p2.frameSize = Roact.joinBindings({
		p2.width,
		p2.height
	}):map(function(p4) -- line: 60
		return UDim2.fromOffset(p4[1], p4[2])
	end)

	local v23, v24 = Roact.createBinding(1)

	p2.transparency = v23
	p2.updateTransparency = v24
	p2.transparencyMotor = Otter.createSingleMotor(1)
	p2.transparencyMotor:onStep(p2.updateTransparency)

	local v25, v26 = Roact.createBinding(1)

	p2.backgroundTransparency = v25
	p2.updateBackgroundTransparency = v26
	p2.backgroundTransparencyMotor = Otter.createSingleMotor(1)
	p2.backgroundTransparencyMotor:onStep(p2.updateBackgroundTransparency)

	if p2.props.fadingOut then
		p2:fadeOut()
	end
end
function v11.getDerivedStateFromProps(p5, p6) -- line: 79
	-- upvalues: getAbsolutePaddingbyDimension (copy), getFullHeight (copy)
	local v31

	if p5.chatSettings.UIPadding then
		local width = p5.width

		if p5.renderInsert then
			width += p5.insertSize.X
		end

		local UIPadding = p5.chatSettings.UIPadding

		v31 = width + (getAbsolutePaddingbyDimension(UIPadding.PaddingLeft, width) + getAbsolutePaddingbyDimension(UIPadding.PaddingRight, width))
	else
		v31 = if not p5.renderInsert then p5.width + p5.chatSettings.Padding * 2 else p5.width + p5.insertSize.X + p5.chatSettings.Padding * 2
	end

	local v32 = getFullHeight(p5)

	if v31 ~= p6.fullWidth or v32 ~= p6.fullHeight then
		return {
			fullWidth = v31,
			fullHeight = v32
		}
	end

	return nil
end
function v11.render(p7) -- line: 112
	-- upvalues: Config (copy), Roact (copy), Dictionary (copy)
	local chatSettings = p7.props.chatSettings
	local UICorner = nil
	local ImageLabel, UIGradient, UIPadding

	if p7.props.isTextChatServiceOn then
		ImageLabel = chatSettings.ImageLabel
		UIGradient = chatSettings.UIGradient
		UICorner = chatSettings.UICorner
		UIPadding = chatSettings.UIPadding
	else
		ImageLabel = chatSettings.BackgroundImage
		UIGradient = chatSettings.BackgroundGradient

		if chatSettings.CornerEnabled then
			UICorner = {
				CornerRadius = chatSettings.CornerRadius
			}
		elseif chatSettings.CornerEnabled == false then
			UICorner = {
				CornerRadius = UDim.new(0, 0)
			}
		end

		UIPadding = chatSettings.Padding and {
			PaddingTop = UDim.new(0, chatSettings.Padding),
			PaddingRight = UDim.new(0, chatSettings.Padding),
			PaddingBottom = UDim.new(0, chatSettings.Padding),
			PaddingLeft = UDim.new(0, chatSettings.Padding)
		} or nil
	end

	local CornerRadius = Config.DefaultBubbleChatChildrenCustomizationProperties.UICorner.CornerRadius
	local UIPadding2 = Config.DefaultBubbleChatChildrenCustomizationProperties.UIPadding
	local v41 = p7.props.renderInsert and p7.props.insertSize.X or 0
	local v42 = p7.props.chatSettings.TailVisible and p7.props.showCaret

	return Roact.createElement("Frame", {
		Transparency = 1,
		AnchorPoint = Vector2.new(0.5, 1),
		Size = UDim2.fromOffset(p7.state.fullWidth, p7.state.fullHeight),
		Position = UDim2.new(0.5, 0, 1, -8)
	}, {
		Scale = Roact.createElement("UIScale", {
			Scale = 0.75
		}),
		Carat = p7.props.chatSettings.TailVisible and (v42 and Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/InGameChat/Caret.png",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 1, -1),
			Size = UDim2.fromOffset(12, 8),
			ImageColor3 = chatSettings.BackgroundColor3,
			ImageTransparency = p7.backgroundTransparency
		}, {
			Gradient = UIGradient ~= nil and Roact.createElement("UIGradient", UIGradient)
		})),
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
				Padding = UIPadding and Roact.createElement("UIPadding", UIPadding) or Roact.createElement("UIPadding", UIPadding2),
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Insert = p7.props.renderInsert and p7.props.renderInsert(),
				Ellipsis = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = "…",
					TextScaled = false,
					LayoutOrder = 2,
					TextColor3 = chatSettings.TextColor3,
					TextTransparency = p7.transparency,
					Font = Enum.Font.BuilderSansExtraBold,
					TextSize = chatSettings.TextSize,
					Size = UDim2.new(1, -v41, 1, 0)
				})
			}),
			Gradient = UIGradient ~= nil and Roact.createElement("UIGradient", UIGradient)
		})
	})
end
function v11.fadeIn(p8) -- line: 229
	-- upvalues: getSpringFromSettings (copy), ClientSettingsUtility (copy)
	local v44 = getSpringFromSettings(p8.props.chatSettings, "transparency")

	p8.transparencyMotor:setGoal(v44(p8.props.chatSettings.Transparency))

	local v45 = ClientSettingsUtility.getBackgroundTransparency(p8.props.chatSettings, p8.props.clientSettings)

	p8.backgroundTransparencyMotor:setGoal(v44(v45))

	local v46 = getSpringFromSettings(p8.props.chatSettings, "size")

	p8.widthMotor:setGoal(v46(p8.state.fullWidth))
end
function v11.fadeOut(p9) -- line: 243
	-- upvalues: getSpringFromSettings (copy)
	p9.transparencyMotor:onComplete(function() -- line: 244
		-- upvalues: p9 (copy)
		if p9.props.onFadeOut then
			p9.props.onFadeOut()
		end
	end)

	local v48 = getSpringFromSettings(p9.props.chatSettings, "transparency")

	p9.transparencyMotor:setGoal(v48(1))
	p9.backgroundTransparencyMotor:setGoal(v48(1))
end
function v11.didUpdate(p10, p11, p12) -- line: 255
	-- upvalues: getSpringFromSettings (copy)
	if p11.fadingOut ~= p10.props.fadingOut then
		if p10.props.fadingOut then
			p10:fadeOut()

			return
		end

		p10:fadeIn()

		return
	end

	if p10.state.fullHeight ~= p12.fullHeight then
		p10.updateHeight(p10.state.fullHeight)
	end

	if p10.state.fullWidth ~= p12.fullWidth then
		local v52 = getSpringFromSettings(p10.props.chatSettings, "size")

		p10.widthMotor:setGoal(v52(p10.state.fullWidth))
	end
end
function v11.didMount(p13) -- line: 273
	-- upvalues: getSpringFromSettings (copy), ClientSettingsUtility (copy)
	if not p13.props.fadingOut then
		local v54 = getSpringFromSettings(p13.props.chatSettings, "size")
		local v55 = getSpringFromSettings(p13.props.chatSettings, "transparency")

		p13.transparencyMotor:setGoal(v55(p13.props.chatSettings.Transparency))

		local v56 = ClientSettingsUtility.getBackgroundTransparency(p13.props.chatSettings, p13.props.clientSettings)

		p13.backgroundTransparencyMotor:setGoal(v55(v56))
		p13.widthMotor:setGoal(v54(p13.state.fullWidth))
	end
end
function v11.willUnmount(p14) -- line: 289
	p14.transparencyMotor:destroy()
	p14.backgroundTransparencyMotor:destroy()
	p14.widthMotor:destroy()
end

return v11
