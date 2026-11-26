local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Cryo")

local function isEmoji(p2): boolean
	return p2 >= 9728 and p2 <= 9983
		or p2 >= 9984 and p2 <= 10175
		or p2 >= 127744 and p2 <= 128511
		or p2 >= 128512 and p2 <= 128591
		or p2 >= 128640 and p2 <= 128767
		or p2 >= 128768 and p2 <= 128895
		or p2 >= 129280 and p2 <= 129535
		or p2 >= 127462 and p2 <= 127487
		or p2 >= 127344 and p2 <= 127569
		or p2 >= 129536 and p2 <= 129791
end

local function getStringHasEmoji(p2): boolean
	for k, v5 in utf8.codes(p2) do
		if isEmoji(v5) then
			return true
		end
	end

	return false
end

local function uprankContactsWithEmoji(p2)
	return Cryo.List.sort(p2, function(p3, p4)
		if not (p3.contactName and p4.contactName) then
			return (p3.contactId or "") < (p4.contactId or "")
		end

		local contactName = p3.contactName
		local flag = true
		local v5

		for k, v6 in utf8.codes(contactName) do
			if isEmoji(v6) then
				v5 = true
				flag = false
				break
			end
		end

		if flag then
			v5 = false
		end

		local contactName2 = p4.contactName
		local flag2 = true
		local v6

		for k, v7 in utf8.codes(contactName2) do
			if isEmoji(v7) then
				v6 = true
				flag2 = false
				break
			end
		end

		if flag2 then
			v6 = false
		end

		if v5 ~= v6 then
			return v5
		end

		if p3.contactName ~= p4.contactName then
			return string.upper(p3.contactName) < string.upper(p4.contactName)
		end

		return (p3.contactId or "") < (p4.contactId or "")
	end)
end

return uprankContactsWithEmoji
