local RunService = game:GetService("RunService")
local LocalizationService = game:GetService("LocalizationService")
local TextService = game:GetService("TextService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/React")

local InExperienceLocales = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/InExperienceLocales")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/Foundation")
local foundationProvider = Foundation.FoundationProvider
local colorMode = Foundation.Enums.ColorMode
local useTokens = Foundation.Hooks.useTokens

local normalizeFontFace = Foundation.Utility.normalizeFontFace

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/FocusNavigationUtils")
local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceRegistry = FocusNavigationUtils.FocusNavigableSurfaceRegistry
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/ReactFocusNavigation")

game:DefineFastInt("RoCaptchaLoadingStatePaintFrames", 5)

local function DialogContent(props)
	local v5 = useTokens()

	local v6 = React.useMemo(function()
		return InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
	end, {})
	local formatted = v6:Format("Feature.RoCaptchaChallenge.Title.Challenge")
	local formatted2 = v6:Format("Feature.RoCaptchaChallenge.Content.JoinChallenge")
	local formatted3 = v6:Format("Feature.RoCaptchaChallenge.Action.Play")
	local formatted4 = v6:Format("Feature.RoCaptchaChallenge.Action.Cancel")

	local fastInt = game:GetFastInt("RoCaptchaLoadingStatePaintFrames")

	local v7 = React.useMemo(function()
		return props.waitForFrame or function()
			for i = 1, fastInt do
				RunService.Heartbeat:Wait()
			end
		end
	end, { props.waitForFrame, fastInt })

	local state, setState = React.useState(false)
	local ref = React.useRef(props.onJoin)
	ref.current = props.onJoin

	local ref2 = React.useRef(false)

	local v8 = React.useCallback(function()
		setState(true)
	end, {})

	React.useEffect(function()
		if not state or ref2.current then
			return
		end

		if fastInt == 0 then
			ref2.current = true
			ref.current()
		else
			local v9 = false
			task.spawn(function()
				v7()

				if not (v9 or ref2.current) then
					ref2.current = true
					ref.current()
				end
			end)
			return function()
				v9 = true
			end
		end
	end, { state, v7, fastInt })

	local state2, setState2 = React.useState(Vector2.zero)

	local xLarge = v5.Padding.XLarge
	local v9 = xLarge + v5.Padding.Medium
	local v10 = math.min((not (state2.X > 1) and 390 or state2.X) - v9 * 2, 480)

	local headingMedium = v5.Typography.HeadingMedium
	local bodyMedium = v5.Typography.BodyMedium

	local labelMedium = v5.Typography.LabelMedium

	local v11 = React.useMemo(function()
		return normalizeFontFace(headingMedium.Font)
	end, { headingMedium.Font })
	local v12 = React.useMemo(function()
		return normalizeFontFace(bodyMedium.Font)
	end, { bodyMedium.Font })
	local v13 = React.useMemo(function()
		return normalizeFontFace(labelMedium.Font)
	end, { labelMedium.Font })

	local state3, setState3 = React.useState(false)
	React.useEffect(function()
		local v14 = false
		local function markReady()
			if not v14 then
				setState3(true)
			end
		end
		local v15 = {
			{ font = v11, size = headingMedium.FontSize, text = formatted },
			{ font = v12, size = bodyMedium.FontSize, text = formatted2 },
			{ font = v13, size = labelMedium.FontSize, text = formatted3 }
		}

		task.spawn(function()
			pcall(function()
				for k, v16 in v15 do
					if typeof(v16.font) ~= "Font" then
						continue
					end

					local getTextBoundsParams = Instance.new("GetTextBoundsParams")
					getTextBoundsParams.Text = v16.text
					getTextBoundsParams.Font = v16.font
					getTextBoundsParams.Size = v16.size
					getTextBoundsParams.Width = 480
					TextService:GetTextBoundsAsync(getTextBoundsParams)
				end
			end)

			if not v14 then
				setState3(true)
			end
		end)
		task.delay(1.5, markReady)
		return function()
			v14 = true
		end
	end, {
		v11,
		v12,
		v13,
		formatted,
		formatted2,
		formatted3,
		headingMedium.FontSize,
		bodyMedium.FontSize,
		labelMedium.FontSize
	})

	local surface_100 = v5.Color.Surface.Surface_100
	local actionEmphasis = v5.Color.ActionEmphasis
	local actionStandard = v5.Color.ActionStandard
	local size_1000 = v5.Size.Size_1000

	local element = React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, size_1000),
			BackgroundTransparency = 1,
			LayoutOrder = 3
		},
		{
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			CancelButton = React.createElement("TextButton", {
				Size = UDim2.new(0.5, -4, 1, 0),
				BackgroundColor3 = actionStandard.Background.Color3,
				BackgroundTransparency = not state3 and 1 or actionStandard.Background.Transparency,
				AutoButtonColor = true,
				Text = formatted4,
				TextColor3 = actionStandard.Foreground.Color3,
				TextTransparency = state3 and 0 or 1,
				TextSize = labelMedium.FontSize,
				FontFace = v13,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				[React.Event.Activated] = props.onAbandon
			}, {
				Corner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v5.Radius.Medium)
				})
			}),
			JoinButton = React.createElement("TextButton", {
				Size = UDim2.new(0.5, -4, 1, 0),
				BackgroundColor3 = actionEmphasis.Background.Color3,
				BackgroundTransparency = not state3 and 1 or state and 0.5 or actionEmphasis.Background.Transparency,
				AutoButtonColor = not state,
				Active = not state,
				Text = formatted3,
				TextColor3 = actionEmphasis.Foreground.Color3,
				TextTransparency = state3 and (state and 0.5 or 0) or 1,
				TextSize = labelMedium.FontSize,
				FontFace = v13,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				[React.Event.Activated] = function()
					if not state then
						v8()
					end
				end
			}, {
				Corner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v5.Radius.Medium)
				})
			})
		}
	)

	return React.createElement(React.Fragment, nil, {
		Backdrop = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v5.Color.Common.Backdrop.Color3,
			BackgroundTransparency = v5.Color.Common.Backdrop.Transparency,
			BorderSizePixel = 0,
			ZIndex = 1,
			[React.Change.AbsoluteSize] = function(p2)
				setState2(p2.AbsoluteSize)
			end
		}),
		Card = React.createElement("Frame", {
			Size = UDim2.new(0, v10, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundColor3 = surface_100.Color3,
			BackgroundTransparency = not state3 and 1 or surface_100.Transparency,
			BorderSizePixel = 0,
			ZIndex = 2
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v5.Radius.Large)
			}),
			Stroke = React.createElement("UIStroke", {
				Color = v5.Color.Stroke.Default.Color3,
				Transparency = not state3 and 1 or v5.Color.Stroke.Default.Transparency,
				Thickness = 1
			}),
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, xLarge),
				PaddingBottom = UDim.new(0, xLarge),
				PaddingLeft = UDim.new(0, xLarge),
				PaddingRight = UDim.new(0, xLarge)
			}),
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, v5.Padding.Large),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Title = React.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Text = formatted,
				TextColor3 = v5.Color.Content.Emphasis.Color3,
				TextTransparency = state3 and 0 or 1,
				TextSize = headingMedium.FontSize,
				FontFace = v11,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1
			}),
			Body = React.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Text = formatted2,
				TextColor3 = v5.Color.Content.Default.Color3,
				TextTransparency = state3 and 0 or 1,
				TextSize = bodyMedium.FontSize,
				FontFace = v12,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 2
			}),
			Footer = element
		})
	})
end

local function RoCaptchaChallengeView(props)
	local v5 = React.useMemo(function()
		return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	end, {})

	return React.createElement(
		"ScreenGui",
		{
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = 200,
			IgnoreGuiInset = true
		},
		{
			FoundationRoot = React.createElement(foundationProvider, {
				colorMode = colorMode.Dark
			}, {
				FocusNavigationProvider = React.createElement(
					ReactFocusNavigation.FocusNavigationContext.Provider,
					{ value = v5 },
					{
						FocusNavigationRegistryProvider = React.createElement(
							focusNavigableSurfaceRegistry.Provider,
							nil,
							{
								FocusNavigableSurface = React.createElement(
									focusRoot,
									{
										surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ModerationOverlay,
										isIsolated = true,
										isAutoFocusRoot = true
									},
									{
										Content = React.createElement(DialogContent, {
											onJoin = props.onJoin,
											onAbandon = props.onAbandon,
											waitForFrame = props.waitForFrame
										})
									}
								)
							}
						)
					}
				)
			})
		}
	)
end

return RoCaptchaChallengeView
