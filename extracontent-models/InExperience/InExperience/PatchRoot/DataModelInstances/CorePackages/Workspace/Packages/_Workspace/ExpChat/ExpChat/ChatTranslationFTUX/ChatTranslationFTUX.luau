local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Roact = require(ExpChatParent.Roact)
local Otter = require(ExpChatParent.Otter)
local Timer = require(ExpChat.Timer)
local UIBlox = require(ExpChatParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Localization = require(ExpChat.Localization)
local GameSettings = UserSettings().GameSettings
local v11 = Roact.Component:extend("ChatTranslationFTUX")

v11.defaultProps = {
	timer = Timer.new(10)
}

local font = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
local font2 = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local t1 = {
	dampingRatio = 1,
	frequency = 2
}

if game:GetEngineFeature("TextChatServiceSettingsSaved") then
	GameSettings.ChatTranslationFTUXShown = true
end

function v11.init(p1) -- line: 35
	-- upvalues: Roact (copy), Otter (copy)
	local v16, v17 = Roact.createBinding(1)

	p1.transparency = v16
	p1.updateTransparency = v17
	p1.transparencyMotor = Otter.createSingleMotor(1)
	p1.transparencyMotor:onStep(p1.updateTransparency)
end
function v11.render(p2) -- line: 41
	-- upvalues: Roact (copy), ImageSetLabel (copy), Images (copy), font (copy), font2 (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Position = UDim2.new(0, 10, 0, 20),
		Size = UDim2.new(0.25, 0, 0, 0)
	}, {
		BubbleTail = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			ZIndex = 100,
			Size = UDim2.new(0, 15, 0, 10),
			ImageTransparency = p2.transparency,
			ImageColor3 = Color3.new(0.5, 0.5, 0.5),
			Image = Images["component_assets/triangleUp_16"],
			Position = UDim2.new(0, 15, 0, -10)
		}),
		BubbleBody = Roact.createElement("Frame", {
			Active = true,
			BackgroundTransparency = p2.transparency,
			BackgroundColor3 = Color3.new(0.5, 0.5, 0.5),
			AutomaticSize = Enum.AutomaticSize.XY,
			ZIndex = 100,
			Style = Enum.FrameStyle.Custom,
			[Roact.Event.TouchTap] = function() -- line: 64
				-- upvalues: p2 (copy)
				p2:fadeOut()
			end,
			[Roact.Event.InputEnded] = function(_, p4) -- line: 67
				-- upvalues: p2 (copy)
				if p4.UserInputType == Enum.UserInputType.MouseButton1 then
					p2:fadeOut()
				end
			end
		}, {
			RoundCorners = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 5)
			}),
			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(300, 400)
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingRight = UDim.new(0, 10),
				PaddingTop = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 10)
			}),
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 10)
			}),
			Title = Roact.createElement("TextLabel", {
				TextSize = 16,
				TextWrapped = true,
				BackgroundTransparency = 1,
				ZIndex = 101,
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				Text = p2.props.FTUXTitle == "" and "Chat translation is on for supported languages" or p2.props.FTUXTitle,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextTransparency = p2.transparency,
				FontFace = font,
				TextColor3 = Color3.new(1, 1, 1)
			}),
			Body = Roact.createElement("TextLabel", {
				TextSize = 16,
				TextWrapped = true,
				BackgroundTransparency = 1,
				ZIndex = 101,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				Text = p2.props.FTUXBody == "" and "Messages you send and receive will be translated automatically" or p2.props.FTUXBody,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextTransparency = p2.transparency,
				FontFace = font2,
				TextColor3 = Color3.new(1, 1, 1)
			})
		})
	})
end
function v11.fadeOut(p5) -- line: 128
	-- upvalues: Otter (copy), t1 (copy)
	if not p5.isFadingOut then
		p5.isFadingOut = true
		p5.transparencyMotor:setGoal((function(p6) -- line: 132
			-- upvalues: Otter (copy), t1 (copy)
			return Otter.spring(p6, t1)
		end)(1))
	end
end
function v11.didMount(p7) -- line: 139
	-- upvalues: Otter (copy), t1 (copy)
	p7.transparencyMotor:setGoal((function(p8) -- line: 140
		-- upvalues: Otter (copy), t1 (copy)
		return Otter.spring(p8, t1)
	end)(0))
	p7.props.timer:start():andThen(function() -- line: 146
		-- upvalues: p7 (copy)
		p7:fadeOut()
	end)
end
function v11.willUnmount(p9) -- line: 151
	p9.transparencyMotor:destroy()
end

return Localization.connect(function() -- line: 155
	return {
		FTUXTitle = "CoreScripts.TextChat.ChatTranslation.FTUX.TitleNew",
		FTUXBody = "CoreScripts.TextChat.ChatTranslation.FTUX.BodyNew"
	}
end)(v11)
