local v5 = {
	get = function(object)
		local success, result = pcall(function()
			return object:GetUIScaleOptions()
		end)

		if success then
			return result
		end

		return nil
	end,
	optionId = function(p2, p3)
		return `{p2}:{p3}`
	end,
	valueFromOption = function(value, p2)
		local v6, v7 = string.match(value, "^(%d+):(%d+)$")
		local v8 = tonumber(v6)
		local v9 = tonumber(v7)

		if v8 and p2.enabled[v8] and p2.values[v8] == v9 then
			return v9
		end

		return nil
	end,
	equal = function(data, data2): boolean
		if
			data.savedHundredths ~= data2.savedHundredths
			or data.autoHundredths ~= data2.autoHundredths
			or data.selectedIndex ~= data2.selectedIndex
			or data.defaultIndex ~= data2.defaultIndex
			or #data.values ~= #data2.values
		then
			return false
		end

		for k, value in data.values do
			if value ~= data2.values[k] or data.enabled[k] ~= data2.enabled[k] then
				return false
			end
		end

		return true
	end,
	valueForMode = function(data, p2)
		if p2 == (data.savedHundredths ~= 0) then
			return nil
		end

		if not p2 then
			return 0
		end

		local value = data.values[data.defaultIndex]

		if value and value > 0 then
			return value
		end

		return nil
	end
}

function v5.valueFromSlider(p2, p3, p4, data)
	if
		data.savedHundredths == 0
		or p2 ~= p3
		or not data.enabled[p2]
		or not v5.equal(p4, data)
		or p2 == data.selectedIndex
	then
		return nil
	end

	return data.values[p2]
end

return v5
