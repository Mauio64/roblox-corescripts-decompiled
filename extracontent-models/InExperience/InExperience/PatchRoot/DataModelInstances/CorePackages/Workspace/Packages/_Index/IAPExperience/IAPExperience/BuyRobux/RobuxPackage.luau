local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LocalizationService = game:GetService("LocalizationService")
local Roact = require(ParentParentParent.Roact)

require(ParentParentParent.React)

local UIBlox = require(ParentParentParent.UIBlox)
local Foundation = require(ParentParentParent.Foundation)
local Skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens
local useStyleMetadata = UIBlox.Core.Style.useStyleMetadata
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Core.Style.withStyle
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local useCursor = UIBlox.App.SelectionCursor.useCursor
local Constants = UIBlox.App.Style.Constants
local RoactGamepad = require(ParentParentParent.RoactGamepad)
local RoactFitComponents = require(ParentParentParent.RoactFitComponents)
local FitFrameHorizontal = RoactFitComponents.FitFrameHorizontal
local FitTextLabel = RoactFitComponents.FitTextLabel
local MultiTextLocalizer = require(ParentParent.Locale.MultiTextLocalizer)
local formatNumber = require(ParentParent.Utility.formatNumber)
local FFlagEnableCoreContentTheme = require(ParentParentParent.SharedFlags).FFlagEnableCoreContentTheme
local v23 = Images["icons/common/robux"]

