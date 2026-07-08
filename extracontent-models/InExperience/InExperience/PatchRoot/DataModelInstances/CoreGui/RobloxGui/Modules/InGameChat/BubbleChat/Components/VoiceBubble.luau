local CorePackages = game:GetService("CorePackages")
local Otter = require(CorePackages.Packages.Otter)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local ParentParent = script.Parent.Parent
local Types = require(ParentParent.Types)
local getSizeSpringFromSettings = require(ParentParent.Helpers.getSizeSpringFromSettings)
local getTransparencySpringFromSettings = require(ParentParent.Helpers.getTransparencySpringFromSettings)

game:GetService("CoreGui"):WaitForChild("RobloxGui")

local v10 = Roact.PureComponent:extend("VoiceBubble")

v10.validateProps = t.strictInterface({
	fadingOut = t.optional(t.boolean),
	onFadeOut = t.optional(t.callback),
	chatSettings = Types.IChatSettings,
	renderInsert = t.optional(t.callback),
	insertSize = t.optional(t.Vector2),
	isDistant = t.optional(t.boolean)
})

function v10.init(p1, p2) -- line: 33
	-- upvalues: Roact (copy), Otter (copy)
	local v13, v14 = Roact.createBinding(0)

	p1.width = v13
	p1.updateWidth = v14
	p1.widthMotor = Otter.createSingleMotor(0)
	p1.widthMotor:onStep(function(p3) -- line: 36
		-- upvalues: p1 (copy)
		p1.updateWidth((math.round(p3)))
	end)
	p1.frameSize = p1.width:map(function(p4) -- line: 40
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

	if p2.fadingOut then
		p1:fadeOut()
	end
end
function v10.getDerivedStateFromProps(p5, p6) -- line: 59
	local chatSettings = p5.chatSettings
	local n1 = 0

	if p5.insertSize then
		n1 = p5.insertSize.X + chatSettings.Padding * 2
	end

	if n1 ~= p6.fullWidth then
		return {
			fullWidth = n1
		}
	end

	return nil
end
function v10.render(p7) -- line: 76
	-- upvalues: Roact (copy), Cryo (copy)
	local chatSettings = p7.props.chatSettings
	local BackgroundImage = chatSettings.BackgroundImage
	local BackgroundGradient = chatSettings.BackgroundGradient
	local n2 = 0

	if p7.props.insertSize then
		n2 = p7.props.insertSize.Y + chatSettings.Padding * 2
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
		Carat = chatSettings.TailVisible and Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/InGameChat/Caret.png",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 1, -1),
			Size = UDim2.fromOffset(12, 8),
			ImageColor3 = chatSettings.BackgroundColor3,
			ImageTransparency = p7.transparency
		}),
		RoundedFrame = Roact.createElement("ImageLabel", Cryo.Dictionary.join(BackgroundImage, {
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Size = p7.frameSize,
			BackgroundColor3 = chatSettings.BackgroundColor3,
			BackgroundTransparency = BackgroundImage.Image == "" and p7.transparency or 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			ImageTransparency = p7.transparency
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
				Insert = p7.props.renderInsert and p7.props.renderInsert()
			}),
			Gradient = BackgroundGradient.Enabled and Roact.createElement("UIGradient", BackgroundGradient)
		})
	})
end
function v10.fadeOut(p8) -- line: 142
	-- upvalues: getTransparencySpringFromSettings (copy)
	if not p8.isFadingOut then
		p8.isFadingOut = true
		p8.transparencyMotor:onComplete(function() -- line: 146
			-- upvalues: p8 (copy)
			if p8.props.onFadeOut then
				p8.props.onFadeOut()
			end
		end)

		local v27 = getTransparencySpringFromSettings(p8.props.chatSettings)

		p8.transparencyMotor:setGoal(v27(1))
	end
end
function v10.didUpdate(p9, _, p11) -- line: 157
	-- upvalues: getSizeSpringFromSettings (copy)
	if p9.props.fadingOut then
		p9:fadeOut()

		return
	end

	if p9.state.fullWidth ~= p11.fullWidth then
		local chatSettings = p9.props.chatSettings
		local v32 = getSizeSpringFromSettings(chatSettings)

		p9.widthMotor:setGoal(v32(p9.state.fullWidth))
	end
end
function v10.didMount(p12) -- line: 167
	-- upvalues: getSizeSpringFromSettings (copy), getTransparencySpringFromSettings (copy)
	if not p12.props.fadingOut then
		local chatSettings = p12.props.chatSettings
		local v35 = getSizeSpringFromSettings(chatSettings)
		local v36 = getTransparencySpringFromSettings(chatSettings)

		p12.transparencyMotor:setGoal(v36(p12.props.chatSettings.Transparency))
		p12.widthMotor:setGoal(v35(p12.state.fullWidth))
	end
end
function v10.willUnmount(p13) -- line: 178
	p13.transparencyMotor:destroy()
	p13.widthMotor:destroy()
end

return v10
