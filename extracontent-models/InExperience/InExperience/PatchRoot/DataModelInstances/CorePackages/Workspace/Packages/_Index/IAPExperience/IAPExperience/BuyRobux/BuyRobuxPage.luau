local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local LocalizationService = game:GetService("LocalizationService")
local GuiService = game:GetService("GuiService")
local Roact = require(scriptParentParentParent.Roact)
local RoactGamepad = require(scriptParentParentParent.RoactGamepad)
local Cryo = require(scriptParentParentParent.Cryo)
local UIBlox = require(scriptParentParentParent.UIBlox)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Images = UIBlox.App.ImageSet.Images
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Core.Style.withStyle
local useStyleMetadata = UIBlox.Core.Style.useStyleMetadata
local Constants = UIBlox.App.Style.Constants
local RoactFitComponents = require(scriptParentParentParent.RoactFitComponents)
local FitFrameHorizontal = RoactFitComponents.FitFrameHorizontal
local FitTextLabel = RoactFitComponents.FitTextLabel
local FullscreenFrame = require(scriptParentParentParent.AppBlox).FullscreenFrame
local MultiTextLocalizer = require(scriptParentParent.Locale.MultiTextLocalizer)
local formatNumber = require(scriptParentParent.Utility.formatNumber)
local Animator = require(scriptParentParent.Generic.Animator)
local getEnableCompensatingScrollingFrame = require(scriptParentParent.Flags.getEnableCompensatingScrollingFrame)
local getUserInputEventData = require(scriptParentParent.Utility.getUserInputEventData)
local RobuxPackage = require(scriptParent.RobuxPackage)
local FFlagEnableLeftNavOnConsole = require(scriptParentParentParent.SharedFlags).FFlagEnableLeftNavOnConsole
local v29 = Roact.Component:extend(script.Name)
local v30 = Images["icons/common/goldrobux"]
local v31 = Images["icons/logo/block"]
local t1 = {
	Images["icons/graphic/robuxcoin1_xxlarge"],
	Images["icons/graphic/robuxcoin2_xxlarge"],
	Images["icons/graphic/robuxcoin3_xxlarge"],
	Images["icons/graphic/robuxcoin4_xxlarge"],
	Images["icons/graphic/robuxcoin5_xxlarge"],
	Images["icons/graphic/robuxcoin6_xxlarge"]
}
local v33 = Images["icons/navigation/close"]

function v29.init(p1) -- line: 81
	-- upvalues: RoactGamepad (copy), Roact (copy), GuiService (copy)
	p1.state = {
		selectedPackage = nil,
		showMessageBanner = false
	}
	p1.buttonRefs = RoactGamepad.createRefCache()
	p1.scrollingFrameRef = Roact.createRef()

	function p1.getGamepadNextSelectionLeft(p2) -- line: 90
		-- upvalues: p1 (copy)
		return p2 > 1 and p1.buttonRefs[p2 - 1] or nil
	end
	function p1.getGamepadNextSelectionRight(p3) -- line: 94
		-- upvalues: p1 (copy)
		return p3 < #p1.buttonRefs and p1.buttonRefs[p3 + 1] or nil
	end
	function p1.initSelectionChangedListener() -- line: 98
		-- upvalues: p1 (copy), GuiService (copy)
		if p1.selectionListener ~= nil then
			p1.selectionListener:Disconnect()
			p1.selectionListener = nil
		end

		if p1.selectionListener ~= nil then
			p1.selectionListener:Disconnect()
			p1.selectionListener = nil
		end

		p1.selectionListener = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 109
			-- upvalues: p1 (copy), GuiService (copy)
			if p1.state.selectedPackage == nil or (GuiService.SelectedCoreObject == nil or p1.state.selectedPackage ~= GuiService.SelectedCoreObject) then
				p1:setState({
					selectedPackage = GuiService.SelectedCoreObject
				})
			end
		end)
	end
end
function v29.didMount(p4) -- line: 121
	p4.initSelectionChangedListener()
