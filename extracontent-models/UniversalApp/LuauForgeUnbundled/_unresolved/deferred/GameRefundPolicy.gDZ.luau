local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId
local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddTestIdsForArrow

local module = require("@luauforge/deferred/gDl")

local checkAndFormatPossibleLink = require("@luauforge/bundled/ehg").checkAndFormatPossibleLink

local function GameRefundPolicy(props)
	local v5 = useDispatch()

	local v6 = useTokens()
	local bodyLarge = v6.Typography.BodyLarge
	local muted = v6.Color.Content.Muted

	local color3 = v6.Color.Content.Link.Color3
	local formatted = `<font color="{string.format(
		"rgb(%d, %d, %d)",
		math.round(color3.R * 255),
		math.round(color3.G * 255),
		(math.round(color3.B * 255))
	)}"><b>`

	local v7, v8 = checkAndFormatPossibleLink(
		props.refundPolicy.policyText,
		nil,
		nil,
		formatted,
		"</b></font>"
	)

	local v9 = React.useCallback(function(p2)
		v5(module(props.refundPolicy.learnMoreUrl))
	end, { props.refundPolicy.learnMoreUrl })

	local createElement = React.createElement
	local v11 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.layoutOrder
	}

	local v13 = if props.paddingTop then React.createElement("UIPadding", {
		PaddingTop = UDim.new(0, props.paddingTop)
	}) else nil

	local createElement2 = React.createElement
	local v15 = {
		BackgroundTransparency = 1,
		["Text"] = v8,
		AutomaticSize = Enum.AutomaticSize.XY,
		FontFace = normalizeFontFace(bodyLarge.Font),
		TextSize = bodyLarge.FontSize,
		TextColor3 = muted.Color3,
		TextTransparency = muted.Transparency,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		RichText = v7
	}

	local tag = React.Tag
	local v16 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-edp-game-refund-policy") else nil
	v15[tag] = v16

	v15[React.Event.Activated] = v9
	return createElement("Frame", v11, {
		UIPadding = v13,
		RefundPolicy = createElement2("TextButton", v15)
	})
end

return GameRefundPolicy
