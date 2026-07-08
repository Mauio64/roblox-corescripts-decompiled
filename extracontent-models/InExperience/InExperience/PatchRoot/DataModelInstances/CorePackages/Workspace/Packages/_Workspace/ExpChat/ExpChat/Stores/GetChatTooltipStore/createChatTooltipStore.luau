local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Display = require(ExpChatParent.Display)
local Signals = require(ExpChatParent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local createEffect = Signals.createEffect
local isUserChatEnabled = require(ExpChat.isUserChatEnabled)
local GetChatStatusStore = require(script.Parent.Parent.GetChatStatusStore)
local GetPresetChatStore = require(script.Parent.Parent.GetPresetChatStore)
local promptsApi = require(script.Parent.promptsApi)
local t1 = {
	"GlobalChatTooltip",
	"PresetChatTooltip"
}
local t2 = {
	isEligible = false,
	isDismissed = false,
	shouldShow = false
}

return function() -- line: 90
	-- upvalues: createSignal (copy), createComputed (copy), Display (copy), GetChatStatusStore (copy), GetPresetChatStore (copy), isUserChatEnabled (copy), t2 (copy), t1 (copy), createEffect (copy), promptsApi (copy)
	local v14, v15 = createSignal(false)
	local v16, v17 = createSignal(false)
	local v18, v19 = createSignal(false)
	local v20 = createComputed(function(p1) -- line: 95
		-- upvalues: Display (copy)
		return Display.GetDisplayStore(p1).getViewportSize(p1).X >= 720
	end)
	local v21 = GetChatStatusStore(false)
	local v22 = GetPresetChatStore(false)
	local t3 = {
		GlobalChatTooltip = function(p2) -- line: 110
			-- upvalues: isUserChatEnabled (copy), v21 (copy), v18 (copy)
			return isUserChatEnabled(v21.getChatStatus(p2)) and v18(p2)
		end,
		PresetChatTooltip = function(p3) -- line: 113
			-- upvalues: v22 (copy)
			return v22.getIsEnabled(p3) and v22.getAccessLevel(p3) == "Enabled"
		end
	}
	local t4 = {}

	local function ensureTooltip(s1: string) -- line: 123
		-- upvalues: t4 (copy), createSignal (copy), t2 (copy), createComputed (copy)
		local v37 = t4[s1]

		if v37 then
			return v37
		end

		local v38, v39 = createSignal(t2)
		local t5 = {
			getEntry = v38,
			setEntry = v39,
			getIsEligible = createComputed(function(p4) -- line: 134
				-- upvalues: v38 (copy)
				return v38(p4).isEligible
			end),
			getIsDismissed = createComputed(function(p5) -- line: 137
				-- upvalues: v38 (copy)
				return v38(p5).isDismissed
			end),
			getShouldShow = createComputed(function(p6) -- line: 140
				-- upvalues: v38 (copy)
				return v38(p6).shouldShow
			end)
		}

		t4[s1] = t5

		return t5
	end

	for _, v27 in t1 do
		ensureTooltip(v27)
	end

	local function setField(s2: string, s3: string, p7) -- line: 156
		-- upvalues: ensureTooltip (copy)
		ensureTooltip(s2).setEntry(function(p8) -- line: 158
			-- upvalues: s3 (copy), p7 (copy)
			if p8[s3] == p7 then
				return p8
			end

			local v78 = table.clone(p8)

			v78[s3] = p7

			return v78
		end)
	end
	local function isTooltipValid(p9, s4: string) -- line: 170
		-- upvalues: t3 (copy), t4 (copy)
		local v46 = t3[s4]

		if v46 ~= nil and not v46(p9) then
			return false
		end

		local v47 = t4[s4]

		if v47 == nil then
			return false
		end

		local v48 = v47.getEntry(p9)

		return v48.isEligible and not v48.isDismissed
	end

	local v30, v31 = createSignal(nil)
	local v32 = createEffect(function(p10) -- line: 197
		-- upvalues: v30 (copy), t3 (copy), t4 (copy), t1 (copy), v31 (copy)
		local v50 = v30(false)

		if v50 ~= nil then
			local v51 = t3[v50]
			local v52

			if v51 ~= nil and not v51(p10) then
				v52 = false
			else
				local v53 = t4[v50]

				if v53 == nil then
					v52 = false
				else
					local v54 = v53.getEntry(p10)

					v52 = v54.isEligible and not v54.isDismissed
				end
			end

			if v52 then
				return
			end
		end

		for _, v56 in t1 do
			local v57 = t3[v56]
			local v58

			if v57 ~= nil and not v57(p10) then
				v58 = false
			else
				local v59 = t4[v56]

				if v59 == nil then
					v58 = false
				else
					local v60 = v59.getEntry(p10)

					v58 = v60.isEligible and not v60.isDismissed
				end
			end

			if v58 then
				if v50 ~= v56 then
					v31(v56)
				end

				return
			end
		end

		if v50 ~= nil then
			v31(nil)
		end
	end)

	return {
		getIsChatWindowOpen = v14,
		setIsChatWindowOpen = v15,
		getIsChatInputBarVisible = v16,
		setIsChatInputBarVisible = v17,
		getIsScreenWideEnough = v20,
		setIsGlobalChatAvailable = v19,
		getActiveTooltipKey = v30,
		getIsEligible = function(s5: string) -- line: 229
			-- upvalues: ensureTooltip (copy)
			return ensureTooltip(s5).getIsEligible
		end,
		setIsEligible = function(s6: string, b1: boolean) -- line: 232
			-- upvalues: ensureTooltip (copy)
			local s7 = "isEligible"

			ensureTooltip(s6).setEntry(function(p11) -- line: 158
				-- upvalues: s7 (copy), b1 (copy)
				if p11[s7] == b1 then
					return p11
				end

				local v80 = table.clone(p11)

				v80[s7] = b1

				return v80
			end)
		end,
		getIsDismissed = function(s8: string) -- line: 235
			-- upvalues: ensureTooltip (copy)
			return ensureTooltip(s8).getIsDismissed
		end,
		setIsDismissed = function(s9: string, b2: boolean) -- line: 238
			-- upvalues: ensureTooltip (copy)
			local s10 = "isDismissed"

			ensureTooltip(s9).setEntry(function(p12) -- line: 158
				-- upvalues: s10 (copy), b2 (copy)
				if p12[s10] == b2 then
					return p12
				end

				local v82 = table.clone(p12)

				v82[s10] = b2

				return v82
			end)
		end,
		getShouldShow = function(s11: string) -- line: 241
			-- upvalues: ensureTooltip (copy)
			return ensureTooltip(s11).getShouldShow
		end,
		setShouldShow = function(s12: string, b3: boolean) -- line: 244
			-- upvalues: ensureTooltip (copy)
			local s13 = "shouldShow"

			ensureTooltip(s12).setEntry(function(p13) -- line: 158
				-- upvalues: s13 (copy), b3 (copy)
				if p13[s13] == b3 then
					return p13
				end

				local v84 = table.clone(p13)

				v84[s13] = b3

				return v84
			end)
		end,
		reportImpression = function(s14: string) -- line: 247
			-- upvalues: promptsApi (copy)
			promptsApi.reportImpression(s14)
		end,
		activeTooltipKeyEffect = v32
	}
end
