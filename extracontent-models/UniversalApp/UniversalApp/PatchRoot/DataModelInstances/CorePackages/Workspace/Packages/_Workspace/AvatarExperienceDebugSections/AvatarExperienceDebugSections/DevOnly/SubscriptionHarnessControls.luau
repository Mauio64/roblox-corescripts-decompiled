local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("AvatarExperienceDebugSections").Parent
local DebugPanel = require(Parent.DebugPanel)
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local useSignalState = require(Parent.SignalsReact).useSignalState
local RoactUtils = require(Parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local getBaseDomain = require(script.Parent.getBaseDomain)
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local RobloxSubscriptionPurchaseApp = require(Parent.RobloxSubscriptionPurchaseApp)
local SetUserHasRobloxSubscription = require(Parent.UserLib).Actions.SetUserHasRobloxSubscription
local v17 = string.format("https://apis.%s/__sub_harness__", getBaseDomain())
local t1 = {
	type = "ClearReceivedCatalogData"
}

local function notifyProxy(t2: {[any]: any}) -- line: 58
	-- upvalues: v17 (copy), HttpRbxApiService (copy)
	task.spawn(function() -- line: 59
		-- upvalues: t2 (copy), v17 (copy), HttpRbxApiService (copy)
		local t3 = {}

		for v65, v66 in t2 do
			table.insert(t3, string.format("%s=%s", v65, v66))
		end

		local v67 = if not (#t3 > 0) then v17 else string.format("%s?%s", v17, table.concat(t3, "&"))
		local ok, result = pcall(function() -- line: 67
			-- upvalues: HttpRbxApiService (copy), v67 (copy)
			HttpRbxApiService:GetAsyncFullUrl(v67, Enum.ThrottlingPriority.Default)
		end)
		local v70 = table.concat(t3, " ")

		if ok then
			print(string.format("[SubscriptionHarness] proxy sync: %s", v70))

			return
		end

		warn(string.format("[SubscriptionHarness] proxy sync failed for %s: %s", v70, (tostring(result))))
	end)
end
local function notifyProxyOfSubscriptionMode(b1: boolean) -- line: 79
	-- upvalues: v17 (copy), HttpRbxApiService (copy)
	local t4 = {
		mode = tostring(b1)
	}

	task.spawn(function() -- line: 59
		-- upvalues: t4 (copy), v17 (copy), HttpRbxApiService (copy)
		local t5 = {}

		for v72, v73 in t4 do
			table.insert(t5, string.format("%s=%s", v72, v73))
		end

		local v74 = if not (#t5 > 0) then v17 else string.format("%s?%s", v17, table.concat(t5, "&"))
		local ok, result = pcall(function() -- line: 67
			-- upvalues: HttpRbxApiService (copy), v74 (copy)
			HttpRbxApiService:GetAsyncFullUrl(v74, Enum.ThrottlingPriority.Default)
		end)
		local v77 = table.concat(t5, " ")

		if ok then
			print(string.format("[SubscriptionHarness] proxy sync: %s", v77))

			return
		end

		warn(string.format("[SubscriptionHarness] proxy sync failed for %s: %s", v77, (tostring(result))))
	end)
end
local function notifyProxyOfHarnessEnabled(b2: boolean) -- line: 83
	-- upvalues: v17 (copy), HttpRbxApiService (copy)
	local t6 = {
		enabled = tostring(b2)
	}

	task.spawn(function() -- line: 59
		-- upvalues: t6 (copy), v17 (copy), HttpRbxApiService (copy)
		local t7 = {}

		for v79, v80 in t6 do
			table.insert(t7, string.format("%s=%s", v79, v80))
		end

		local v81 = if not (#t7 > 0) then v17 else string.format("%s?%s", v17, table.concat(t7, "&"))
		local ok, result = pcall(function() -- line: 67
			-- upvalues: HttpRbxApiService (copy), v81 (copy)
			HttpRbxApiService:GetAsyncFullUrl(v81, Enum.ThrottlingPriority.Default)
		end)
		local v84 = table.concat(t7, " ")

		if ok then
			print(string.format("[SubscriptionHarness] proxy sync: %s", v84))

			return
		end

		warn(string.format("[SubscriptionHarness] proxy sync failed for %s: %s", v84, (tostring(result))))
	end)
end
local function probeProxyStatus() -- line: 91
	-- upvalues: HttpRbxApiService (copy), v17 (copy), HttpService (copy)
	local ok, result = pcall(function() -- line: 92
		-- upvalues: HttpRbxApiService (copy), v17 (copy)
		return HttpRbxApiService:GetAsyncFullUrl(v17, Enum.ThrottlingPriority.Default)
	end)

	if not ok then
		return "unreachable", nil, nil
	end

	local ok2, result2 = pcall(function() -- line: 98
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok2 or type(result2) ~= "table" or result2.ok ~= true then
		return "no_addon", nil, nil
	end

	return "connected", result2.subscriberMode == true, result2.harnessEnabled == true
end

local t8 = {
	checking = "Detecting proxy...",
	connected = "Proxy detected",
	unreachable = "Proxy not detected — run `git lua proxy up` with marketplace.subscription-harness enabled in proxy-scripts.json.",
	no_addon = "Proxy detected, but subscription-harness addon not loaded — enable marketplace.subscription-harness in proxy-scripts.json."
}
local color3 = Color3.fromRGB(80, 200, 120)
local color3_2 = Color3.fromRGB(220, 90, 90)
local color3_3 = Color3.fromRGB(230, 180, 60)

local function selectLocalUserId(p1) -- line: 124
	return p1.LocalUserId
end
local function HarnessButton(t9: {[any]: any}) -- line: 128
	-- upvalues: useTokens (copy), React (copy), View (copy), Foundation (copy), FoundationText (copy)
	local v41 = useTokens()
	local v42 = t9.disabled == true
	local v43 = if not v42 then t9.accent or v41.Color.Content.Emphasis.Color3 else v41.Color.Content.Muted.Color3

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, 28),
		LayoutOrder = t9.layoutOrder,
		backgroundStyle = {
			Color3 = v41.Color.Surface.Surface_300.Color3,
			Transparency = not v42 and 0 or 0.5
		},
		cornerRadius = UDim.new(0, v41.Radius.Small),
		padding = Vector2.new(v41.Padding.Small, 0),
		onActivated = if not v42 then t9.onClick else nil,
		stateLayer = if not v42 then {
			mode = Foundation.Enums.StateLayerMode.Inverse
		} else nil
	}, {
		Label = React.createElement(FoundationText, {
			tag = "text-label-small text-align-x-left",
			Size = UDim2.new(1, 0, 1, 0),
			TextColor3 = v43,
			Text = t9.text
		})
	})
end
local function SubscriptionHarnessControls() -- line: 163
	-- upvalues: RobloxSubscriptionPurchaseApp (copy), useSignalState (copy), useDispatch (copy), useSelector (copy), selectLocalUserId (copy), React (copy), probeProxyStatus (copy), SetUserHasRobloxSubscription (copy), v17 (copy), HttpRbxApiService (copy), t1 (copy), color3 (copy), color3_2 (copy), color3_3 (copy), FoundationText (copy), t8 (copy), HarnessButton (copy)
	local v44 = RobloxSubscriptionPurchaseApp.RobloxSubscriptionSignals.get()
	local v45 = useSignalState(v44.getHasRobloxSubscription)
	local v46 = useSignalState(v44.getGainedRobloxSubscriptionThisSession)
	local v47 = useDispatch()
	local v48 = useSelector(selectLocalUserId)
	local v49, v50 = React.useState("checking")
	local v51, v52 = React.useState(nil)
	local v53, v54 = React.useState(false)

	React.useEffect(function() -- line: 177
		-- upvalues: probeProxyStatus (copy), v50 (copy), v52 (copy), v54 (copy)
		task.spawn(function() -- line: 178
			-- upvalues: probeProxyStatus (copy), v50 (copy), v52 (copy), v54 (copy)
			local v89, v90, v91 = probeProxyStatus()

			v50(v89)
			v52(v90)

			if v91 ~= nil then
				v54(v91)
			end
		end)
	end, {})

	local v55 = React.useCallback(function(b3: boolean) -- line: 188
		-- upvalues: v44 (copy), v48 (copy), v47 (copy), SetUserHasRobloxSubscription (copy)
		v44.setHasRobloxSubscriptionForTesting(b3)

		if v48 ~= nil then
			v47(SetUserHasRobloxSubscription(v48, b3))
		end
	end, {
		v44,
		v47,
		v48
	})

	React.useEffect(function() -- line: 195
		-- upvalues: v45 (copy), v17 (copy), HttpRbxApiService (copy), v49 (copy), v52 (copy)
		local t10 = {
			mode = tostring(v45)
		}

		task.spawn(function() -- line: 59
			-- upvalues: t10 (copy), v17 (copy), HttpRbxApiService (copy)
			local t11 = {}

			for v93, v94 in t10 do
				table.insert(t11, string.format("%s=%s", v93, v94))
			end

			local v95 = if not (#t11 > 0) then v17 else string.format("%s?%s", v17, table.concat(t11, "&"))
			local ok, result = pcall(function() -- line: 67
				-- upvalues: HttpRbxApiService (copy), v95 (copy)
				HttpRbxApiService:GetAsyncFullUrl(v95, Enum.ThrottlingPriority.Default)
			end)
			local v98 = table.concat(t11, " ")

			if ok then
				print(string.format("[SubscriptionHarness] proxy sync: %s", v98))

				return
			end

			warn(string.format("[SubscriptionHarness] proxy sync failed for %s: %s", v98, (tostring(result))))
		end)

		if v49 == "connected" then
			v52(v45)
		end
	end, { v45 })

	local v56 = React.useCallback(function() -- line: 202
		-- upvalues: v55 (copy), v45 (copy)
		v55(not v45)
	end, {
		v55,
		v45
	})
	local v57 = React.useCallback(function() -- line: 206
		-- upvalues: v53 (copy), v54 (copy), v17 (copy), HttpRbxApiService (copy)
		local v87 = not v53

		v54(v87)

		local t12 = {
			enabled = tostring(v87)
		}

		task.spawn(function() -- line: 59
			-- upvalues: t12 (copy), v17 (copy), HttpRbxApiService (copy)
			local t13 = {}

			for v100, v101 in t12 do
				table.insert(t13, string.format("%s=%s", v100, v101))
			end

			local v102 = if not (#t13 > 0) then v17 else string.format("%s?%s", v17, table.concat(t13, "&"))
			local ok, result = pcall(function() -- line: 67
				-- upvalues: HttpRbxApiService (copy), v102 (copy)
				HttpRbxApiService:GetAsyncFullUrl(v102, Enum.ThrottlingPriority.Default)
			end)
			local v105 = table.concat(t13, " ")

			if ok then
				print(string.format("[SubscriptionHarness] proxy sync: %s", v105))

				return
			end

			warn(string.format("[SubscriptionHarness] proxy sync failed for %s: %s", v105, (tostring(result))))
		end)
	end, { v53 })
	local v58 = React.useCallback(function() -- line: 212
		-- upvalues: v44 (copy)
		v44.setGainedRobloxSubscriptionThisSessionForTesting(true)
	end, { v44 })
	local v59 = React.useCallback(function() -- line: 216
		-- upvalues: v47 (copy), t1 (copy)
		v47(t1)
	end, { v47 })
	local v60 = React.useCallback(function() -- line: 220
		-- upvalues: v44 (copy), v48 (copy), v47 (copy), SetUserHasRobloxSubscription (copy)
		v44.setHasRobloxSubscriptionForTesting(false)
		v44.setGainedRobloxSubscriptionThisSessionForTesting(false)

		if v48 ~= nil then
			v47(SetUserHasRobloxSubscription(v48, false))
		end
	end, {
		v44,
		v47,
		v48
	})
	local v61 = if v49 ~= "connected" then if v49 ~= "unreachable" then if v49 ~= "no_addon" then nil else color3_3 else color3_2 else color3
	local t14 = {
		string.format("Subscription: %s", not v45 and "OFF" or "ON"),
		string.format("GainedThisSession: %s", not v46 and "FALSE" or "TRUE")
	}

	if v49 == "connected" and v51 ~= nil then
		table.insert(t14, string.format("Proxy mode: %s", not v51 and "OFF" or "ON"))
	end

	local v63 = table.concat(t14, "   ")

	return React.createElement(React.Fragment, nil, {
		ProxyStatus = React.createElement(FoundationText, {
			tag = "text-caption-small text-align-x-left",
			LayoutOrder = 1,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = t8[v49] or "",
			TextColor3 = v61
		}),
		HarnessEnableButton = React.createElement(HarnessButton, {
			layoutOrder = 2,
			text = not v53 and "Connect to proxy" or "Disconnect from proxy",
			accent = if not v53 then nil else color3,
			disabled = v49 ~= "connected",
			onClick = v57
		}),
		Status = if not v53 then nil else React.createElement(FoundationText, {
			tag = "text-caption-small text-align-x-left content-muted",
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 20),
			Text = v63
		}),
		ToggleButton = if not v53 then nil else React.createElement(HarnessButton, {
			layoutOrder = 4,
			text = not v45 and "Toggle Sub  (currently OFF)" or "Toggle Sub  (currently ON)",
			accent = if not v45 then color3_2 else color3,
			onClick = v56
		}),
		GainedButton = if not v53 then nil else React.createElement(HarnessButton, {
			layoutOrder = 5,
			text = "Set GainedThisSession = true",
			onClick = v58
		}),
		ClearButton = if not v53 then nil else React.createElement(HarnessButton, {
			layoutOrder = 6,
			text = "Dispatch ClearReceivedCatalogData",
			onClick = v59
		}),
		ResetButton = if not v53 then nil else React.createElement(HarnessButton, {
			layoutOrder = 7,
			text = "Reset all",
			onClick = v60
		})
	})
end

return DebugPanel.registerSection({
	id = "ax.subscriptionHarness",
	order = 100,
	defaultCollapsed = true,
	path = {
		"Economy",
		"Marketplace",
		"Subscription Harness"
	},
	component = SubscriptionHarnessControls
})
