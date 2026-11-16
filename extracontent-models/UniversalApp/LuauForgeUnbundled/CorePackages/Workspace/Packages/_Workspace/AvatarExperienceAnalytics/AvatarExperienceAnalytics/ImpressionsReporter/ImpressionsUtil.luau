return {
	writeItemAttributes = function(p2, instance, p3)
		if not p2 then
			warn("Impressions schema is nil")
			return
		end

		for k, v5 in p2.mapping do
			local v6 = p3[k]

			if v6 then
				instance:SetAttribute(v5.attribute, v6)
			end
		end
	end,
	buildSchema = function(p2, data)
		local groupBy = data.groupBy
		local v5 = {}

		for k, v6 in data.mapping do
			local v7 = if groupBy then table.find(groupBy, v6.out) ~= nil else false

			v5[v6.prop] = {
				attribute = string.format("%s_%s", p2, v6.prop),
				out = v6.out,
				isGrouping = v7
			}
		end

		if groupBy then
			for k, v6 in groupBy do
				local v7 = false

				for k2, v9 in data.mapping do
					v7 = v9.out == v6 or v7

					if v7 then
						break
					end
				end

				if not v7 then
					error(string.format(
						"Impression schema groupBy field '%s' not specified in output mapping",
						v6
					))
				end
			end
		end

		return {
			mapping = v5,
			enumMap = data.enumMap,
			surfaceSpecificAnalyticsMetadata = data.surfaceSpecificAnalyticsMetadata
		}
	end,
	packEvents = function(p2, items)
		if not p2 then
			warn("Impressions schema nil")
			return
		end

		local v5 = {}
		local result = {}

		for k, item in items do
			local attributes = item:GetAttributes()
			local v6 = ""

			for k2, v7 in p2.mapping do
				if v7.isGrouping then
					v6 ..= attributes[v7.attribute] or "_"
				end
			end

			local v7 = v5[v6] or {}
			v5[v6] = v7

			for k2, v8 in p2.mapping do
				local attribute = attributes[v8.attribute]
				local out = v8.out

				if v8.isGrouping then
					v7[out] = attribute
				else
					local v9 = v7[out] or {}
					v7[out] = v9
					v9[k] = attribute or ""

					if p2.enumMap and p2.enumMap[out] then
						v9[k] = p2.enumMap[out][attribute]
					end
				end
			end
		end

		for k, v6 in v5 do
			local v7 = {}
			table.insert(result, v7)

			for k2, v8 in p2.mapping do
				local out = v8.out
				local v9 = v6[out]

				if typeof(v9) == "table" then
					for k3, v10 in v9 do
						if v7[out] then
							v7[out] ..= "," .. tostring(v10)
						else
							v7[out] = tostring(v10)
						end
					end
				else
					v7[out] = v9
				end
			end
		end

		return result
	end
}
