local ImpressionsUtil = {}

function ImpressionsUtil.writeItemAttributes(p, instance, p2)
	if not p then
		warn("Impressions schema is nil")
		return
	end

	for k, v in p.mapping do
		local v2 = p2[k]

		if v2 then
			instance:SetAttribute(v.attribute, v2)
		end
	end
end

function ImpressionsUtil.buildSchema(p: string, data)
	local groupBy = data.groupBy
	local mapping = {}

	for _, v in data.mapping do
		local isGrouping

		if groupBy then
			isGrouping = table.find(groupBy, v.out) ~= nil
		else
			isGrouping = false
		end

		mapping[v.prop] = {
			attribute = string.format("%s_%s", p, v.prop),
			out = v.out,
			isGrouping = isGrouping
		}
	end

	if groupBy then
		for _, v in groupBy do
			local v2 = false

			for _, v3 in data.mapping do
				v2 = v3.out == v or v2

				if v2 then
					break
				end
			end

			if not v2 then
				error(string.format("Impression schema groupBy field '%s' not specified in output mapping", v))
			end
		end
	end

	return {
		mapping = mapping,
		enumMap = data.enumMap,
		surfaceSpecificAnalyticsMetadata = data.surfaceSpecificAnalyticsMetadata
	}
end

function ImpressionsUtil.packEvents(p, items)
	if not p then
		warn("Impressions schema nil")
		return
	end

	local v = {}
	local result = {}

	for k, item in items do
		local attributes = item:GetAttributes()
		local v2 = ""

		for _, v3 in p.mapping do
			if v3.isGrouping then
				v2 ..= attributes[v3.attribute] or "_"
			end
		end

		local v3 = v[v2] or {}
		v[v2] = v3

		for _, v4 in p.mapping do
			local attribute = attributes[v4.attribute]
			local out = v4.out

			if v4.isGrouping then
				v3[out] = attribute
			else
				local v5 = v3[out] or {}
				v3[out] = v5
				v5[k] = attribute or ""

				if p.enumMap and p.enumMap[out] then
					v5[k] = p.enumMap[out][attribute]
				end
			end
		end
	end

	for _, v2 in v do
		local v3 = {}
		table.insert(result, v3)

		for _, v4 in p.mapping do
			local out = v4.out
			local v5 = v2[out]

			if typeof(v5) == "table" then
				for _, v6 in v5 do
					if v3[out] then
						v3[out] ..= "," .. tostring(v6)
					else
						v3[out] = tostring(v6)
					end
				end
			else
				v3[out] = v5
			end
		end
	end

	return result
end

return ImpressionsUtil
