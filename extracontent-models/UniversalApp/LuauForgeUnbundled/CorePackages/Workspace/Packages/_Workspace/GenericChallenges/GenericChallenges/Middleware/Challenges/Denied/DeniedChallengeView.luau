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

local deniedPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/Denied/DeniedMetadata").DeniedPrompt

local v5 = {
	[deniedPrompt.WasmGameJoinRedirect] = {
		title = "Feature.Denied.Denied.Wasm.GameJoin.Header",
		body = "Feature.Denied.Denied.Wasm.GameJoin.Body"
	},
	[deniedPrompt.WasmInExpDeny] = {
		title = "Feature.Denied.Denied.Wasm.InExperienceFeature.Header",
		body = "Feature.Denied.Denied.Wasm.InExperienceFeature.Body"
	}
}

local function getCopy(prompt, object)
	local v6 = if prompt then v5[prompt] else nil

	if v6 then
		return { title = object:Format(v6.title), body = object:Format(v6.body) }
	end

	return {
		title = object:Format("Feature.Denied.Denied.Header"),
		body = object:Format("Feature.Denied.Denied.Body")
	}
end

local function DialogContent(props)
	local v6 = useTokens()

	local v7 = React.useMemo(function()
		return InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
	end, {})
	local copy = getCopy(props.prompt, v7)
	local title = copy.title
	local body = copy.body
	local formatted = v7:Format("Feature.Denied.Denied.Action")

	local state, setState = React.useState(Vector2.zero)
	local xLarge = v6.Padding.XLarge
	local v8 = xLarge + v6.Padding.Medium
	local v9 = math.min((not (state.X > 1) and 390 or state.X) - v8 * 2, 480)

	local headingMedium = v6.Typography.HeadingMedium
	local bodyMedium = v6.Typography.BodyMedium

	local labelMedium = v6.Typography.LabelMedium

	local v10 = React.useMemo(function()
		return normalizeFontFace(headingMedium.Font)
	end, { headingMedium.Font })
	local v11 = React.useMemo(function()
		return normalizeFontFace(bodyMedium.Font)
	end, { bodyMedium.Font })
	local v12 = React.useMemo(function()
		return normalizeFontFace(labelMedium.Font)
	end, { labelMedium.Font })

	local state2, setState2 = React.useState(false)
	React.useEffect(function()
		local v13 = false
		local function markReady()
			if not v13 then
				setState2(true)
			end
		end
		local v14 = {
			{ font = v10, size = headingMedium.FontSize, text = title },
			{ font = v11, size = bodyMedium.FontSize, text = body },
			{ font = v12, size = labelMedium.FontSize, text = formatted }
		}

		task.spawn(function()
			pcall(function()
				for k, v15 in v14 do
					if typeof(v15.font) ~= "Font" then
						continue
					end

					local getTextBoundsParams = Instance.new("GetTextBoundsParams")
					getTextBoundsParams.Text = v15.text
					getTextBoundsParams.Font = v15.font
					getTextBoundsParams.Size = v15.size
					getTextBoundsParams.Width = 480
					TextService:GetTextBoundsAsync(getTextBoundsParams)
				end
			end)

			if not v13 then
				setState2(true)
			end
		end)
		task.delay(1.5, markReady)
		return function()
			v13 = true
		end
	end, {
		v10,
		v11,
		v12,
		title,
		body,
		formatted,
		headingMedium.FontSize,
		bodyMedium.FontSize,
		labelMedium.FontSize
	})

	local surface_100 = v6.Color.Surface.Surface_100
	local actionEmphasis = v6.Color.ActionEmphasis

	local element = React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, v6.Size.Size_1000),
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
				FontFace = v12,
				BorderSizePixel = 0,
				[React.Event.Activated] = props.onAcknowledge
			}, {
				Corner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v6.Radius.Medium)
				})
			})
		}
	)

	return React.createElement(React.Fragment, nil, {
		Backdrop = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v6.Color.Common.Backdrop.Color3,
			BackgroundTransparency = props.opaqueBackdrop and 0 or v6.Color.Common.Backdrop.Transparency,
			BorderSizePixel = 0,
			ZIndex = 1,
			[React.Change.AbsoluteSize] = function(p2)
				setState(p2.AbsoluteSize)
			end
		}),
		Card = React.createElement("Frame", {
			Size = UDim2.new(0, v9, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundColor3 = surface_100.Color3,
			BackgroundTransparency = not state2 and 1 or surface_100.Transparency,
			BorderSizePixel = 0,
			ZIndex = 2
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v6.Radius.Large)
			}),
			Stroke = React.createElement("UIStroke", {
				Color = v6.Color.Stroke.Default.Color3,
				Transparency = not state2 and 1 or v6.Color.Stroke.Default.Transparency,
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
				Padding = UDim.new(0, v6.Padding.Large),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Title = React.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Text = title,
				TextColor3 = v6.Color.Content.Emphasis.Color3,
				TextTransparency = state2 and 0 or 1,
				TextSize = headingMedium.FontSize,
				FontFace = v10,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1
			}),
			Body = React.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Text = body,
				TextColor3 = v6.Color.Content.Default.Color3,
				TextTransparency = state2 and 0 or 1,
				TextSize = bodyMedium.FontSize,
				FontFace = v11,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 2
			}),
			Footer = element
		})
	})
end

local function DeniedChallengeView(props)
	local v6 = React.useMemo(function()
		return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	end, {})

	React.useEffect(function()
		return function()
			v6:teardown()
		end
	end, { v6 })

	return React.createElement(
		"ScreenGui",
		{
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = 200,
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = true
		},
		{
			FoundationRoot = React.createElement(foundationProvider, {
				colorMode = colorMode.Dark
			}, {
				FocusNavigationProvider = React.createElement(
					ReactFocusNavigation.FocusNavigationContext.Provider,
					{ value = v6 },
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
