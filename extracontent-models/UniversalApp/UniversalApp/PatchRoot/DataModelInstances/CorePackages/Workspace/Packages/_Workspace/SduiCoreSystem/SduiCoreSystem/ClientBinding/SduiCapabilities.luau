local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local SduiCapabilityFlags = require(SduiCoreSystem.ClientBinding.SduiCapabilityFlags)
local t2 = {
	isEnabled = function(s1: string) -- line: 16
		-- upvalues: SduiCapabilityFlags (copy)
		return SduiCapabilityFlags[s1] == true
	end,
	getEnabledCapabilities = function() -- line: 20
		-- upvalues: SduiCapabilityFlags (copy)
		local t1 = {}

		for v8, v9 in SduiCapabilityFlags do
			if v9 then
				table.insert(t1, v8)
			end
		end

		return t1
	end
}

local function resolveNamesToNumbers(t3: {[any]: any}) -- line: 30
	-- upvalues: SduiCoreSystemParent (copy)
	if #t3 == 0 then
		return {}
	end

	local Capability = require(SduiCoreSystemParent.ServiceContractsProto).apppageplatform.shared.capability.Capability
	local t4 = {}

	for _, v14 in t3 do
		local v15 = Capability.fromName(v14)

		if v15 == nil then
			warn(`SduiCapabilities: unknown capability name { v14 }`)
		else
			table.insert(t4, Capability.toNumber(v15))
		end
	end

	return t4
end

function t2.createQueryValue(t5: {[any]: any}) -- line: 51
	-- upvalues: resolveNamesToNumbers (copy)
	local v17 = resolveNamesToNumbers(t5)

	if #v17 == 0 then
		return nil
	end

	table.sort(v17)

	local t6 = table.create(#v17)

	for _, v20 in v17 do
		table.insert(t6, (tostring(v20)))
	end

	return table.concat(t6, ",")
end
function t2.addToQueryParams(t7: {[any]: any}, t8: {[any]: any}) -- line: 71
	-- upvalues: t2 (copy)
	local t9 = {}

	for _, v25 in t8 do
		if t2.isEnabled(v25) then
			table.insert(t9, v25)
		end
	end

	local v26 = t2.createQueryValue(t9)

	if v26 ~= nil then
		t7.enabledCapabilities = v26
	end
end
function t2.getEnabledCapabilityNumbers(t10: {[any]: any}) -- line: 87
	-- upvalues: t2 (copy), resolveNamesToNumbers (copy)
	local t11 = {}

	for _, v30 in t10 do
		if t2.isEnabled(v30) then
			table.insert(t11, v30)
		end
	end

	local v31 = resolveNamesToNumbers(t11)

	table.sort(v31)

	return v31
end
function t2.addAllToQueryParams(t12: {[any]: any}) -- line: 99
	-- upvalues: t2 (copy)
	local v33 = t2.createQueryValue(t2.getEnabledCapabilities())

	if v33 ~= nil then
		t12.enabledCapabilities = v33
	end
end

return t2
