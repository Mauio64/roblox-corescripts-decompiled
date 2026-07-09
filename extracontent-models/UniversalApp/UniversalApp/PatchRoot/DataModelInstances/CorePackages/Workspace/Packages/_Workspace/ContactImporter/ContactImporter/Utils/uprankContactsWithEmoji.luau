local Parent = script:FindFirstAncestor("ContactImporter").Parent
local Cryo = require(Parent.Cryo)

local function isEmoji(n1: number) -- line: 5
	if n1 >= 9728 and n1 <= 9983 or n1 >= 9984 and n1 <= 10175 or n1 >= 127744 and n1 <= 128511 or n1 >= 128512 and n1 <= 128591 or n1 >= 128640 and n1 <= 128767 or n1 >= 128768 and n1 <= 128895 or n1 >= 129280 and n1 <= 129535 or n1 >= 127462 and n1 <= 127487 or n1 >= 127344 and n1 <= 127569 or n1 >= 129536 and n1 <= 129791 then
		return true
	end

	return false
end
local function getStringHasEmoji(s1: string) -- line: 33
	-- upvalues: isEmoji (copy)
	for _, v9 in utf8.codes(s1) do
		if isEmoji(v9) then
			return true
		end
	end

	return false
end
local function uprankContactsWithEmoji(p1) -- line: 42
	-- upvalues: Cryo (copy), isEmoji (copy)
	return Cryo.List.sort(p1, function(p2, p3) -- line: 43
		-- upvalues: isEmoji (copy)
		if p2.contactName and p3.contactName then
			local contactName = p2.contactName
			local g17 = nil
			local g22 = nil
			local v16 = nil
			local v21 = nil

			for _, v15 in utf8.codes(contactName) do
				if isEmoji(v15) then
					v16 = true
					g17 = true
				end

				if g17 then
					break
				end
			end

			if not g17 then
				v16 = false
			end

			g17 = false

			local contactName2 = p3.contactName

			for _, v20 in utf8.codes(contactName2) do
				if isEmoji(v20) then
					v21 = true
					g22 = true
				end

				if g22 then
					break
				end
			end

			if not g22 then
				v21 = false
			end

			g22 = false

			if v16 ~= v21 then
				return v16
			end

			if p2.contactName ~= p3.contactName then
				return string.upper(p2.contactName) < string.upper(p3.contactName)
			end
		end

		return (p2.contactId or "") < (p3.contactId or "")
	end)
end

return uprankContactsWithEmoji
