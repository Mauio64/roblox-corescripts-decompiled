local Parent = script:FindFirstAncestor("SystemScrim").Parent
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)

local function SystemScrim(t1: {[any]: any}) -- line: 23
	-- upvalues: SignalsReact (copy), React (copy)
	local v6 = SignalsReact.useSignalState(t1.store.autoDismiss)
	local v7 = React.useCallback(function() -- line: 26
		-- upvalues: t1 (copy), v6 (copy)
		t1.store.backgroundScrimActivated:Fire()

		if v6 then
			t1.store.setVisibility(false)
		end
	end, { v6 })
	local v8 = SignalsReact.useSignalState(t1.store.visible)
	local v9 = SignalsReact.useSignalBinding(t1.store.transparency)

	if not v8 then
		return nil
	end

	return (React.createElement("TextButton", {
		Size = UDim2.fromScale(1, 1),
		Visible = true,
		BackgroundTransparency = v9,
		BackgroundColor3 = Color3.new(0, 0, 0),
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
		[React.Event.Activated] = v7
	}))
end

return SystemScrim
