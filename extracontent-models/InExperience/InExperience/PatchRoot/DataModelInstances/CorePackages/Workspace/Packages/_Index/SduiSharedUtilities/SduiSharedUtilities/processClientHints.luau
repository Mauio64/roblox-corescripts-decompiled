local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiGameIconPrewarm = require(SduiSharedUtilities.SduiGameIconPrewarm)

require(SduiSharedUtilities.SduiIntegrationTypes)

local _ = {
	PrewarmIcon = "prewarm_icon",
	PrewarmLargeIcon = "prewarm_large_icon"
}
local t1 = {
	prewarm_icon = SduiGameIconPrewarm.prewarmSmallIcons,
	prewarm_large_icon = SduiGameIconPrewarm.prewarmLargeIcons
}

local function collectHintsInTemplateTree(p1, p2: ((...any) -> ...any), t2: {[any]: any}, t3: {[any]: any}) -- line: 43
	-- upvalues: collectHintsInTemplateTree (copy)
	if type(p1) ~= "table" then
		return
	end

	for v17, v18 in p1 do
		if v17 == "client_hints" and type(v18) == "table" then
			for _, v20 in v18 do
				if type(v20) == "string" then
					t2[v20] = true
				end
			end
		elseif v17 == "roblox_component" and type(v18) == "string" and v18 ~= "" then
			if not t3[v18] then
				t3[v18] = true

				local v21 = p2(v18)

				if v21 ~= nil then
					collectHintsInTemplateTree(v21, p2, t2, t3)
				end
			end
		elseif type(v18) == "table" then
			collectHintsInTemplateTree(v18, p2, t2, t3)
		end
	end
end

local self = setmetatable({}, {
	__mode = "k"
})

local function getHintsDeclaredBy(p3, p4: ((...any) -> ...any)) -- line: 83
	-- upvalues: self (copy), collectHintsInTemplateTree (copy)
	if p3 == nil then
		return {}
	end

	local v24 = self[p3]

	if v24 ~= nil then
		return v24
	end

	local t4 = {}

	collectHintsInTemplateTree(p3, p4, t4, {})
	self[p3] = t4

	return t4
end
local function declaresHintWithHandler(p5, p6: ((...any) -> ...any)) -- line: 100
	-- upvalues: getHintsDeclaredBy (copy), t1 (copy)
	for v28 in getHintsDeclaredBy(p5, p6) do
		if t1[v28] then
			return true
		end
	end

	return false
end
local function anyTemplateDeclaresHintWithHandler(p7, p8: ((...any) -> ...any)) -- line: 112
	-- upvalues: getHintsDeclaredBy (copy), t1 (copy)
	local g35 = nil
	local v34 = nil

	for _, v32 in p7.getKnownTemplates() do
		for v33 in getHintsDeclaredBy(v32, p8) do
			if t1[v33] then
				v34 = true
				g35 = true
			end

			if g35 then
				break
			end
		end

		if not g35 then
			v34 = false
		end

		g35 = false

		if v34 then
			return true
		end
	end

	return false
end
local function attributeHintTo(t5: {[any]: any}, s1: string, p9) -- line: 124
	local v39 = t5[s1]

	if v39 == nil then
		v39 = {}
		t5[s1] = v39
	end

	table.insert(v39, p9)
end
local function attributeHintsInInputData(p10, p11: ((...any) -> ...any), t6: {[any]: any}, t7: {[any]: any}) -- line: 147
	-- upvalues: getHintsDeclaredBy (copy), t1 (copy), attributeHintsInInputData (copy)
	if type(p10) ~= "table" then
		return
	end

	local v44 = t6
	local roblox_component = p10.roblox_component
	local v46 = if type(roblox_component) ~= "string" or roblox_component == "" then nil else p11(roblox_component)

	if v46 ~= nil then
		for v47 in getHintsDeclaredBy(v46, p11) do
			if t1[v47] and not v44[v47] then
				if v44 == t6 then
					v44 = table.clone(t6)
				end

				v44[v47] = true

				local v48 = t7[v47]

				if v48 == nil then
					v48 = {}
					t7[v47] = v48
				end

				table.insert(v48, p10)
			end
		end
	end

	for _, v50 in p10 do
		if type(v50) == "table" then
			attributeHintsInInputData(v50, p11, v44, t7)
		end
	end
end
local function processClientHints(p12) -- line: 194
	-- upvalues: getHintsDeclaredBy (copy), t1 (copy), attributeHintsInInputData (copy)
	local getTemplateForRobloxComponent = p12.getTemplateForRobloxComponent

	if getTemplateForRobloxComponent == nil then
		return
	end

	local g57 = nil
	local v56 = nil
	local g59 = nil
	local v58 = nil

	for _, v54 in p12.getKnownTemplates() do
		for v55 in getHintsDeclaredBy(v54, getTemplateForRobloxComponent) do
			if t1[v55] then
				v56 = true
				g57 = true
			end

			if g57 then
				break
			end
		end

		if not g57 then
			v56 = false
		end

		g57 = false

		if v56 then
			v58 = true
			g59 = true
		end

		if g59 then
			break
		end
	end

	if not g59 then
		v58 = false
	end

	g59 = false

	if not v58 then
		return
	end

	local t8 = {}

	for _, v62 in p12.pageEntries do
		local robloxComponentType = v62.robloxComponentType
		local componentInputData = v62.componentInputData

		if robloxComponentType and componentInputData then
			local t9 = {}
			local v66 = getTemplateForRobloxComponent(robloxComponentType)

			if v66 ~= nil then
				for v67 in getHintsDeclaredBy(v66, getTemplateForRobloxComponent) do
					if t1[v67] then
						t9[v67] = true

						local v68 = t8[v67]

						if v68 == nil then
							v68 = {}
							t8[v67] = v68
						end

						table.insert(v68, componentInputData)
					end
				end
			end

			attributeHintsInInputData(componentInputData, getTemplateForRobloxComponent, t9, t8)
		end
	end

	for v69, v70 in t8 do
		t1[v69](v70)
	end
end

return processClientHints
