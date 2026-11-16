local parent = script:FindFirstAncestor("SystemScrim").Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local function SystemScrim(p)
	local v = SignalsReact.useSignalState(p.store.autoDismiss)

	local v2 = React.useCallback(function()
		p.store.backgroundScrimActivated:Fire()

		if v then
			p.store.setVisibility(false)
		end
	end, { v })

	local v3 = SignalsReact.useSignalState(p.store.visible)
	local backgroundTransparency = SignalsReact.useSignalBinding(p.store.transparency)

	if not v3 then
		return nil
	end

	return (React.createElement("TextButton", {
		Size = UDim2.fromScale(1, 1),
		Visible = true,
		BackgroundTransparency = backgroundTransparency,
		BackgroundColor3 = Color3.new(0, 0, 0),
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
		[React.Event.Activated] = v2
	}))
end

return SystemScrim