end
function v29.didUpdate(t2: {[any]: any}, t3: {[any]: any}, _: {[any]: any}) -- line: 125
	local props = t2.props

	if t3.hasNativePurchaseSucceeded ~= props.hasNativePurchaseSucceeded and props.hasNativePurchaseSucceeded then
		t2:setState({
			showMessageBanner = true
		})
		task.delay(3, function() -- line: 131
			-- upvalues: t2 (copy)
			t2:setState({
				showMessageBanner = false
			})
		end)
	end
end
function v29.willUnmount(p5) -- line: 138
	if p5.selectionListener ~= nil then
		p5.selectionListener:Disconnect()
		p5.selectionListener = nil
	end
end
function v29.getScale(p6) -- line: 146
	if p6.props.isConsoleSize then
		return 1
	end

	return 0.65
end
function v29.render(p7) -- line: 156
	-- upvalues: Roact (copy), MultiTextLocalizer (copy), withSelectionCursorProvider (copy)
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			BannerText = {
				key = "IAPExperience.BuyRobux.Banner.Text"
			},
			BannerTitle = {
				key = "IAPExperience.BuyRobux.Banner.Title"
			},
			SuccessfulMessage = {
				key = "IAPExperience.BuyRobux.Alert.SuccessfulMessage"
			}
		},
		render = function(t5: {[any]: any}) -- line: 169
			-- upvalues: withSelectionCursorProvider (copy), p7 (copy)
			return withSelectionCursorProvider(function(p8) -- line: 170
				-- upvalues: p7 (copy), t5 (copy)
				return p7:renderWithLocale(t5, p8)
			end)
		end
	})
end
function v29.movePackageToAttentionArea(t6: {[any]: any}, p9) -- line: 178
	-- upvalues: getEnableCompensatingScrollingFrame (copy)
	if not getEnableCompensatingScrollingFrame() then
		return
	end

	local current = t6.scrollingFrameRef.current

	if current == nil or p9 == nil then
		return
	end

	local AbsoluteSizeX = current.AbsoluteSize.X
	local v47 = 48 * t6:getScale()
	local v48 = p9.AbsolutePosition.X - v47

	if v48 < 0 then
		current.CanvasPosition = Vector2.new(v48, 0)
		t6:reportScrollingFrameCompensationHappened()

		return
	end

	if AbsoluteSizeX < p9.AbsolutePosition.X + p9.AbsoluteSize.X + v47 then
		current.CanvasPosition = Vector2.new(v48, 0)
		t6:reportScrollingFrameCompensationHappened()

		return
	end
end
function v29.reportScrollingFrameCompensationHappened(p10) -- line: 207
	-- upvalues: getUserInputEventData (copy)
	local props = p10.props

	if not props.onAnalyticEvent then
		return
	end

	local v51 = getUserInputEventData(props.analyticId, "", "BuyRobux", "ScrollingFrame", "Compensated")

	props.onAnalyticEvent("UserPurchaseFlow", v51)
