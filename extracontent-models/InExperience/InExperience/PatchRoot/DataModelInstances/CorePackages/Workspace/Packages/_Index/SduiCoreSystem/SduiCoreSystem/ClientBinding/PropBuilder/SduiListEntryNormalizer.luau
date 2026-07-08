local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)

local function tryResolveTemplatePair(s1: string?, p1, p2) -- line: 69
	if p1 ~= nil then
		return p1, true
	end

	if s1 and s1 ~= "" then
		local v10 = p2.getTemplateForRobloxComponent(s1)

		if v10 then
			return v10, false
		end
	end

	return nil, false
end
local function resolveItemOverrides(t1: {[any]: any}?, p3) -- line: 98
	if t1 == nil or next(t1) == nil then
		return nil
	end

	local t2 = {}
	local g19 = nil
	local g20 = nil
	local v18 = nil

	for v14, v15 in t1 do
		local roblox_component = v15.roblox_component
		local inline_component = v15.inline_component

		if inline_component ~= nil then
			v18 = true
			g19 = true
		end

		if not g19 then
			repeat
				if not g20 and (roblox_component and roblox_component ~= "") then
					inline_component = p3.getTemplateForRobloxComponent(roblox_component)

					if not inline_component then
						g20 = true
					end

					if not g20 then
						v18 = false
					end
				else
					g20 = false
					inline_component = nil
					v18 = false
				end
			until not g20
		end

		g19 = false
		t2[v14] = {
			template = inline_component,
			isInline = v18,
			inputs = v15.inputs,
			sortRankProp = v15.sort_rank
		}
	end

	return t2
end
local function pickTemplate(p4, t3: {[any]: any}?, p5, b1: boolean, p6) -- line: 123
	local v26 = if typeof(p4) ~= "table" then nil else p4.roblox_component
	local v27 = if typeof(p4) ~= "table" then nil else p4.inline_component
	local g29 = nil
	local v28 = nil

	if v27 ~= nil then
		v28 = true
		g29 = true
	end

	repeat
		if g29 or (g29 or v26 and v26 ~= "") then
			if not g29 then
				if not g29 then
					v27 = p6.getTemplateForRobloxComponent(v26)
				end
			end

			if g29 or (g29 or v27) then
				if not g29 then
					if not g29 then
						v28 = false
					end
				end

				g29 = false

				if v27 then
					return v27, v28
				end

				if t3 and t3.template then
					return t3.template, t3.isInline
				end

				return p5, b1
			end
		end

		v27 = nil
		v28 = false
		g29 = true
	until not g29
end
local function resolveDefaultTemplate(p7, p8) -- line: 148
	-- upvalues: tryResolveTemplatePair (copy)
	if p7 == nil then
		return nil, false
	end

	return tryResolveTemplatePair(p7.roblox_component, p7.inline_component, p8)
end
local function buildBoundEntry(p9, s2: string?, p10, b2: boolean, t4: {[any]: any}?, p11, t5: {[any]: any}?, p12) -- line: 193
	local v58 = if not t5 or not s2 then nil else t5[s2]
	local v59 = if typeof(p9) ~= "table" then nil else p9.roblox_component
	local v60 = if typeof(p9) ~= "table" then nil else p9.inline_component
	local g62 = nil
	local v61 = nil

	if v60 ~= nil then
		v61 = true
		g62 = true
	end

	repeat
		if g62 or (g62 or v59 and v59 ~= "") then
			if not g62 then
				if not g62 then
					v60 = p12.getTemplateForRobloxComponent(v59)
				end
			end

			if g62 or (g62 or v60) then
				if not g62 then
					if not g62 then
						v61 = false
					end
				end

				g62 = false

				if v60 then
				elseif v58 and v58.template then
					v60 = v58.template
					v61 = v58.isInline
				else
					v60 = p10
					v61 = b2
				end

				local v63 = if typeof(p9) ~= "table" then nil else p9.sort_rank

				return {
					sourceMode = "data",
					item = p9,
					identifier = s2,
					inputs = v58 and v58.inputs or t4,
					template = v60,
					isInline = v61,
					sortRankProp = v63 or (v58 and v58.sortRankProp or p11)
				}
			end
		end

		v60 = nil
		v61 = false
		g62 = true
	until not g62
