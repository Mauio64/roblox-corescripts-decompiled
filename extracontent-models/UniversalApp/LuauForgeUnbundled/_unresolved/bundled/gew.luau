local function optionalQueryString(value)
	if typeof(value) == "string" and value ~= "" then
		return value
	end

	return nil
end

local function purchaseCopy(data)
	local title = data.title

	if typeof(title) ~= "string" or title == "" then
		title = nil
	end

	local description = data.description

	if typeof(description) ~= "string" or description == "" then
		description = nil
	end

	local v5 = data.ctatext

	if typeof(v5) ~= "string" or v5 == "" then
		v5 = nil
	end

	if not v5 then
		v5 = data.ctaText

		if typeof(v5) ~= "string" or v5 == "" then
			v5 = nil
		end
	end

	if title == nil and description == nil and v5 == nil then
		return nil
	end

	return { title = title, description = description, ctaText = v5 }
end

return {
	sheetRoute = function(p2)
		local v5 = p2.sheetkind

		if typeof(v5) ~= "string" or v5 == "" then
			v5 = nil
		end

		if not v5 then
			v5 = p2.sheetKind

			if typeof(v5) ~= "string" or v5 == "" then
				v5 = nil
			end
		end

		if v5 == "free" or v5 == "redirect" then
			return v5
		end

		return "paid"
	end,
	purchaseCopy = purchaseCopy,
	routePlusSubscribe = function(data, data2)
		local v5 = data.sheetkind

		if typeof(v5) ~= "string" or v5 == "" then
			v5 = nil
		end

		if not v5 then
			v5 = data.sheetKind

			if typeof(v5) ~= "string" or v5 == "" then
				v5 = nil
			end
		end

		local v6 = v5 ~= "free" and v5 ~= "redirect" and "paid" or v5
		local openClaimSheet = data2.openClaimSheet

		if not openClaimSheet or v6 ~= "free" and v6 ~= "redirect" then
			data2.startPaidPurchase(purchaseCopy(data))
			return
		end

		if v6 ~= "redirect" then
			openClaimSheet()

			return
		end

		local acceptCallback = data2.acceptCallback(data.callback)

		if not acceptCallback then
			openClaimSheet()
			return
		end

		local followCallback = data2.followCallback
		openClaimSheet(function()
			followCallback(acceptCallback)
		end)
	end
}
