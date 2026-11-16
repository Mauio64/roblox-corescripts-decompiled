local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Roact = require(parent.Roact)
local Otter = require(parent.Otter)
local Timer = require(ExpChat.Timer)

local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Localization = require(ExpChat.Localization)

local FFlagExpChatUnmountTranslationFTUX = require(ExpChat.Flags.FFlagExpChatUnmountTranslationFTUX)

local gameSettings = UserSettings().GameSettings

local extended = Roact.Component:extend("ChatTranslationFTUX")
extended.defaultProps = { timer = Timer.new(10) }

local rbxassetfontsfamiliesBuilderSansjson = Font.new(
	"rbxasset://fonts/families/BuilderSans.json",
	Enum.FontWeight.Bold,
	Enum.FontStyle.Normal
)
local rbxassetfontsfamiliesBuilderSansjson2 = Font.new(
	"rbxasset://fonts/families/BuilderSans.json",
	Enum.FontWeight.Medium,
	Enum.FontStyle.Normal
)

local v = { dampingRatio = 1, frequency = 2 }

if game:GetEngineFeature("TextChatServiceSettingsSaved") then
	gameSettings.ChatTranslationFTUXShown = true
end

function extended:init()
	local binding, updateTransparency = Roact.createBinding(1)
	self.transparency = binding
	self.updateTransparency = updateTransparency
	self.transparencyMotor = Otter.createSingleMotor(1)
	self.transparencyMotor:onStep(self.updateTransparency)
end

function extended:render()
	if FFlagExpChatUnmountTranslationFTUX and self.state.isDismissed then
		return nil
	end

	return Roact.createElement(
		"Frame",
		{
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = UDim2.new(0, 10, 0, 20),
			Size = UDim2.new(0.25, 0, 0, 0),
			BackgroundTransparency = 1
		},
		{
			BubbleTail = Roact.createElement(ImageSetLabel, {
				Size = UDim2.new(0, 15, 0, 10),
				BackgroundTransparency = 1,
				ImageTransparency = self.transparency,
				ImageColor3 = Color3.new(0.5, 0.5, 0.5),
				Image = Images["component_assets/triangleUp_16"],
				Position = UDim2.new(0, 15, 0, -10),
				ZIndex = 100
			}),
			BubbleBody = Roact.createElement("Frame", {
				Active = true,
				BackgroundTransparency = self.transparency,
				BackgroundColor3 = Color3.new(0.5, 0.5, 0.5),
				AutomaticSize = Enum.AutomaticSize.XY,
				ZIndex = 100,
				Style = Enum.FrameStyle.Custom,
				[Roact.Event.TouchTap] = function()
					self:fadeOut()
				end,
				[Roact.Event.InputEnded] = function(_, p)
					if p.UserInputType == Enum.UserInputType.MouseButton1 then
						self:fadeOut()
					end
				end
			}, {
				RoundCorners = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 5) }),
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
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					Text = self.props.FTUXTitle == "" and "Chat translation is on for supported languages" or self.props.FTUXTitle,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextTransparency = self.transparency,
					FontFace = rbxassetfontsfamiliesBuilderSansjson,
					TextSize = 16,
					TextWrapped = true,
					BackgroundTransparency = 1,
					TextColor3 = Color3.new(1, 1, 1),
					ZIndex = 101,
					LayoutOrder = 1
				}),
				Body = Roact.createElement("TextLabel", {
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					Text = self.props.FTUXBody == "" and "Messages you send and receive will be translated automatically" or self.props.FTUXBody,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextTransparency = self.transparency,
					FontFace = rbxassetfontsfamiliesBuilderSansjson2,
					TextSize = 16,
					TextWrapped = true,
					BackgroundTransparency = 1,
					TextColor3 = Color3.new(1, 1, 1),
					ZIndex = 101,
					LayoutOrder = 2
				})
			})
		}
	)
end

function extended:fadeOut()
	if not self.isFadingOut then
		self.isFadingOut = true

		if FFlagExpChatUnmountTranslationFTUX then
			self.transparencyMotor:onComplete(function()
				self:setState({ isDismissed = true })
			end)
		end

		local function fn(p)
			return Otter.spring(p, v)
		end

		self.transparencyMotor:setGoal(fn(1))
	end
end

function extended:didMount()
	local function fn(p)
		return Otter.spring(p, v)
	end

	self.transparencyMotor:setGoal(fn(0))

	self.props.timer:start():andThen(function()
		self:fadeOut()
	end)
end

function extended.willUnmount(p)
	p.transparencyMotor:destroy()
end

return Localization.connect(function()
	return {
		FTUXTitle = "CoreScripts.TextChat.ChatTranslation.FTUX.TitleNew",
		FTUXBody = "CoreScripts.TextChat.ChatTranslation.FTUX.BodyNew"
	}
end)(extended)
