local llama = require("@luauforge/bundled/fQM").llama

local v5 = {}

function v5.createIdToAgreementMap(items)
	local agreementTypesById = {}

	for k, item in items do
		agreementTypesById[item.id] = item.agreementType
	end

	return agreementTypesById
end

function v5.getCheckBoxStatusVariables(items, p2)
	local idToAgreementMap = v5.createIdToAgreementMap(p2)
	local v6 = true
	local v7 = false
	local v8 = true

	for k, item in items do
		local idToAgreement = idToAgreementMap[k]
		local v9 = string.find(idToAgreement:lower(), "optional")
		v7 = v9 and true or v7

		if item then
			continue
		end

		v8 = false

		if not v9 then
			v6 = false
		end
	end

	return v6, v7, v8
end

function v5.getAgreedUserAgreements(p2)
	local filtered = llama.Dictionary.filter(p2, function(p3): boolean
		return p3 == true
	end)

	return (llama.Dictionary.keys(filtered))
end

return v5
