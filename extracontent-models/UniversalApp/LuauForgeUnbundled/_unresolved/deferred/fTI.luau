local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local UIBlox = require(CorePackages.Packages.UIBlox)
local springAnimatedItem = UIBlox.Utility.SpringAnimatedItem

local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local module3 = require("@luauforge/deferred/fTJ")
local module4 = require("@luauforge/bundled/dYW")
local module5 = require("@luauforge/bundled/fTK")
local module6 = require("@luauforge/bundled/fNe")

local wrapped = springAnimatedItem.wrap(FitChildren.FitFrame)

local extended = Roact.PureComponent:extend("SignUpLayout")

extended.defaultProps = { widgetScaleWideMode = 0.3, showDisclaimerLinks = false }

function extended:init()
	self.state = {
		containerSize = self.props.screenSize,
		mainContentsSize = Vector2.new(0, 250),
		keyboardSize = Vector2.new(0, 0)
	}

	self.isMounted = false

	function self.onAbsoluteSizeChanged(p2)
		local absoluteSize = p2.AbsoluteSize

		if absoluteSize.X > 0 and absoluteSize.Y > 0 then
			spawn(function()
				if self.isMounted then
					self:setState({ containerSize = absoluteSize })
				end
			end)
		end
	end

	function self.onMainContentsAbsoluteSizeChanged(p2)
		local absoluteSize = p2.AbsoluteSize
		local mainContentsSize = self.state.mainContentsSize

		if absoluteSize.X > 0 and absoluteSize.Y > 0 and mainContentsSize ~= absoluteSize then
			spawn(function()
				if self.isMounted then
					self:setState({ mainContentsSize = absoluteSize })
				end
			end)
		end
	end

	function self.getSpringFrequency()
		return 1 / math.max(UserInputService.OnScreenKeyboardAnimationDuration, 0.1)
	end

	self.keyboardEvent = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):connect(function()
		spawn(function()
			if self.isMounted then
				self:setState({ keyboardSize = UserInputService.OnScreenKeyboardSize })
			end
		end)
	end)
end

function extended:didMount()
	self.isMounted = true
end

function extended:willUnmount()
	self.isMounted = false

	if self.keyboardEvent then
		self.keyboardEvent:disconnect()
		self.keyboardEvent = nil
	end
end

function extended:renderCharacter()
	local renderCharacter = self.props.renderCharacter
	local y = self.state.keyboardSize.Y

	if not renderCharacter then
		return nil
	end

	local v5 = self.props.formFactor == formFactor.WIDE

	local springFrequency = self.getSpringFrequency()
	local v6, v7

	if y == 0 then
		v6 = 0.5
		v7 = 0.5
	else
		v6 = 0
		v7 = 0
	end

	local v8 = {
		SizeConstraint = not v5 and Roact.createElement("UISizeConstraint", {
			MinSize = Vector2.new(250, 250)
		}),
		AspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1,
			AspectType = Enum.AspectType.FitWithinMaxSize
		}),
		Character = renderCharacter()
	}

	if not v5 then
		return Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(0.9, 0, 0.9, 0),
				Position = UDim2.new(0.5, 0, 0, self.state.mainContentsSize.Y),
				AnchorPoint = Vector2.new(0.5, 0)
			},
			v8
		)
	end

	return Roact.createElement(springAnimatedItem.AnimatedFrame, {
		regularProps = {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.5, 0, 0.6, 0),
			[Roact.Children] = v8
		},
		animatedValues = { avatarPositionYScale = v6, avatarAnchorPointY = v7 },
		mapValuesToProps = function(p2)
			return {
				Position = UDim2.new(0.525, 0, p2.avatarPositionYScale, 0),
				AnchorPoint = Vector2.new(0, p2.avatarAnchorPointY)
			}
		end,
		springOptions = { frequency = springFrequency }
	})
end

