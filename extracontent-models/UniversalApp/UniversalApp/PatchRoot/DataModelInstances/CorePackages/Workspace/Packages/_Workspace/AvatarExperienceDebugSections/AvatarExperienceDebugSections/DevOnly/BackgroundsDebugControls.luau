local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("AvatarExperienceDebugSections").Parent
local DebugPanel = require(Parent.DebugPanel)
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local AvatarExperienceCommon = require(Parent.AvatarExperienceCommon)
local getBaseDomain = require(script.Parent.getBaseDomain)
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local color3 = Color3.fromRGB(80, 200, 120)
local color3_2 = Color3.fromRGB(220, 90, 90)
local color3_3 = Color3.fromRGB(230, 180, 60)
local color3_4 = Color3.fromRGB(100, 160, 255)
local v17 = string.format("https://apis.%s/__bg_harness__", getBaseDomain())
local t1 = {
	"populated",
	"empty",
	"error",
	"passthrough"
}
local t2 = {
	checking = "Checking proxy...",
	connected = "Proxy connected (backgrounds-harness active)",
	unreachable = "Proxy not detected — run `git lua proxy up` with marketplace.backgrounds-harness enabled in proxy-scripts.json.",
	no_addon = "Proxy running but backgrounds-harness addon not loaded — enable marketplace.backgrounds-harness in proxy-scripts.json."
}

local function probeProxyStatus() -- line: 52
	-- upvalues: HttpRbxApiService (copy), v17 (copy), HttpService (copy)
	local ok, result = pcall(function() -- line: 53
		-- upvalues: HttpRbxApiService (copy), v17 (copy)
		return HttpRbxApiService:GetAsyncFullUrl(v17, Enum.ThrottlingPriority.Default)
	end)

	if not ok then
		warn("[BackgroundsHarness] probe failed:", (tostring(result)))

		return "unreachable", nil, nil
	end

	local ok2, result2 = pcall(function() -- line: 60
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok2 or type(result2) ~= "table" or result2.ok ~= true then
		return "no_addon", nil, nil
	end

	return "connected", result2.backgroundsMode, result2.harnessEnabled == true
end
local function setProxyMode(s1: string) -- line: 69
	-- upvalues: v17 (copy), HttpRbxApiService (copy)
	task.spawn(function() -- line: 70
		-- upvalues: v17 (copy), s1 (copy), HttpRbxApiService (copy)
		local v52 = string.format("%s?mode=%s", v17, s1)
		local ok, result = pcall(function() -- line: 72
			-- upvalues: HttpRbxApiService (copy), v52 (copy)
			HttpRbxApiService:GetAsyncFullUrl(v52, Enum.ThrottlingPriority.Default)
		end)

		if ok then
			print(string.format("[BackgroundsHarness] proxy sync: mode=%s", s1))

			return
		end

		warn(string.format("[BackgroundsHarness] proxy sync failed for mode=%s: %s", s1, (tostring(result))))
	end)
end
local function notifyProxyOfHarnessEnabled(b1: boolean) -- line: 83
	-- upvalues: v17 (copy), HttpRbxApiService (copy)
	task.spawn(function() -- line: 84
		-- upvalues: v17 (copy), b1 (copy), HttpRbxApiService (copy)
		local v55 = string.format("%s?enabled=%s", v17, (tostring(b1)))
		local ok, result = pcall(function() -- line: 86
			-- upvalues: HttpRbxApiService (copy), v55 (copy)
			HttpRbxApiService:GetAsyncFullUrl(v55, Enum.ThrottlingPriority.Default)
		end)

		if ok then
			print(string.format("[BackgroundsHarness] proxy sync: enabled=%s", (tostring(b1))))

			return
		end

		warn(string.format("[BackgroundsHarness] proxy sync failed for enabled=%s: %s", tostring(b1), (tostring(result))))
	end)
end
local function StatusRow(t3: {[any]: any}) -- line: 103
	-- upvalues: React (copy), View (copy), FoundationText (copy), color3 (copy), color3_2 (copy)
	return React.createElement(View, {
		ClipsDescendants = true,
		Size = UDim2.new(1, 0, 0, 20),
		LayoutOrder = t3.layoutOrder
	}, {
		Label = React.createElement(FoundationText, {
			tag = "text-caption-small text-align-x-left content-muted",
			Size = UDim2.new(0.45, 0, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Text = t3.label
		}),
		Value = React.createElement(FoundationText, {
			tag = "text-caption-small text-align-x-left",
			Size = UDim2.new(0.55, 0, 1, 0),
			Position = UDim2.new(0.45, 0, 0, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Text = t3.value,
			TextColor3 = if not t3.ok then color3_2 else color3
		})
	})
end
local function ModeButton(t4: {[any]: any}) -- line: 131
	-- upvalues: useTokens (copy), React (copy), View (copy), Foundation (copy), FoundationText (copy), color3_4 (copy)
	local v34 = useTokens()

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, 28),
		LayoutOrder = t4.layoutOrder,
		backgroundStyle = {
			Transparency = 0,
			Color3 = v34.Color.Surface.Surface_300.Color3
		},
		cornerRadius = UDim.new(0, v34.Radius.Small),
		padding = Vector2.new(v34.Padding.Small, 0),
		onActivated = t4.onClick,
		stateLayer = {
			mode = Foundation.Enums.StateLayerMode.Inverse
		}
	}, {
		Label = React.createElement(FoundationText, {
			tag = "text-label-small text-align-x-left",
			Size = UDim2.new(1, 0, 1, 0),
			TextColor3 = if not t4.isActive then v34.Color.Content.Emphasis.Color3 else color3_4,
			Text = if not t4.isActive then t4.text else t4.text .. "  (active)"
		})
	})
