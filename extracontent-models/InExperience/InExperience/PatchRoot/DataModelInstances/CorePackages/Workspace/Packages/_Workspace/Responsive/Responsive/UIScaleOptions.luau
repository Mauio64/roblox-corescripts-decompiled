local UIScaleOptions = {
	get = function(object)
		local success, result = pcall(function()
			return object:GetUIScaleOptions()
		end)
		return if success then result else nil
	end,
	optionId = function(p: number, p2: number)
		return `{p}:{p2}`
	end,
	valueFromOption = function(value: string, p)
		local v, v2 = string.match(value, "^(%d+):(%d+)$")
		local v3 = tonumber(v)
		local v4 = tonumber(v2)

		if v3 and p.enabled[v3] and p.values[v3] == v4 then
			return v4
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
	valueForMode = function(data, flag: boolean)
		if flag == (data.savedHundredths ~= 0) then
			return nil
		end

		if not flag then
			return 0
		end

		local value = data.values[data.defaultIndex]
		return if value and value > 0 then value else nil
	end
}

function UIScaleOptions.valueFromSlider(p: number, p2: number, p3, data)
	if
		data.savedHundredths == 0
		or p ~= p2
		or not data.enabled[p]
		or not UIScaleOptions.equal(p3, data)
		or p == data.selectedIndex
	then
		return nil
	end

	return data.values[p]
end

return UIScaleOptions