function extended:render()
	local titleTextKey = self.props.titleTextKey
	local paragraphTextKeys = self.props.paragraphTextKeys
	local renderWidget = self.props.renderWidget
	local formFactor2 = self.props.formFactor
	local showDisclaimerLinks = self.props.showDisclaimerLinks
	local widgetScaleWideMode = self.props.widgetScaleWideMode
	local disablePageInteraction = self.props.disablePageInteraction

	local v5 = formFactor2 == formFactor.WIDE

	local containerSize = self.state.containerSize
	local y = self.state.keyboardSize.Y
	local y2 = self.state.mainContentsSize.Y

	local springFrequency = self.getSpringFrequency()

	local udim = UDim2.new(0.525, 0, 0.5, 0)
	local vector2 = Vector2.new(1, 0.5)
	local v6

	if containerSize.X < 16000 / 21 then
		udim = UDim2.new(0, 0, 0.5, 0)
		vector2 = Vector2.new(0, 0.5)
		v6 = containerSize.X * 0.525
	else
		v6 = 400
	end

	if not v5 then
		v6 = containerSize.X - 40
	end

	if v5 and UserInputService.OnScreenKeyboardVisible then
		udim = UDim2.new(udim.X.Scale, 0, 0, 0)
		vector2 = Vector2.new(vector2.X, 0)
	end

	local v7, v8

	if v5 then
		v7 = math.max(containerSize.Y * widgetScaleWideMode, 190)
		v8 = 12
	else
		v8 = 5
		v7 = 190
	end

	local function fn()
		return Roact.createElement(FitChildren.FitFrame, {
			Size = UDim2.new(1, 0, 0, 0),
			fitAxis = FitChildren.FitAxis.Height,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			[Roact.Change.AbsoluteSize] = self.onMainContentsAbsoluteSizeChanged
		}, {
			ListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding = not v5 and Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 20),
				PaddingRight = UDim.new(0, 20)
			}),
			Roact.createElement(FitChildren.FitFrame, {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}, {
				ListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, v8)
				}),
				TitleAndParagraph = Roact.createElement(module5, {
					layoutOrder = 2,
					titleTextKey = titleTextKey,
					paragraphTextKeys = paragraphTextKeys,
					width = v6
				})
			}),
			DisclaimerLinks = showDisclaimerLinks and Roact.createElement(module6, {
				LayoutOrder = 3
			})
		})
	end

	local v9

	if v5 then
		v9 = { Container = 0 }
		v9.Container = Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, -20),
				AnchorPoint = Vector2.new(0.5, 0)
			},
			{
				TopPaddingFrame = Roact.createElement(wrapped, {
					regularProps = {
						Size = UDim2.new(0.525, 0, 1, 0),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						fitAxis = FitChildren.FitAxis.Height,
						[Roact.Children] = {
							SizeConstraint = Roact.createElement("UISizeConstraint", {
								MaxSize = Vector2.new(400, 1e999)
							}),
							Content = Roact.createElement(module3, {
								size = UDim2.new(1, 0, 0, 0),
								fitAxis = FitChildren.FitAxis.Height,
								Padding = UDim.new(0, 12),
								renderItemList = {
									Roact.createElement(fn),
									Roact.createElement(
										FitChildren.FitFrame,
										{
											Size = UDim2.new(1, 0, 0, 0),
											fitAxis = FitChildren.FitAxis.Height,
											BorderSizePixel = 0,
											BackgroundTransparency = 1
										},
										{
											Widget = renderWidget and renderWidget({
												formFactor = formFactor2,
												widgetHeight = v7
											})
										}
									)
								}
							})
						}
					},
					animatedValues = {
						contentPositionYScale = udim.Y.Scale,
						contentAnchorPointY = vector2.Y
					},
					mapValuesToProps = function(p2)
						return {
							Position = UDim2.new(udim.X.Scale, udim.X.Offset, p2.contentPositionYScale, 0),
							AnchorPoint = Vector2.new(vector2.X, p2.contentAnchorPointY)
						}
					end,
					springOptions = { frequency = springFrequency }
				})
			}
		)
	else
		local udim2 = UDim2.new(0.5, 0, 1, 0)
		local vector2_2 = Vector2.new(0.5, 1)

		v9 = {
			MinHeight = Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(0, 190 + y2)
			}),
			MainContents = Roact.createElement(fn),
			WidgetWrapper = Roact.createElement(FitChildren.FitFrame, {
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Position = udim2,
				AnchorPoint = vector2_2,
				ZIndex = 2
			}, {
				Widget = renderWidget and renderWidget({
					formFactor = formFactor2,
					widgetHeight = v7
				})
			})
		}
	end

	return Roact.createElement(module4, {
		BackgroundTransparency = 1,
		includeStatusBar = true,
		renderFullscreenBackground = function()
			return Roact.createElement("ImageLabel", {
				Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/gradient_bg.jpg",
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				BorderSizePixel = 0
			})
		end
	}, {
		UserInputSink = disablePageInteraction and Roact.createElement("ImageButton", {
			ZIndex = 3,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = ""
		}),
		ContentFrame = Roact.createElement(springAnimatedItem.AnimatedFrame, {
			regularProps = {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ZIndex = 2,
				[Roact.Change.AbsoluteSize] = self.onAbsoluteSizeChanged,
				[Roact.Children] = v9
			},
			animatedValues = { keyboardSizeY = y },
			mapValuesToProps = function(p2)
				return {
					Size = UDim2.new(1, 0, 1, -p2.keyboardSizeY)
				}
			end,
			springOptions = { frequency = springFrequency }
		}),
		Character = self:renderCharacter()
	})
end

return (RoactRodux.connect(function(p2, p3)
	return { formFactor = p2.FormFactor, screenSize = p2.ScreenSize }
end, function(callback)
	return {
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.back()
			end

			return callback(RobloxAppToastsRodux())
		end
	}
end)(extended))