end

return {
	normalizeLiteralItems = function(t6: {[any]: any}, p13, p14) -- line: 160
		local v35 = if not p13 then nil else p13.inputs
		local v36 = if not p13 then nil else p13.sort_rank
		local g39 = nil
		local roblox_component = nil
		local v37 = nil
		local g48 = nil
		local g49 = nil
		local v38 = nil
		local v47 = nil

		if p13 == nil then
			v37 = nil
			v38 = false
			g39 = true
		end

		if not g39 then
			roblox_component = p13.roblox_component
			v37 = p13.inline_component

			if v37 ~= nil then
				v38 = true
				g39 = true
			end
		end

		repeat
			if g39 or (g39 or (g39 or roblox_component and roblox_component ~= "")) then
				if not g39 then
					if not g39 then
						if not g39 then
							v37 = p14.getTemplateForRobloxComponent(roblox_component)
						end
					end
				end

				if g39 or (g39 or (g39 or v37)) then
					if not g39 then
						if not g39 then
							if not g39 then
								v38 = false
							end
						end
					end

					g39 = false

					local t7 = {}

					for _, v43 in t6 do
						local identifier = v43.identifier

						if identifier == "" then
							identifier = nil
						end

						local v45 = if typeof(v43) ~= "table" then nil else v43.roblox_component
						local v46 = if typeof(v43) ~= "table" then nil else v43.inline_component

						if v46 ~= nil then
							v47 = true
							g48 = true
						end

						if not g48 then
							repeat
								if not g49 and (v45 and v45 ~= "") then
									v46 = p14.getTemplateForRobloxComponent(v45)

									if not v46 then
										g49 = true
									end

									if not g49 then
										v47 = false
									end
								else
									g49 = false
									v46 = nil
									v47 = false
								end
							until not g49
						end

						g48 = false

						if v46 then
						else
							v46 = v37
							v47 = v38
						end

						table.insert(t7, {
							sourceMode = "literal",
							item = v43,
							identifier = identifier,
							inputs = v43.inputs or v35,
							template = v46,
							isInline = v47,
							sortRankProp = v43.sort_rank or v36
						})
					end

					return t7
				end
			end

			v37 = nil
			v38 = false
			g39 = true
		until not g39
	end,
	normalizeBoundData = function(p15, p16, t8: {[any]: any}?, p17) -- line: 227
		-- upvalues: resolveItemOverrides (copy), buildBoundEntry (copy)
		if typeof(p15) ~= "table" then
			return {}
		end

		local v68 = if not p16 then nil else p16.inputs
		local v69 = if not p16 then nil else p16.sort_rank
		local g72 = nil
		local roblox_component = nil
		local v70 = nil
		local v71 = nil

		if p16 == nil then
			v70 = nil
			v71 = false
			g72 = true
		end

		if not g72 then
			roblox_component = p16.roblox_component
			v70 = p16.inline_component

			if v70 ~= nil then
				v71 = true
				g72 = true
			end
		end

		repeat
			if g72 or (g72 or (g72 or roblox_component and roblox_component ~= "")) then
				if not g72 then
					if not g72 then
						if not g72 then
							v70 = p17.getTemplateForRobloxComponent(roblox_component)
						end
					end
				end

				if g72 or (g72 or (g72 or v70)) then
					if not g72 then
						if not g72 then
							if not g72 then
								v71 = false
							end
						end
					end

					g72 = false

					local v74 = resolveItemOverrides(t8, p17)
					local t9 = {}

					if p15[1] ~= nil or next(p15) == nil then
						for _, v77 in p15 do
							local v78 = if typeof(v77) ~= "table" then nil else v77.identifier

							if v78 == "" then
								v78 = nil
							end

							table.insert(t9, (buildBoundEntry(v77, v78, v70, v71, v68, v69, v74, p17)))
						end

						return t9
					end

					for v79, v80 in p15 do
						table.insert(t9, (buildBoundEntry(v80, tostring(v79), v70, v71, v68, v69, v74, p17)))
					end

					return t9
				end
			end

			v70 = nil
			v71 = false
			g72 = true
		until not g72
	end
}
