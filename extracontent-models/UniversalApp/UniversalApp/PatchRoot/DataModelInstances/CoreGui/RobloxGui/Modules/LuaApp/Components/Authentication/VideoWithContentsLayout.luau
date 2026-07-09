local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local FullscreenPageWithSafeArea = require(Modules.LuaApp.Components.FullscreenPageWithSafeArea)
local LandingPageVideo = require(Modules.LuaApp.Components.Authentication.LandingPageVideo)
local React = require(CorePackages.Packages.React)
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor

local function VideoWithContentsLayout(t1: {[any]: any}) -- line: 30
	-- upvalues: React (copy), getSafeAreaSize (copy), useLocalization (copy), useDesignTokens (copy), FormFactor (copy), LandingPageVideo (copy), FullscreenPageWithSafeArea (copy)
	local v12, v13 = React.useState(0)
	local v14, v15 = React.useState(0)
	local t2 = {
		LogoPositionYScale = 0.08,
		BodyPositionYScale = 0.3,
		Position = UDim2.new(0.5, 0, 1, 0),
		AnchorPoint = Vector2.new(0.5, 1)
	}
	local v17 = getSafeAreaSize(t1.screenSize, t1.globalGuiInset).Y.Offset - t1.statusBarHeight
	local v18 = v17 * 0.3
	local v19 = v17 * t2.LogoPositionYScale
	local v20 = useLocalization({
		sloganText = "Feature.Landing.Heading.LandingSlogan"
	})
	local v21 = useDesignTokens()
	local t3 = {
		Logo = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/logo_white_1x.png",
			ZIndex = 1,
			Position = UDim2.new(0.5, 0, 0, v19),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0.7, 0, 0.7, 0)
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(150, 25.951557093425606)
			}),
			UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = 5.78,
				AspectType = Enum.AspectType.FitWithinMaxSize
			})
		}),
		ContentContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Position = UDim2.new(0.5, 0, 0, v18),
			Size = UDim2.new(1, 0, 1, -v18),
			AnchorPoint = Vector2.new(0.5, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, 16),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Bottom
			}),
			Text = React.createElement("TextLabel", {
				Size = UDim2.new(1, -40, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = v20.sloganText,
				TextColor3 = v21.Color.Content.Emphasis.Color3,
				TextSize = v21.Typography.HeadingLarge.FontSize,
				Font = v21.Typography.HeadingLarge.Font,
				TextXAlignment = if t1.formFactor ~= FormFactor.COMPACT then Enum.TextXAlignment.Center else Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Bottom,
				TextWrapped = true,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				[React.Change.AbsoluteSize] = function(p1) -- line: 34
					-- upvalues: v12 (copy), v13 (copy)
					if v12 ~= p1.AbsoluteSize.Y then
						v13(p1.AbsoluteSize.Y)
					end
				end
			}, {
				UISizeConstraint = if t1.formFactor ~= FormFactor.COMPACT then nil else React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(360, 1e999)
				})
			}),
			Content = React.createElement("Frame", {
				Position = t2.Position,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				AnchorPoint = t2.AnchorPoint,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				[React.Change.AbsoluteSize] = function(p2) -- line: 40
					-- upvalues: v14 (copy), v15 (copy)
					if v14 ~= p2.AbsoluteSize.Y then
						v15(p2.AbsoluteSize.Y)
					end
				end
			}, { t1.children })
		})
	}

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		renderFullscreenBackground = function(_: number) -- line: 128
			-- upvalues: React (copy), LandingPageVideo (copy), t1 (copy), v12 (copy), v14 (copy)
			return React.createElement(LandingPageVideo, {
				screenSize = t1.screenSize,
				landingVideoAsset = t1.landingVideoAsset,
				videoBottomOffsetGradientHeight = 3 * v12,
				videoBottomOffsetHeight = v14 + t1.globalGuiInset.bottom + 16
			})
		end,
		buttonRef = t1.containerRef
	}, {
		Contents = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ZIndex = 2,
			Size = UDim2.new(1, 0, 1, 0)
		}, { t3 })
	})
end

return VideoWithContentsLayout
