local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local SpringAnimatedItem = require(CorePackages.Packages.UIBlox).Utility.SpringAnimatedItem
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local FitChildren = require(Modules.LuaApp.FitChildren)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v11 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local ItemListLayout = require(Modules.LuaApp.Components.Generic.ItemListLayout)
local FullscreenPageWithSafeArea = require(Modules.LuaApp.Components.FullscreenPageWithSafeArea)
local TitleAndParagraph = require(Modules.LuaApp.Components.Authentication.TitleAndParagraph)
local DisclaimerLinks = require(Modules.LuaApp.Components.Authentication.DisclaimerLinks)
local v16 = SpringAnimatedItem.wrap(FitChildren.FitFrame)
local v17 = Roact.PureComponent:extend("SignUpLayout")

v17.defaultProps = {
	widgetScaleWideMode = 0.3,
	showDisclaimerLinks = false
}

function v17.init(p1) -- line: 48
	-- upvalues: UserInputService (copy)
	p1.state = {
		containerSize = p1.props.screenSize,
		mainContentsSize = Vector2.new(0, 250),
		keyboardSize = Vector2.new(0, 0)
	}
	p1.isMounted = false

	function p1.onAbsoluteSizeChanged(p2) -- line: 57
		-- upvalues: p1 (copy)
		local AbsoluteSize = p2.AbsoluteSize

		if AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 then
			spawn(function() -- line: 63
				-- upvalues: p1 (copy), AbsoluteSize (copy)
				if p1.isMounted then
					p1:setState({
						containerSize = AbsoluteSize
					})
				end
			end)
		end
	end
	function p1.onMainContentsAbsoluteSizeChanged(p3) -- line: 73
		-- upvalues: p1 (copy)
		local AbsoluteSize = p3.AbsoluteSize
		local mainContentsSize = p1.state.mainContentsSize

		if AbsoluteSize.X > 0 and (AbsoluteSize.Y > 0 and mainContentsSize ~= AbsoluteSize) then
			spawn(function() -- line: 80
				-- upvalues: p1 (copy), AbsoluteSize (copy)
				if p1.isMounted then
					p1:setState({
						mainContentsSize = AbsoluteSize
					})
				end
			end)
		end
	end
	function p1.getSpringFrequency() -- line: 90
		-- upvalues: UserInputService (copy)
		return 1 / math.max(UserInputService.OnScreenKeyboardAnimationDuration, 0.1)
	end

	p1.keyboardEvent = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):connect(function() -- line: 96
		-- upvalues: p1 (copy), UserInputService (copy)
		spawn(function() -- line: 97
			-- upvalues: p1 (copy), UserInputService (copy)
			if p1.isMounted then
				p1:setState({
					keyboardSize = UserInputService.OnScreenKeyboardSize
				})
			end
		end)
	end)
end
function v17.didMount(p4) -- line: 107
	p4.isMounted = true
end
function v17.willUnmount(p5) -- line: 111
	p5.isMounted = false

	if p5.keyboardEvent then
		p5.keyboardEvent:disconnect()
		p5.keyboardEvent = nil
	end
end
function v17.renderCharacter(p6) -- line: 119
	-- upvalues: FormFactor (copy), Roact (copy), SpringAnimatedItem (copy)
	local renderCharacter = p6.props.renderCharacter
	local keyboardSizeY = p6.state.keyboardSize.Y

	if renderCharacter then
		local v24 = p6.props.formFactor == FormFactor.WIDE
		local v25 = p6.getSpringFrequency()
		local n1 = 0.5
		local n2 = 0.5

		if keyboardSizeY ~= 0 then
			n1 = 0
			n2 = 0
		end

		local t1 = {
			SizeConstraint = not v24 and Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(250, 250)
			}),
			AspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1,
				AspectType = Enum.AspectType.FitWithinMaxSize
			}),
			Character = renderCharacter()
		}

		if v24 then
			return Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
				regularProps = {
					BackgroundTransparency = 1,
					Size = UDim2.new(0.5, 0, 0.6, 0),
					[Roact.Children] = t1
				},
				animatedValues = {
					avatarPositionYScale = n1,
					avatarAnchorPointY = n2
				},
				mapValuesToProps = function(p7) -- line: 157
					return {
						Position = UDim2.new(0.525, 0, p7.avatarPositionYScale, 0),
						AnchorPoint = Vector2.new(0, p7.avatarAnchorPointY)
					}
				end,
				springOptions = {
					frequency = v25
				}
			})
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.9, 0, 0.9, 0),
			Position = UDim2.new(0.5, 0, 0, p6.state.mainContentsSize.Y),
			AnchorPoint = Vector2.new(0.5, 0)
		}, t1)
	end

	return nil
