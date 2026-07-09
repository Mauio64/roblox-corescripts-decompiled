return {
	writeItemAttributes = function(t1: {[any]: any}, p1, t2: {[any]: any}) -- line: 58
		if not t1 then
			warn("Impressions schema is nil")

			return
		end

		for v4, v5 in t1.mapping do
			local v6 = t2[v4]

			if v6 then
				p1:SetAttribute(v5.attribute, v6)
			end
		end
	end,
	buildSchema = function(s1: string, t3: {[any]: any}) -- line: 74
		local t4 = {}
		local groupBy = t3.groupBy

		for _, v12 in t3.mapping do
			local v13 = not not groupBy and table.find(groupBy, v12.out) ~= nil

			t4[v12.prop] = {
				attribute = string.format("%s_%s", s1, v12.prop),
				out = v12.out,
				isGrouping = v13
			}
		end

		if groupBy then
			for _, v15 in groupBy do
				local v16 = false

				for _, v18 in t3.mapping do
					if v15 == v18.out then
						v16 = true
					end

					if v16 then
						break
					end
				end

				if not v16 then
					error(string.format("Impression schema groupBy field '%s' not specified in output mapping", v15))
				end
			end
		end

		return {
			mapping = t4,
			enumMap = t3.enumMap,
			surfaceSpecificAnalyticsMetadata = t3.surfaceSpecificAnalyticsMetadata
		}
	end,
	packEvents = function(t5: {[any]: any}, t6: {[any]: any}) -- line: 116
		if not t5 then
			warn("Impressions schema nil")

			return
		end

		local t7 = {}
		local t8 = {}

		for v23, v24 in t6 do
			local Attributes = v24:GetAttributes()
			local s2 = ""

			for _, v28 in t5.mapping do
				if v28.isGrouping then
					s2 ..= Attributes[v28.attribute] or "_"
				end
			end

			local v29 = t7[s2] or {}

			t7[s2] = v29

			for _, v31 in t5.mapping do
				local v32 = Attributes[v31.attribute]
				local out = v31.out

				if v31.isGrouping then
					v29[out] = v32
				else
					local v34 = v29[out] or {}

					v29[out] = v34
					v34[v23] = v32 or ""

					if t5.enumMap and t5.enumMap[out] then
						v34[v23] = t5.enumMap[out][v32]
					end
				end
			end
		end

		for _, v36 in t7 do
			local t9 = {}

			table.insert(t8, t9)

			for _, v39 in t5.mapping do
				local out = v39.out
				local v41 = v36[out]

				if typeof(v41) == "table" then
					for _, v43 in v41 do
						if t9[out] then
							t9[out] = t9[out] .. "," .. tostring(v43)
						else
							t9[out] = tostring(v43)
						end
					end
				else
					t9[out] = v41
				end
			end
		end

		return t8
	end
}
