local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("AvatarExperienceDebugSections").Parent
local DebugPanel = require(Parent.DebugPanel)
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local RoactUtils = require(Parent.RoactUtils)
local getBaseDomain = require(script.Parent.getBaseDomain)
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local t1 = {
	"888000001",
	"888000002",
	"888000003"
}
local v14 = string.format("https://apis.%s/__mod_harness__", getBaseDomain())
local t2 = {
	checking = "Detecting proxy...",
	connected = "Proxy detected (moderation-harness active)",
	unreachable = "Proxy not detected — run `git lua proxy up` with marketplace.moderation-harness enabled in proxy-scripts.json.",
	no_addon = "Proxy running but moderation-harness addon not loaded — enable marketplace.moderation-harness in proxy-scripts.json."
}
local color3 = Color3.fromRGB(80, 200, 120)
local color3_2 = Color3.fromRGB(220, 90, 90)
local color3_3 = Color3.fromRGB(230, 180, 60)

local function notifyProxy(t3: {[any]: any}) -- line: 53
	-- upvalues: v14 (copy), HttpRbxApiService (copy)
	task.spawn(function() -- line: 54
		-- upvalues: t3 (copy), v14 (copy), HttpRbxApiService (copy)
		local t4 = {}

		for v73, v74 in t3 do
			table.insert(t4, string.format("%s=%s", v73, v74))
		end

		local v75 = if not (#t4 > 0) then v14 else string.format("%s?%s", v14, table.concat(t4, "&"))
		local ok, result = pcall(function() -- line: 62
			-- upvalues: HttpRbxApiService (copy), v75 (copy)
			HttpRbxApiService:GetAsyncFullUrl(v75, Enum.ThrottlingPriority.Default)
		end)
		local v78 = table.concat(t4, " ")

		if ok then
			print(string.format("[ModerationHarness] proxy sync: %s", v78))

			return
		end

		warn(string.format("[ModerationHarness] proxy sync failed for %s: %s", v78, (tostring(result))))
	end)
end
local function probeProxyStatus() -- line: 74
	-- upvalues: HttpRbxApiService (copy), v14 (copy), HttpService (copy)
	local ok, result = pcall(function() -- line: 75
		-- upvalues: HttpRbxApiService (copy), v14 (copy)
		return HttpRbxApiService:GetAsyncFullUrl(v14, Enum.ThrottlingPriority.Default)
	end)

	if not ok then
		return "unreachable", nil
	end

	local ok2, result2 = pcall(function() -- line: 81
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok2 or type(result2) ~= "table" or result2.ok ~= true then
		return "no_addon", nil
	end

	return "connected", result2.harnessEnabled == true
end
local function HarnessButton(t5: {[any]: any}) -- line: 90
	-- upvalues: useTokens (copy), React (copy), View (copy), Foundation (copy), FoundationText (copy)
	local v31 = useTokens()
	local v32 = t5.disabled == true
	local v33 = if not v32 then t5.accent or v31.Color.Content.Emphasis.Color3 else v31.Color.Content.Muted.Color3

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, 28),
		LayoutOrder = t5.layoutOrder,
		backgroundStyle = {
			Color3 = v31.Color.Surface.Surface_300.Color3,
			Transparency = not v32 and 0 or 0.5
		},
		cornerRadius = UDim.new(0, v31.Radius.Small),
		padding = Vector2.new(v31.Padding.Small, 0),
		onActivated = if not v32 then t5.onClick else nil,
		stateLayer = if not v32 then {
			mode = Foundation.Enums.StateLayerMode.Inverse
		} else nil
	}, {
		Label = React.createElement(FoundationText, {
			tag = "text-label-small text-align-x-left",
			Size = UDim2.new(1, 0, 1, 0),
			TextColor3 = v33,
			Text = t5.text
		})
	})
