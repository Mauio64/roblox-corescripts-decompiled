local scriptParent = script.Parent
local llama = require(scriptParent.dependencies).llama
local t2 = {
	createIdToAgreementMap = function(p1) -- line: 16
		local t1 = {}

		for _, v7 in p1 do
			t1[v7.id] = v7.agreementType
		end

		return t1
	end
}

function t2.getCheckBoxStatusVariables(t3: {[any]: any}, t4: {[any]: any}) -- line: 24
	-- upvalues: t2 (copy)
	local v10 = true
	local v11 = false
	local v12 = true
	local v13 = t2.createIdToAgreementMap(t4)

	for v14, v15 in t3 do
		local v16 = v13[v14]
		local v17 = string.find(v16:lower(), "optional")

		if v17 then
			v11 = true
		end

		if not v15 then
			v12 = false

			if not v17 then
				v10 = false
			end
		end
	end

	return v10, v11, v12
end
function t2.getAgreedUserAgreements(t5: {[any]: any}) -- line: 52
	-- upvalues: llama (copy)
	local v19 = llama.Dictionary.filter(t5, function(p2) -- line: 53
		return p2 == true
	end)

	return (llama.Dictionary.keys(v19))
end

return t2