local function renderWithProviders(t1: {[any]: any}, p1, p2, p3, p4, p5) -- line: 62
	-- upvalues: Roact (copy), Skeleton (copy), FFlagEnableCoreContentTheme (copy), Constants (copy), RoactGamepad (copy), ImageSetButton (copy), ImageSetLabel (copy), FitFrameHorizontal (copy), v23 (copy), FitTextLabel (copy), formatNumber (copy), LocalizationService (copy)
	if t1.robuxAmount == nil then
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, t1.scale * 404, 0, t1.scale * 448)
		}, {
			ShimmerPanel = Roact.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 1, 0)
			})
		})
	end

	local Theme = p2.Theme
	local p2Font = p2.Font
	local v33 = t1.scale * 64
	local v34 = if not FFlagEnableCoreContentTheme then if p4 ~= Constants.ThemeName.Dark then Color3.fromRGB(242, 244, 245) else Color3.fromRGB(25, 27, 29) else p5.Color.Surface.Surface_100.Color3

	if t1.selected then
		v34 = if not FFlagEnableCoreContentTheme then if p4 ~= Constants.ThemeName.Dark then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(57, 59, 61) else v34:Lerp(p5.Color.Surface.Surface_200.Color3, 0.5)
	end

	return Roact.createElement(RoactGamepad.Focusable[ImageSetButton], {
		LayoutOrder = t1.layoutOrder,
		BackgroundColor3 = Theme.UIEmphasis.Color,
		BackgroundTransparency = Theme.UIEmphasis.Transparency,
		Size = UDim2.new(0, t1.scale * 404, 0, t1.scale * 448),
		Image = nil,
		SelectionImageObject = p3,
		[Roact.Ref] = t1.forwardRef,
		NextSelectionUp = nil,
		NextSelectionDown = nil,
		NextSelectionLeft = t1.nextSelectionLeft,
		NextSelectionRight = t1.nextSelectionRight,
		inputBindings = {
			Activated = if t1.onActivated == nil then nil else RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function() -- line: 112
				-- upvalues: t1 (copy)
				t1.onActivated(t1.packageId)
			end)
		},
		[Roact.Event.Activated] = function() -- line: 117
			-- upvalues: t1 (copy)
			t1.onActivated(t1.packageId)
		end,
		[Roact.Event.MouseMoved] = function() -- line: 120
			-- upvalues: t1 (copy)
			t1.onHover(t1.forwardRef, true)
		end,
		[Roact.Event.MouseEnter] = function() -- line: 123
			-- upvalues: t1 (copy)
			t1.onHover(t1.forwardRef, true)
		end,
		[Roact.Event.MouseLeave] = function() -- line: 126
			-- upvalues: t1 (copy)
			t1.onHover(t1.forwardRef, false)
		end,
		[Roact.Event.SelectionGained] = function() -- line: 129
			-- upvalues: t1 (copy)
			t1.onSelect(t1.forwardRef)
		end
	}, {
		Corner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		Outline = Roact.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundColor3 = v34,
			Size = UDim2.new(1, -3, 1, -3)
		}, {
			Corner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}),
			MiddleContent = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, t1.scale * 24)
				}),
				Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, t1.scale * 17.5)
				}),
				RobuxImageFrame = Roact.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(t1.scale * 192, t1.scale * 192),
					AnchorPoint = Vector2.new(0.5, 0.5)
				}, {
					RobuxImage = Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						ImageTransparency = 0,
						Size = if not t1.selected then UDim2.fromOffset(t1.scale * 192, t1.scale * 192) else UDim2.fromOffset(t1.scale * 192 * 1.6, t1.scale * 192 * 1.6),
						Position = if not t1.selected then UDim2.new(0.5, 0, 0.5, 0) else UDim2.new(0.5, 0, 0.3, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Image = t1.robuxImage
					})
				}),
				RobuxAmount = Roact.createElement(FitFrameHorizontal, {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					height = UDim.new(0, v33),
					contentPadding = UDim.new(0, 0),
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}, {
					Icon = Roact.createElement(ImageSetLabel, {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						Size = UDim2.new(0, v33, 0, v33),
						Image = v23,
						ImageColor3 = Theme.TextEmphasis.Color,
						ImageTransparency = Theme.TextEmphasis.Transparency
					}),
					RobuxAmountText = Roact.createElement(FitTextLabel, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						width = FitTextLabel.Width.FitToText,
						Text = formatNumber(LocalizationService.RobloxLocaleId, t1.robuxAmount),
						Font = p2Font.Title.Font,
						TextColor3 = Theme.TextEmphasis.Color,
						TextTransparency = Theme.TextEmphasis.Transparency,
						TextSize = v33
					})
				}),
				CurrencyAmmountText = Roact.createElement(FitTextLabel, {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					width = FitTextLabel.Width.FitToText,
					Text = t1.currencyAmountStr,
					Font = p2Font.Header1.Font,
					TextColor3 = Theme.TextEmphasis.Color,
					TextTransparency = Theme.TextEmphasis.Transparency,
					TextSize = t1.scale * 32
				}),
				MoreText = t1.robuxMoreAmount and Roact.createElement(FitTextLabel, {
					LayoutOrder = 4,
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					width = FitTextLabel.Width.FitToText,
					Text = p1.moreRobux,
					Font = p2Font.Header2.Font,
					TextColor3 = Theme.TextEmphasis.Color,
					TextTransparency = Theme.TextEmphasis.Transparency,
					TextSize = t1.scale * 32
				}, {
					Gradient = Roact.createElement("UIGradient", {
						Rotation = 0,
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 251, 103)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(243, 185, 34))
						})
					})
				}) or nil
			})
		})
	})
end

return function(t2: {[any]: any}) -- line: 255
	-- upvalues: useCursor (copy), useTokens (copy), useStyleMetadata (copy), Roact (copy), MultiTextLocalizer (copy), formatNumber (copy), LocalizationService (copy), withStyle (copy), renderWithProviders (copy)
	local v36 = useCursor(UDim.new(0, 8))
	local v37 = useTokens()
	local ThemeName = useStyleMetadata().ThemeName

	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			moreRobux = {
				key = "IAPExperience.BuyRobux.Text.MoreRobux2",
				params = {
					robux = formatNumber(LocalizationService.RobloxLocaleId, t2.robuxMoreAmount or 0)
				}
			}
		},
		render = function(t3: {[any]: any}) -- line: 271
			-- upvalues: withStyle (copy), t2 (copy), renderWithProviders (copy), v36 (copy), ThemeName (copy), v37 (copy)
			return withStyle(function(p6) -- line: 272
				-- upvalues: t2 (copy), renderWithProviders (copy), t3 (copy), v36 (copy), ThemeName (copy), v37 (copy)
				if t2.scale == nil then
					t2.scale = 0.65
				end

				return renderWithProviders(t2, t3, p6, v36, ThemeName, v37)
			end)
		end
	})
end