end
local function dumpAvatarEditorState(p1) -- line: 125
	-- upvalues: t1 (copy)
	local v35 = p1:getState()
	local v36 = v35.AvatarExperience and v35.AvatarExperience.AvatarEditor

	if not v36 then
		warn("[ModerationHarness] AvatarExperience.AvatarEditor state not found")

		return
	end

	local v37 = v36.Character and v36.Character.OwnedItemIdsBySubtype or {}
	local v38 = v36.OutfitInfos or {}
	local v39 = v36.PageFinished or {}

	warn("=== [ModerationHarness] Store Dump ===")
	warn("-- OwnedItemIdsBySubtype keys --")

	for v40, v41 in v37 do
		local v42 = type(v41) ~= "table" and 0 or #v41
		local t6 = {}

		if type(v41) == "table" then
			for _, v45 in v41 do
				for _, v47 in t1 do
					if v47 == tostring(v45) then
						table.insert(t6, v47)
					end
				end
			end
		end

		local v48 = not (#t6 > 0) and "" or string.format(" ** MOCK IDS FOUND: %s **", table.concat(t6, ", "))

		warn(string.format("  [%s] = %d items%s", tostring(v40), v42, v48))
	end

	warn("-- OutfitInfos for mock IDs --")

	for _, v50 in t1 do
		local v51 = v38[v50]

		if v51 then
			warn(string.format("  [%s] = { name=%s, outfitType=%s, availabilityStatus=%s }", v50, tostring(v51.name), tostring(v51.outfitType), (tostring(v51.availabilityStatus))))
		else
			warn(string.format("  [%s] = nil (not stored)", v50))
		end
	end

	warn("-- PageFinished keys --")

	for v52, v53 in v39 do
		warn(string.format("  [%s] = %s", tostring(v52), (tostring(v53))))
	end

	warn("=== End Store Dump ===")
end
local function injectMockOutfitsIntoEditableCharacter(p2) -- line: 186
	-- upvalues: t1 (copy)
	local v55 = p2:getState()
	local v56 = v55.AvatarExperience and v55.AvatarExperience.AvatarEditor

	if not v56 then
		warn("[ModerationHarness] AvatarExperience.AvatarEditor state not found — cannot inject")

		return
	end

	local t7 = {}

	for _, v59 in (v56.Character and v56.Character.OwnedItemIdsBySubtype or {}).EditableCharacter or {} do
		t7[tostring(v59)] = true
	end

	local t8 = {}

	for _, v62 in t1 do
		if not t7[v62] then
			table.insert(t8, v62)
		end
	end

	if #t8 == 0 then
		warn("[ModerationHarness] All mock IDs already in EditableCharacter — nothing to inject")

		return
	end

	p2:dispatch({
		type = "SetOwnedItemIdsBySubtype",
		itemSubType = "EditableCharacter",
		itemIds = t8
	})
	warn(string.format("[ModerationHarness] Injected %d mock outfit IDs into OwnedItemIdsBySubtype[%s]: %s", #t8, "EditableCharacter", table.concat(t8, ", ")))
end
local function ModerationHarnessControls() -- line: 231
	-- upvalues: React (copy), useStore (copy), probeProxyStatus (copy), v14 (copy), HttpRbxApiService (copy), dumpAvatarEditorState (copy), injectMockOutfitsIntoEditableCharacter (copy), color3 (copy), color3_2 (copy), color3_3 (copy), FoundationText (copy), t2 (copy), HarnessButton (copy)
	local v63, v64 = React.useState("checking")
	local v65, v66 = React.useState(false)
	local v67 = useStore()

	React.useEffect(function() -- line: 236
		-- upvalues: probeProxyStatus (copy), v64 (copy), v66 (copy)
		task.spawn(function() -- line: 237
			-- upvalues: probeProxyStatus (copy), v64 (copy), v66 (copy)
			local v81, v82 = probeProxyStatus()

			v64(v81)

			if v82 ~= nil then
				v66(v82)
			end
		end)
	end, {})

	local v68 = React.useCallback(function() -- line: 246
		-- upvalues: v65 (copy), v66 (copy), v14 (copy), HttpRbxApiService (copy)
		local v79 = not v65

		v66(v79)

		local t9 = {
			enabled = tostring(v79)
		}

		task.spawn(function() -- line: 54
			-- upvalues: t9 (copy), v14 (copy), HttpRbxApiService (copy)
			local t10 = {}

			for v84, v85 in t9 do
				table.insert(t10, string.format("%s=%s", v84, v85))
			end

			local v86 = if not (#t10 > 0) then v14 else string.format("%s?%s", v14, table.concat(t10, "&"))
			local ok, result = pcall(function() -- line: 62
				-- upvalues: HttpRbxApiService (copy), v86 (copy)
				HttpRbxApiService:GetAsyncFullUrl(v86, Enum.ThrottlingPriority.Default)
			end)
			local v89 = table.concat(t10, " ")

			if ok then
				print(string.format("[ModerationHarness] proxy sync: %s", v89))

				return
			end

			warn(string.format("[ModerationHarness] proxy sync failed for %s: %s", v89, (tostring(result))))
		end)
	end, { v65 })
	local v69 = React.useCallback(function() -- line: 252
		-- upvalues: dumpAvatarEditorState (copy), v67 (copy)
		dumpAvatarEditorState(v67)
	end, { v67 })
	local v70 = React.useCallback(function() -- line: 256
		-- upvalues: injectMockOutfitsIntoEditableCharacter (copy), v67 (copy)
		injectMockOutfitsIntoEditableCharacter(v67)
	end, { v67 })
	local v71 = if v63 ~= "connected" then if v63 ~= "unreachable" then if v63 ~= "no_addon" then nil else color3_3 else color3_2 else color3

	return React.createElement(React.Fragment, nil, {
		ProxyStatus = React.createElement(FoundationText, {
			tag = "text-caption-small text-align-x-left",
			LayoutOrder = 1,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = t2[v63] or "",
			TextColor3 = v71
		}),
		HarnessEnableButton = React.createElement(HarnessButton, {
			layoutOrder = 2,
			text = not v65 and "Connect to proxy" or "Disconnect from proxy",
			accent = if not v65 then nil else color3,
			disabled = v63 ~= "connected",
			onClick = v68
		}),
		Status = if not v65 then nil else React.createElement(FoundationText, {
			tag = "text-caption-small text-align-x-left content-muted",
			LayoutOrder = 3,
			Text = "Harness active — a fake moderated item will appear at the top of your inventory.",
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}),
		InjectMockOutfitsButton = React.createElement(HarnessButton, {
			layoutOrder = 10,
			text = "Inject Mock Outfits into Saved Avatars",
			accent = color3_3,
			onClick = v70
		}),
		DumpStateButton = React.createElement(HarnessButton, {
			layoutOrder = 11,
			text = "Dump Store State (Output)",
			onClick = v69
		})
	})
end

return DebugPanel.registerSection({
	id = "ax.moderationHarness",
	order = 150,
	defaultCollapsed = true,
	path = {
		"Economy",
		"Marketplace",
		"Moderation Harness"
	},
	component = ModerationHarnessControls
})
