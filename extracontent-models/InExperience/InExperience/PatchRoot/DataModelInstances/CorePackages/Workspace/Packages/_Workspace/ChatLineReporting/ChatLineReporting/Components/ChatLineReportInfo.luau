local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local ChatLineReportingParent = ChatLineReporting.Parent
local React = require(ChatLineReportingParent.React)
local ReactOtter = require(ChatLineReportingParent.ReactOtter)
local Foundation = require(ChatLineReportingParent.Foundation)
local useLocalization = require(ChatLineReportingParent.Localization).Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local FFlagChatLineReportingFocusFixesEnabled = require(ChatLineReportingParent.SharedFlags).FFlagChatLineReportingFocusFixesEnabled
local Constants = require(ChatLineReporting.Common.Constants)
local t1 = {
	stiffness = 400,
	damping = 40,
	mass = 1,
	restingPositionLimit = 0.5,
	restingVelocityLimit = 0.1
}

local function ChatLineReportInfo(t2: {[any]: any}) -- line: 32
	-- upvalues: useTokens (copy), React (copy), useLocalization (copy), Constants (copy), ReactOtter (copy), t1 (copy), FFlagChatLineReportingFocusFixesEnabled (copy), View (copy)
	local v14 = useTokens()
	local v15, v16 = React.useState(false)
	local v17 = useLocalization(Constants.ChatLineLocalizationKeys)

	React.useEffect(function() -- line: 38
		-- upvalues: v16 (copy), t2 (copy)
		v16(t2.visible)
	end, { t2.visible })

	local v18, v19 = ReactOtter.useAnimatedBinding(1, function() -- line: 42
	end)
	local v20 = React.useMemo(function() -- line: 44
		-- upvalues: v15 (copy)
		if v15 then
			return 0
		end

		return 1
	end, { v15 })

	React.useEffect(function() -- line: 48
		-- upvalues: v19 (copy), ReactOtter (copy), v20 (copy), t1 (copy)
		v19(ReactOtter.spring(v20, t1))
	end, { v20 })

	return React.createElement("TextButton", {
		Active = v18:map(function(p1) -- line: 53
			return p1 == 0
		end),
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Selectable = not FFlagChatLineReportingFocusFixesEnabled and nil,
		Size = UDim2.new(1, 0, 1, 0),
		Text = "",
		[React.Event.Activated] = function() -- line: 62
			-- upvalues: v16 (copy)
			v16(false)
		end,
		ZIndex = v18:map(function(n1: number) -- line: 66
			return (1 - n1) * 4
		end)
	}, {
		InfoTextFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			ZIndex = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = v18:map(function(n2: number) -- line: 74
				return UDim2.new(1, 0, 0, 60):Lerp(UDim2.new(1, 0, 0, 0), n2)
			end)
		}, {
			InfoTextContainer = React.createElement(View, {
				tag = "bg-over-media-0 radius-medium anchor-bottom-left position-bottom-left",
				Size = UDim2.new(1, 0, 1, -8)
			}, {
				InfoText = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextWrapped = true,
					Font = v14.Typography.BodySmall.Font,
					Text = v17.InfoTextKey,
					TextColor3 = v14.Color.Content.Default.Color3,
					TextSize = v14.Typography.BodySmall.FontSize,
					Size = UDim2.new(1, 0, 1, 0)
				})
			})
		})
	})
end

return ChatLineReportInfo