end
local function BackgroundsDebugControls() -- line: 157
	-- upvalues: AvatarExperienceFlags (copy), AvatarExperienceCommon (copy), React (copy), probeProxyStatus (copy), v17 (copy), HttpRbxApiService (copy), color3 (copy), color3_2 (copy), color3_3 (copy), StatusRow (copy), View (copy), FoundationText (copy), t2 (copy), ModeButton (copy), t1 (copy)
	local FFlagAXBackgroundsRoot = AvatarExperienceFlags.FFlagAXBackgroundsRoot
	local FFlagAXCatalogBackgroundsSupport = AvatarExperienceFlags.FFlagAXCatalogBackgroundsSupport
	local AvatarBackground = AvatarExperienceCommon.Constants.ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground
	local v38 = AvatarBackground ~= nil
	local ok = pcall(function() -- line: 166
		-- upvalues: AvatarExperienceCommon (copy)
		return AvatarExperienceCommon.Enums.CatalogCategories.Backgrounds
	end)
	local v40, v41 = React.useState("checking")
	local v42, v43 = React.useState(nil)
	local v44, v45 = React.useState(false)

	React.useEffect(function() -- line: 174
		-- upvalues: probeProxyStatus (copy), v41 (copy), v43 (copy), v45 (copy)
		task.spawn(function() -- line: 175
			-- upvalues: probeProxyStatus (copy), v41 (copy), v43 (copy), v45 (copy)
			local v60, v61, v62 = probeProxyStatus()

			v41(v60)
			v43(v61)

			if v62 ~= nil then
				v45(v62)
			end
		end)
	end, {})

	local v46 = React.useCallback(function() -- line: 185
		-- upvalues: v44 (copy), v45 (copy), v17 (copy), HttpRbxApiService (copy)
		local v58 = not v44

		v45(v58)
		task.spawn(function() -- line: 84
			-- upvalues: v17 (copy), v58 (copy), HttpRbxApiService (copy)
			local v63 = string.format("%s?enabled=%s", v17, (tostring(v58)))
			local ok3, result = pcall(function() -- line: 86
				-- upvalues: HttpRbxApiService (copy), v63 (copy)
				HttpRbxApiService:GetAsyncFullUrl(v63, Enum.ThrottlingPriority.Default)
			end)

			if ok3 then
				print(string.format("[BackgroundsHarness] proxy sync: enabled=%s", (tostring(v58))))

				return
			end

			warn(string.format("[BackgroundsHarness] proxy sync failed for enabled=%s: %s", tostring(v58), (tostring(result))))
		end)
	end, { v44 })
	local v47 = React.useCallback(function(s2: string) -- line: 191
		-- upvalues: v17 (copy), HttpRbxApiService (copy), v43 (copy)
		return function() -- line: 192
			-- upvalues: s2 (copy), v17 (copy), HttpRbxApiService (copy), v43 (copy)
			local v66 = s2

			task.spawn(function() -- line: 70
				-- upvalues: v17 (copy), v66 (copy), HttpRbxApiService (copy)
				local v67 = string.format("%s?mode=%s", v17, v66)
				local ok4, result = pcall(function() -- line: 72
					-- upvalues: HttpRbxApiService (copy), v67 (copy)
					HttpRbxApiService:GetAsyncFullUrl(v67, Enum.ThrottlingPriority.Default)
				end)

				if ok4 then
					print(string.format("[BackgroundsHarness] proxy sync: mode=%s", v66))

					return
				end

				warn(string.format("[BackgroundsHarness] proxy sync failed for mode=%s: %s", v66, (tostring(result))))
			end)
			v43(s2)
		end
	end, {})
	local v48 = if v40 ~= "connected" then if v40 ~= "unreachable" then if v40 ~= "no_addon" then nil else color3_3 else color3_2 else color3
	local t5 = {
		EngineEnum = React.createElement(StatusRow, {
			label = "Engine enum",
			value = "Available",
			ok = true,
			layoutOrder = 1
		}),
		FlagRoot = React.createElement(StatusRow, {
			label = "FFlagAXBackgroundsRoot",
			layoutOrder = 2,
			value = not FFlagAXBackgroundsRoot and "OFF" or "ON",
			ok = FFlagAXBackgroundsRoot
		}),
		FlagSupport = React.createElement(StatusRow, {
			label = "FFlagAXCatalogBackgroundsSupport",
			layoutOrder = 3,
			value = not FFlagAXCatalogBackgroundsSupport and "OFF" or "ON",
			ok = FFlagAXCatalogBackgroundsSupport
		}),
		AssetTypeId = React.createElement(StatusRow, {
			label = "Asset type ID",
			layoutOrder = 4,
			value = not v38 and "nil (flag off)" or tostring(AvatarBackground),
			ok = v38
		}),
		CategoryEnum = React.createElement(StatusRow, {
			label = "CatalogCategories.Backgrounds",
			layoutOrder = 5,
			value = not ok and "nil (flag off)" or "Registered",
			ok = ok
		}),
		Divider = React.createElement(View, {
			LayoutOrder = 10,
			Size = UDim2.new(1, 0, 0, 8)
		}),
		ProxyStatus = React.createElement(FoundationText, {
			tag = "text-caption-small text-align-x-left",
			LayoutOrder = 11,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = t2[v40] or "",
			TextColor3 = v48
		})
	}

	if v40 == "connected" then
		t5.HarnessEnableButton = React.createElement(ModeButton, {
			layoutOrder = 12,
			text = not v44 and "Connect to proxy" or "Disconnect from proxy",
			isActive = v44,
			onClick = v46
		})

		if v44 then
			t5.ModeLabel = React.createElement(FoundationText, {
				tag = "text-caption-small text-align-x-left content-muted",
				LayoutOrder = 13,
				Size = UDim2.new(1, 0, 0, 20),
				Text = string.format("Current mode: %s", v42 or "unknown")
			})

			for v50, v51 in t1 do
				t5["Mode_" .. v51] = React.createElement(ModeButton, {
					text = v51,
					isActive = v42 == v51,
					onClick = v47(v51),
					layoutOrder = 20 + v50
				})
			end
		end
	end

	return React.createElement(React.Fragment, nil, t5)
end

return DebugPanel.registerSection({
	id = "ax.backgroundsDebug",
	order = 200,
	path = {
		"Economy",
		"Marketplace",
		"Backgrounds"
	},
	component = BackgroundsDebugControls
})
