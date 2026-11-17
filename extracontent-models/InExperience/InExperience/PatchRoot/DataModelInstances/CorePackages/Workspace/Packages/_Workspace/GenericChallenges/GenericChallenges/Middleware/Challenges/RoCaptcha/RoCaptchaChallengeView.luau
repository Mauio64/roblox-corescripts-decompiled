local parent = script:FindFirstAncestor("GenericChallenges").Parent

local RunService = game:GetService("RunService")
local LocalizationService = game:GetService("LocalizationService")
local TextService = game:GetService("TextService")

local React = require(parent.React)

local InExperienceLocales = require(parent.InExperienceLocales)

local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode
local useTokens = Foundation.Hooks.useTokens

local normalizeFontFace = Foundation.Utility.normalizeFontFace

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceRegistry = FocusNavigationUtils.FocusNavigableSurfaceRegistry
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

game:DefineFastInt("RoCaptchaLoadingStatePaintFrames", 5)

local function DialogContent(props)
	local v = useTokens()

	local v2 = React.useMemo(function()
		return InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
	end, {})
	local formatted = v2:Format("Feature.RoCaptchaChallenge.Title.Challenge")
	local formatted2 = v2:Format("Feature.RoCaptchaChallenge.Content.JoinChallenge")
	local formatted3 = v2:Format("Feature.RoCaptchaChallenge.Action.Play")
	local formatted4 = v2:Format("Feature.RoCaptchaChallenge.Action.Cancel")

	local fastInt = game:GetFastInt("RoCaptchaLoadingStatePaintFrames")

	local v3 = React.useMemo(function()
		return props.waitForFrame or function()
			for _ = 1, fastInt do
				RunService.Heartbeat:Wait()
			end
		end
	end, { props.waitForFrame, fastInt })

	local state, setState = React.useState(false)
	local ref = React.useRef(props.onJoin)
	ref.current = props.onJoin

	local ref2 = React.useRef(false)

	local v4 = React.useCallback(function()
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
			local v5 = false
			task.spawn(function()
				v3()

				if not (v5 or ref2.current) then
					ref2.current = true
					ref.current()
				end
			end)
			return function()
				v5 = true
			end
		end
	end, { state, v3, fastInt })

	local state2, setState2 = React.useState(Vector2.zero)

	local xLarge = v.Padding.XLarge
	local v5 = xLarge + v.Padding.Medium
	local v6 = math.min((not (state2.X > 1) and 390 or state2.X) - v5 * 2, 480)

	local headingMedium = v.Typography.HeadingMedium
	local bodyMedium = v.Typography.BodyMedium

	local labelMedium = v.Typography.LabelMedium

	local v7 = React.useMemo(function()
		return normalizeFontFace(headingMedium.Font)
	end, { headingMedium.Font })
	local v8 = React.useMemo(function()
		return normalizeFontFace(bodyMedium.Font)
	end, { bodyMedium.Font })
	local v9 = React.useMemo(function()
		return normalizeFontFace(labelMedium.Font)
	end, { labelMedium.Font })

	local state3, setState3 = React.useState(false)
	React.useEffect(function()
		local v10 = false
		local function markReady() -- 1 equivalent call inferred from this helper
			if not v10 then
				setState3(true)
			end
		end
		local v11 = {
			{ font = v7, size = headingMedium.FontSize, text = formatted },
			{ font = v8, size = bodyMedium.FontSize, text = formatted2 },
			{ font = v9, size = labelMedium.FontSize, text = formatted3 }
		}

		task.spawn(function()
			pcall(function()
				for _, v12 in v11 do
					if typeof(v12.font) ~= "Font" then
						continue
					end

					local getTextBoundsParams = Instance.new("GetTextBoundsParams")
					getTextBoundsParams.Text = v12.text
					getTextBoundsParams.Font = v12.font
					getTextBoundsParams.Size = v12.size
					getTextBoundsParams.Width = 480
					TextService:GetTextBoundsAsync(getTextBoundsParams)
				end
			end)
			markReady() -- inferred equivalent call
		end)
		task.delay(1.5, markReady)
		return function()
			v10 = true
		end
	end, {
		v7,
		v8,
		v9,
		formatted,
		formatted2,
		formatted3,
		headingMedium.FontSize,
		bodyMedium.FontSize,
		labelMedium.FontSize
	})

	local surface_100 = v.Color.Surface.Surface_100
	local actionEmphasis = v.Color.ActionEmphasis
	local actionStandard = v.Color.ActionStandard
	local size_1000 = v.Size.Size_1000

	local element = React.createElement(
		"Frame",
		{ Size = UDim2.new(1, 0, 0, size_1000), BackgroundTransparency = 1, LayoutOrder = 3 },
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
				FontFace = v9,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				[React.Event.Activated] = props.onAbandon
			}, {
				Corner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v.Radius.Medium)
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
				FontFace = v9,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				[React.Event.Activated] = function()
					if not state then
						v4()
					end
				end
			}, {
				Corner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v.Radius.Medium)
				})
			})
		}
	)

	return React.createElement(React.Fragment, nil, {
		Backdrop = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v.Color.Common.Backdrop.Color3,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ZIndex = 1,
			[React.Change.AbsoluteSize] = function(p)
				setState2(p.AbsoluteSize)
			end
		}),
		Card = React.createElement("Frame", {
			Size = UDim2.new(0, v6, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundColor3 = surface_100.Color3,
			BackgroundTransparency = not state3 and 1 or surface_100.Transparency,
			BorderSizePixel = 0,
			ZIndex = 2
		}, {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v.Radius.Large) }),
			Stroke = React.createElement("UIStroke", {
				Color = v.Color.Stroke.Default.Color3,
				Transparency = not state3 and 1 or v.Color.Stroke.Default.Transparency,
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
				Padding = UDim.new(0, v.Padding.Large),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Title = React.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Text = formatted,
				TextColor3 = v.Color.Content.Emphasis.Color3,
				TextTransparency = state3 and 0 or 1,
				TextSize = headingMedium.FontSize,
				FontFace = v7,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1
			}),
			Body = React.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Text = formatted2,
				TextColor3 = v.Color.Content.Default.Color3,
				TextTransparency = state3 and 0 or 1,
				TextSize = bodyMedium.FontSize,
				FontFace = v8,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 2
			}),
			Footer = element
		})
	})
end

local function RoCaptchaChallengeView(props)
	local v = React.useMemo(function()
		return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	end, {})

	return React.createElement(
		"ScreenGui",
		{
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = 200,
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = true
		},
		{
			FoundationRoot = React.createElement(FoundationProvider, { colorMode = ColorMode.Dark }, {
				FocusNavigationProvider = React.createElement(
					ReactFocusNavigation.FocusNavigationContext.Provider,
					{ value = v },
					{
						FocusNavigationRegistryProvider = React.createElement(
							FocusNavigableSurfaceRegistry.Provider,
							nil,
							{
								FocusNavigableSurface = React.createElement(
									FocusRoot,
									{
										surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ModerationOverlay,
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
