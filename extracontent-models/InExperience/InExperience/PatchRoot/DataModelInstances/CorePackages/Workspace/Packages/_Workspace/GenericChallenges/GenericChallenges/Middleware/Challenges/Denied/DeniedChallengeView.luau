local parent = script:FindFirstAncestor("GenericChallenges").Parent

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

local DeniedMetadata = require(script.Parent.DeniedMetadata)
local DeniedPrompt = DeniedMetadata.DeniedPrompt

local v = {
	[DeniedPrompt.WasmGameJoinRedirect] = {
		title = "Feature.Denied.Denied.Wasm.GameJoin.Header",
		body = "Feature.Denied.Denied.Wasm.GameJoin.Body"
	},
	[DeniedPrompt.WasmInExpDeny] = {
		title = "Feature.Denied.Denied.Wasm.InExperienceFeature.Header",
		body = "Feature.Denied.Denied.Wasm.InExperienceFeature.Body"
	}
}

local function getCopy(prompt: string?, object)
	local v2

	if prompt then
		v2 = v[prompt]
	end

	if v2 then
		return { title = object:Format(v2.title), body = object:Format(v2.body) }
	end

	return {
		title = object:Format("Feature.Denied.Denied.Header"),
		body = object:Format("Feature.Denied.Denied.Body")
	}
end

local function DialogContent(props)
	local v2 = useTokens()

	local v3 = React.useMemo(function()
		return InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
	end, {})
	local copy = getCopy(props.prompt, v3)
	local title = copy.title
	local body = copy.body
	local formatted = v3:Format("Feature.Denied.Denied.Action")

	local state, setState = React.useState(Vector2.zero)
	local xLarge = v2.Padding.XLarge
	local v4 = xLarge + v2.Padding.Medium
	local v5 = math.min((not (state.X > 1) and 390 or state.X) - v4 * 2, 480)

	local headingMedium = v2.Typography.HeadingMedium
	local bodyMedium = v2.Typography.BodyMedium

	local labelMedium = v2.Typography.LabelMedium

	local v6 = React.useMemo(function()
		return normalizeFontFace(headingMedium.Font)
	end, { headingMedium.Font })
	local v7 = React.useMemo(function()
		return normalizeFontFace(bodyMedium.Font)
	end, { bodyMedium.Font })
	local v8 = React.useMemo(function()
		return normalizeFontFace(labelMedium.Font)
	end, { labelMedium.Font })

	local state2, setState2 = React.useState(false)
	React.useEffect(function()
		local v9 = false
		local function markReady() -- 1 equivalent call inferred from this helper
			if not v9 then
				setState2(true)
			end
		end
		local v10 = {
			{ font = v6, size = headingMedium.FontSize, text = title },
			{ font = v7, size = bodyMedium.FontSize, text = body },
			{ font = v8, size = labelMedium.FontSize, text = formatted }
		}

		task.spawn(function()
			pcall(function()
				for _, v11 in v10 do
					if typeof(v11.font) ~= "Font" then
						continue
					end

					local getTextBoundsParams = Instance.new("GetTextBoundsParams")
					getTextBoundsParams.Text = v11.text
					getTextBoundsParams.Font = v11.font
					getTextBoundsParams.Size = v11.size
					getTextBoundsParams.Width = 480
					TextService:GetTextBoundsAsync(getTextBoundsParams)
				end
			end)
			markReady() -- inferred equivalent call
		end)
		task.delay(1.5, markReady)
		return function()
			v9 = true
		end
	end, {
		v6,
		v7,
		v8,
		title,
		body,
		formatted,
		headingMedium.FontSize,
		bodyMedium.FontSize,
		labelMedium.FontSize
	})

	local surface_100 = v2.Color.Surface.Surface_100
	local actionEmphasis = v2.Color.ActionEmphasis

	local element = React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, v2.Size.Size_1000),
			BackgroundTransparency = 1,
			LayoutOrder = 3
		},
		{
			OkButton = React.createElement("TextButton", {
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = actionEmphasis.Background.Color3,
				BackgroundTransparency = not state2 and 1 or actionEmphasis.Background.Transparency,
				AutoButtonColor = true,
				Text = formatted,
				TextColor3 = actionEmphasis.Foreground.Color3,
				TextTransparency = state2 and 0 or 1,
				TextSize = labelMedium.FontSize,
				FontFace = v8,
				BorderSizePixel = 0,
				[React.Event.Activated] = props.onAcknowledge
			}, {
				Corner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v2.Radius.Medium)
				})
			})
		}
	)

	return React.createElement(React.Fragment, nil, {
		Backdrop = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v2.Color.Common.Backdrop.Color3,
			BackgroundTransparency = props.opaqueBackdrop and 0 or v2.Color.Common.Backdrop.Transparency,
			BorderSizePixel = 0,
			ZIndex = 1,
			[React.Change.AbsoluteSize] = function(p)
				setState(p.AbsoluteSize)
			end
		}),
		Card = React.createElement("Frame", {
			Size = UDim2.new(0, v5, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundColor3 = surface_100.Color3,
			BackgroundTransparency = not state2 and 1 or surface_100.Transparency,
			BorderSizePixel = 0,
			ZIndex = 2
		}, {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v2.Radius.Large) }),
			Stroke = React.createElement("UIStroke", {
				Color = v2.Color.Stroke.Default.Color3,
				Transparency = not state2 and 1 or v2.Color.Stroke.Default.Transparency,
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
				Padding = UDim.new(0, v2.Padding.Large),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Title = React.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Text = title,
				TextColor3 = v2.Color.Content.Emphasis.Color3,
				TextTransparency = state2 and 0 or 1,
				TextSize = headingMedium.FontSize,
				FontFace = v6,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1
			}),
			Body = React.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Text = body,
				TextColor3 = v2.Color.Content.Default.Color3,
				TextTransparency = state2 and 0 or 1,
				TextSize = bodyMedium.FontSize,
				FontFace = v7,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 2
			}),
			Footer = element
		})
	})
end

local function DeniedChallengeView(props)
	local v2 = React.useMemo(function()
		return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	end, {})

	React.useEffect(function()
		return function()
			v2:teardown()
		end
	end, { v2 })

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
					{ value = v2 },
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
											prompt = props.prompt,
											onAcknowledge = props.onAcknowledge,
											opaqueBackdrop = props.opaqueBackdrop
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

return DeniedChallengeView