end
function v17.render(p8) -- line: 180
	-- upvalues: FormFactor (copy), UserInputService (copy), Roact (copy), FitChildren (copy), TitleAndParagraph (copy), DisclaimerLinks (copy), v16 (copy), ItemListLayout (copy), FullscreenPageWithSafeArea (copy), SpringAnimatedItem (copy)
	local titleTextKey = p8.props.titleTextKey
	local paragraphTextKeys = p8.props.paragraphTextKeys
	local renderWidget = p8.props.renderWidget
	local formFactor = p8.props.formFactor
	local showDisclaimerLinks = p8.props.showDisclaimerLinks
	local widgetScaleWideMode = p8.props.widgetScaleWideMode
	local disablePageInteraction = p8.props.disablePageInteraction
	local v37 = formFactor == FormFactor.WIDE
	local containerSize = p8.state.containerSize
	local keyboardSizeY = p8.state.keyboardSize.Y
	local mainContentsSizeY = p8.state.mainContentsSize.Y
	local v41 = p8.getSpringFrequency()
	local uDim2 = UDim2.new(0.525, 0, 0.5, 0)
	local vector2 = Vector2.new(1, 0.5)
	local n3 = 400

	if containerSize.X < 761.9047619047619 then
		uDim2 = UDim2.new(0, 0, 0.5, 0)
		vector2 = Vector2.new(0, 0.5)
		n3 = containerSize.X * 0.525
	end

	if not v37 then
		n3 = containerSize.X - 40
	end

	if v37 and UserInputService.OnScreenKeyboardVisible then
		uDim2 = UDim2.new(uDim2.X.Scale, 0, 0, 0)
		vector2 = Vector2.new(vector2.X, 0)
	end

	local n4 = 190
	local n5

	if v37 then
		n4 = math.max(containerSize.Y * widgetScaleWideMode, 190)
		n5 = 12
	else
		n5 = 5
	end

	local function v47() -- line: 225
		-- upvalues: Roact (copy), FitChildren (copy), p8 (copy), v37 (copy), n5 (ref), TitleAndParagraph (copy), titleTextKey (copy), paragraphTextKeys (copy), n3 (ref), showDisclaimerLinks (copy), DisclaimerLinks (copy)
		return Roact.createElement(FitChildren.FitFrame, {
			Size = UDim2.new(1, 0, 0, 0),
			fitAxis = FitChildren.FitAxis.Height,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			[Roact.Change.AbsoluteSize] = p8.onMainContentsAbsoluteSizeChanged
		}, {
			ListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding = not v37 and Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 20),
				PaddingRight = UDim.new(0, 20)
			}),
			Roact.createElement(FitChildren.FitFrame, {
				LayoutOrder = 1,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height
			}, {
				ListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, n5)
				}),
				TitleAndParagraph = Roact.createElement(TitleAndParagraph, {
					layoutOrder = 2,
					titleTextKey = titleTextKey,
					paragraphTextKeys = paragraphTextKeys,
					width = n3
				})
			}),
			DisclaimerLinks = showDisclaimerLinks and Roact.createElement(DisclaimerLinks, {
				LayoutOrder = 3
			})
		})
	end

	local t2

	if v37 then
		t2 = {
			Container = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, -20),
				AnchorPoint = Vector2.new(0.5, 0)
			}, {
				TopPaddingFrame = Roact.createElement(v16, {
					regularProps = {
						Size = UDim2.new(0.525, 0, 1, 0),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						fitAxis = FitChildren.FitAxis.Height,
						[Roact.Children] = {
							SizeConstraint = Roact.createElement("UISizeConstraint", {
								MaxSize = Vector2.new(400, 1e999)
							}),
							Content = Roact.createElement(ItemListLayout, {
								size = UDim2.new(1, 0, 0, 0),
								fitAxis = FitChildren.FitAxis.Height,
								Padding = UDim.new(0, 12),
								renderItemList = {
									Roact.createElement(v47),
									Roact.createElement(FitChildren.FitFrame, {
										BorderSizePixel = 0,
										BackgroundTransparency = 1,
										Size = UDim2.new(1, 0, 0, 0),
										fitAxis = FitChildren.FitAxis.Height
									}, {
										Widget = renderWidget and renderWidget({
											formFactor = formFactor,
											widgetHeight = n4
										})
									})
								}
							})
						}
					},
					animatedValues = {
						contentPositionYScale = uDim2.Y.Scale,
						contentAnchorPointY = vector2.Y
					},
					mapValuesToProps = function(p9) -- line: 309
						-- upvalues: uDim2 (ref), vector2 (ref)
						return {
							Position = UDim2.new(uDim2.X.Scale, uDim2.X.Offset, p9.contentPositionYScale, 0),
							AnchorPoint = Vector2.new(vector2.X, p9.contentAnchorPointY)
						}
					end,
					springOptions = {
						frequency = v41
					}
				})
			})
		}
	else
		local uDim2_2 = UDim2.new(0.5, 0, 1, 0)
		local vector2_2 = Vector2.new(0.5, 1)

		t2 = {
			MinHeight = Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(0, 190 + mainContentsSizeY)
			}),
			MainContents = Roact.createElement(v47),
			WidgetWrapper = Roact.createElement(FitChildren.FitFrame, {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				Position = uDim2_2,
				AnchorPoint = vector2_2
			}, {
				Widget = renderWidget and renderWidget({
					formFactor = formFactor,
					widgetHeight = n4
				})
			})
		}
	end

	return Roact.createElement(FullscreenPageWithSafeArea, {
		BackgroundTransparency = 1,
		includeStatusBar = true,
		renderFullscreenBackground = function() -- line: 355
			-- upvalues: Roact (copy)
			return Roact.createElement("ImageLabel", {
				Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/gradient_bg.jpg",
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0)
			})
		end
	}, {
		UserInputSink = disablePageInteraction and Roact.createElement("ImageButton", {
			ZIndex = 3,
			BackgroundTransparency = 1,
			Image = "",
			Size = UDim2.new(1, 0, 1, 0)
		}),
		ContentFrame = Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
			regularProps = {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ZIndex = 2,
				[Roact.Change.AbsoluteSize] = p8.onAbsoluteSizeChanged,
				[Roact.Children] = t2
			},
			animatedValues = {
				keyboardSizeY = keyboardSizeY
			},
			mapValuesToProps = function(p10) -- line: 382
				return {
					Size = UDim2.new(1, 0, 1, -p10.keyboardSizeY)
				}
			end,
			springOptions = {
				frequency = v41
			}
		}),
		Character = p8:renderCharacter()
	})
end

return (RoactRodux.connect(function(p11, _) -- line: 395
	return {
		formFactor = p11.FormFactor,
		screenSize = p11.ScreenSize
	}
end, function(p13) -- line: 400
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v11 (copy), NavigateBack (copy)
	return {
		navigateBack = function() -- line: 402
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v11 (copy), p13 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				return v11.back()
			end

			return p13(NavigateBack())
		end
	}
end)(v17))
