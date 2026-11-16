local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local parent = ChatLineReporting.Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local Foundation = require(parent.Foundation)

local normalizeFontFace = Foundation.Utility.normalizeFontFace
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local Constants = require(ChatLineReporting.Common.Constants)

local v = {
	stiffness = 400,
	damping = 40,
	mass = 1,
	restingPositionLimit = 0.5,
	restingVelocityLimit = 0.1
}

local function ChatLineReportInfo(p)
	local v2 = useTokens()
	local state, setState = React.useState(false)

	local v3 = useLocalization(Constants.ChatLineLocalizationKeys)

	React.useEffect(function()
		setState(p.visible)
	end, { p.visible })

	local v4, v5 = ReactOtter.useAnimatedBinding(1, function() end)

	local v6 = React.useMemo(function(): number
		return if state then 0 else 1
	end, { state })

	React.useEffect(function()
		v5(ReactOtter.spring(v6, v))
	end, { v6 })

	local createElement = React.createElement
	local v7 = {
		Active = v4:map(function(p2): boolean
			return p2 == 0
		end),
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Selectable = false,
		Size = UDim2.new(1, 0, 1, 0),
		Text = "",
		[React.Event.Activated] = function()
			setState(false)
		end,
		ZIndex = v4:map(function(p2: number)
			return (1 - p2) * 4
		end)
	}

	local createElement2 = React.createElement
	local v8 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = v4:map(function(p2: number)
			return UDim2.new(1, 0, 0, 60):Lerp(UDim2.new(1, 0, 0, 0), p2)
		end),
		ClipsDescendants = true,
		ZIndex = 2
	}

	local createElement3 = React.createElement
	local v9 = {
		Size = UDim2.new(1, 0, 1, -8),
		tag = "bg-over-media-0 radius-medium anchor-bottom-left position-bottom-left"
	}

	local createElement4 = React.createElement
	local font

	if not FoundationFontFaceMigration then
		font = v2.Typography.BodySmall.Font
	end

	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v2.Typography.BodySmall.Font)
	end

	return createElement("TextButton", v7, {
		InfoTextFrame = createElement2("Frame", v8, {
			InfoTextContainer = createElement3(View, v9, {
				InfoText = createElement4("TextLabel", {
					BackgroundTransparency = 1,
					Font = font,
					FontFace = fontFace,
					Text = v3.InfoTextKey,
					TextColor3 = v2.Color.Content.Default.Color3,
					TextSize = v2.Typography.BodySmall.FontSize,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 1, 0)
				})
			})
		})
	})
end

return ChatLineReportInfo
