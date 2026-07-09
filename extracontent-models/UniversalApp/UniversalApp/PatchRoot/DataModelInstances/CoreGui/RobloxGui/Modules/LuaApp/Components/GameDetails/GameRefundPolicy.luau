local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local OpenRefundPolicyLearnMorePage = require(Modules.LuaApp.Thunks.OpenRefundPolicyLearnMorePage)
local checkAndFormatPossibleLink = require(CorePackages.Workspace.Packages.CollectionViews).checkAndFormatPossibleLink

local function GameRefundPolicy(t1: {[any]: any}) -- line: 21
	-- upvalues: useDispatch (copy), useTokens (copy), checkAndFormatPossibleLink (copy), React (copy), OpenRefundPolicyLearnMorePage (copy)
	local v10 = useDispatch()
	local v11 = useTokens()
	local BodyLarge = v11.Typography.BodyLarge
	local Muted = v11.Color.Content.Muted
	local LinkColor3 = v11.Color.Content.Link.Color3
	local v15 = `<font color="{ string.format("rgb(%d, %d, %d)", math.round(LinkColor3.R * 255), math.round(LinkColor3.G * 255), (math.round(LinkColor3.B * 255))) }"><b>`
	local v16, v17 = checkAndFormatPossibleLink(t1.refundPolicy.policyText, nil, nil, v15, "</b></font>")
	local v18 = React.useCallback(function(_) -- line: 40
		-- upvalues: v10 (copy), OpenRefundPolicyLearnMorePage (copy), t1 (copy)
		v10(OpenRefundPolicyLearnMorePage(t1.refundPolicy.learnMoreUrl))
	end, { t1.refundPolicy.learnMoreUrl })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.layoutOrder
	}, {
		UIPadding = if not t1.paddingTop then nil else React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, t1.paddingTop)
		}),
		RefundPolicy = React.createElement("TextButton", {
			BackgroundTransparency = 1,
			Text = v17,
			AutomaticSize = Enum.AutomaticSize.XY,
			Font = BodyLarge.Font,
			TextSize = BodyLarge.FontSize,
			TextColor3 = Muted.Color3,
			TextTransparency = Muted.Transparency,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = v16,
			[React.Event.Activated] = v18
		})
	})
end

return GameRefundPolicy