end
function v29.renderWithLocale(t7: {[any]: any}, t8: {[any]: any}, p11) -- line: 218
	-- upvalues: withStyle (copy), Roact (copy), RobuxPackage (copy), t1 (copy), FFlagEnableLeftNavOnConsole (copy), FullscreenFrame (copy), RoactGamepad (copy), Constants (copy), ImageSetButton (copy), v33 (copy), CursorKind (copy), Animator (copy), ImageSetLabel (copy), v31 (copy), FitTextLabel (copy), FitFrameHorizontal (copy), v30 (copy), formatNumber (copy), LocalizationService (copy)
	local props = t7.props

	return withStyle(function(p12) -- line: 221
		-- upvalues: props (copy), t7 (copy), Roact (copy), RobuxPackage (copy), t1 (copy), FFlagEnableLeftNavOnConsole (copy), FullscreenFrame (copy), RoactGamepad (copy), Constants (copy), ImageSetButton (copy), v33 (copy), p11 (copy), CursorKind (copy), Animator (copy), ImageSetLabel (copy), v31 (copy), FitTextLabel (copy), t8 (copy), FitFrameHorizontal (copy), v30 (copy), formatNumber (copy), LocalizationService (copy)
		local Theme = p12.Theme
		local p12Font = p12.Font
		local v64 = props.robuxPackages ~= nil
		local v65 = props.robuxPackages == nil and 6 or #props.robuxPackages
		local v66 = 32 * t7:getScale()
		local t9 = {
			LeadingPadding = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				Size = UDim2.new(0, 80 * t7:getScale(), 0, 1)
			}),
			RobuxPackageChildren = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 16 * t7:getScale())
			}),
			TrailingPadding = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = v65 + 1,
				Size = UDim2.new(0, 80 * t7:getScale(), 0, 1)
			})
		}

		for i = 1, v65 do
			t9[i + 1] = Roact.createElement(RobuxPackage, {
				layoutOrder = i,
				scale = t7:getScale(),
				selected = t7.state.selectedPackage ~= nil and t7.state.selectedPackage == t7.buttonRefs[i]:getValue(),
				packageId = if not v64 then tostring(i) else props.robuxPackages[i].packageId,
				robuxAmount = if not v64 then nil else props.robuxPackages[i].robuxAmount,
				currencyAmountStr = if not v64 then nil else props.robuxPackages[i].currencyAmountStr,
				robuxMoreAmount = if not v64 then nil else props.robuxPackages[i].robuxMoreAmount,
				robuxImage = t1[i],
				forwardRef = t7.buttonRefs[i],
				nextSelectionLeft = t7.getGamepadNextSelectionLeft(i),
				nextSelectionRight = t7.getGamepadNextSelectionRight(i),
				onActivated = function(s1: string?) -- line: 271
					-- upvalues: props (copy)
					props.robuxPackageActivated(s1)
				end,
				onSelect = function(p13) -- line: 274
					-- upvalues: t7 (copy)
					t7:movePackageToAttentionArea(p13:getValue())
				end,
				onHover = function(p14, b1: boolean) -- line: 277
					-- upvalues: t7 (copy)
					if b1 then
						if t7.state.selectedPackage ~= p14:getValue() then
							t7:setState({
								selectedPackage = p14:getValue()
							})

							return
						end
					else
						t7:setState({
							selectedPackage = ""
						})
					end
				end
			})
		end

		return Roact.createElement(if not FFlagEnableLeftNavOnConsole then RoactGamepad.Focusable.Frame else FullscreenFrame, {
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = not FFlagEnableLeftNavOnConsole and 0.8 or 0,
			Size = if not FFlagEnableLeftNavOnConsole then UDim2.new(1, 0, 1, 0) else nil
		}, {
			BuyRobuxPageBackground = Roact.createElement("Frame", {
				BackgroundTransparency = 0,
				ZIndex = 0,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				Visible = t7.props.showBackground
			}, {
				BackgroundImage = Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					ImageTransparency = 0,
					Image = props.themeName ~= Constants.ThemeName.Dark and "rbxasset://textures/AvatarEditorImages/AvatarEditor_LightTheme.png" or "rbxasset://textures/AvatarEditorImages/AvatarEditor.png",
					Size = UDim2.new(1, 0, 1, 0)
				}),
				Backdrop = Roact.createElement("Frame", {
					BackgroundTransparency = props.themeName ~= Constants.ThemeName.Dark and 0.7 or 0.5,
					BackgroundColor3 = Color3.new(0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0)
				})
			}),
			CloseButton = Roact.createElement(ImageSetButton, {
				Position = UDim2.new(0, 48 * t7:getScale(), 0, 48 * t7:getScale()),
				AnchorPoint = Vector2.new(0, 0),
				Size = UDim2.new(0, 36, 0, 36),
				Image = v33,
				BackgroundColor3 = Color3.new(0, 0, 0),
				BackgroundTransparency = 0.7,
				BorderSizePixel = 0,
				SelectionImageObject = p11(CursorKind.RoundedRect),
				Visible = t7.props.showCloseButton,
				[Roact.Event.Activated] = props.onPageClose
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 16 * t7:getScale())
				})
			}),
			MessageBannerAnimator = Roact.createElement(Animator, {
				animateDown = true,
				ZIndex = 10,
				shouldAnimate = props.shouldAnimate,
				shouldShow = t7.state.showMessageBanner,
				renderChildren = function() -- line: 344
					-- upvalues: Roact (copy), props (copy), Constants (copy), t7 (copy), v66 (copy), ImageSetLabel (copy), v31 (copy), Theme (copy), FitTextLabel (copy), t8 (copy), p12Font (copy)
					return Roact.createElement("Frame", {
						BackgroundTransparency = 0,
						AnchorPoint = Vector2.new(0, 0),
						BackgroundColor3 = if props.themeName ~= Constants.ThemeName.Dark then Color3.fromRGB(198, 203, 206) else Color3.fromRGB(17, 18, 20),
						Position = UDim2.fromOffset(48 * t7:getScale(), 40 * t7:getScale()),
						Size = UDim2.new(1, -96 * t7:getScale(), 0, v66 * 2)
					}, {
						UICorner = Roact.createElement("UICorner", {
							CornerRadius = UDim.new(0, 16 * t7:getScale())
						}),
						Icon = Roact.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							ImageTransparency = 0,
							AnchorPoint = Vector2.new(0, 0.5),
							Image = v31,
							ImageColor3 = Theme.TextEmphasis.Color,
							Position = UDim2.fromOffset(24 * t7:getScale(), v66),
							Size = UDim2.fromOffset(36 * t7:getScale(), 36 * t7:getScale())
						}),
						AlertMessage = Roact.createElement(FitTextLabel, {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.fromOffset(80 * t7:getScale(), v66),
							width = FitTextLabel.Width.FitToText,
							Text = t8.SuccessfulMessage,
							Font = p12Font.Header1.Font,
							TextColor3 = Theme.TextEmphasis.Color,
							TextTransparency = Theme.TextEmphasis.Transparency,
							TextSize = v66,
							TextXAlignment = Enum.TextXAlignment.Left
						})
					})
				end
			}),
			RobuxBalanceFrame = Roact.createElement(FitFrameHorizontal, {
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -96 * t7:getScale(), 0, 48 * t7:getScale()),
				AnchorPoint = Vector2.new(1, 0),
				height = UDim.new(0, v66),
				contentPadding = UDim.new(0, 4),
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}, {
				Icon = Roact.createElement(ImageSetLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					ImageTransparency = 0,
					Size = UDim2.fromOffset(v66 + 15 * t7:getScale(), v66 + 15 * t7:getScale()),
					Image = v30
				}),
				BalanceText = Roact.createElement(FitTextLabel, {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					width = FitTextLabel.Width.FitToText,
					Text = not props.robuxBalance and "" or formatNumber(LocalizationService.RobloxLocaleId, props.robuxBalance),
					Font = p12Font.Header1.Font,
					TextColor3 = if not props.showBackground then Theme.TextEmphasis.Color else Color3.new(255, 255, 255),
					TextTransparency = Theme.TextEmphasis.Transparency,
					TextSize = v66
				})
			}),
			BannerFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 96 * t7:getScale(), 0, 146 * t7:getScale()),
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 36 * t7:getScale())
				}),
				BannerTitle = Roact.createElement("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					Font = p12Font.Title.Font,
					Text = t8.BannerTitle,
					TextSize = 46 * t7:getScale(),
					TextColor3 = if not props.showBackground then Theme.TextEmphasis.Color else Color3.new(255, 255, 255)
				}),
				BannerText = Roact.createElement("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					Font = p12Font.Header1.Font,
					Text = t8.BannerText,
					TextSize = 38 * t7:getScale(),
					TextColor3 = if not props.showBackground then Theme.TextEmphasis.Color else Color3.new(255, 255, 255)
				})
			}),
			RobuxPackageTilesFrame = Roact.createElement("ScrollingFrame", {
				Position = UDim2.new(0, 0, 0, 310 * t7:getScale()),
				Size = UDim2.new(1, 0, 0, 615 * t7:getScale()),
				AutomaticSize = Enum.AutomaticSize.None,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				ScrollingEnabled = v64,
				ScrollingDirection = Enum.ScrollingDirection.X,
				ScrollBarImageTransparency = 1,
				ScrollBarThickness = 0,
				Selectable = false,
				BackgroundTransparency = 1,
				[Roact.Ref] = t7.scrollingFrameRef
			}, t9)
		})
	end)
end

return function(p15) -- line: 498
	-- upvalues: useStyleMetadata (copy), Roact (copy), v29 (copy), Cryo (copy)
	local ThemeName = useStyleMetadata().ThemeName

	return Roact.createElement(v29, Cryo.Dictionary.join(p15, {
		themeName = ThemeName
	}))
end
