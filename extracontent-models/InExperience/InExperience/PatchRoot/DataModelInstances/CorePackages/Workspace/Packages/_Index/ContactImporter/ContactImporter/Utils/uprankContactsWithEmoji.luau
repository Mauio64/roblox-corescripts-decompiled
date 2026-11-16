local parent = script:FindFirstAncestor("ContactImporter").Parent
local Cryo = require(parent.Cryo)

local function isEmoji(p: number): boolean
	return p >= 9728 and p <= 9983
		or p >= 9984 and p <= 10175
		or p >= 127744 and p <= 128511
		or p >= 128512 and p <= 128591
		or p >= 128640 and p <= 128767
		or p >= 128768 and p <= 128895
		or p >= 129280 and p <= 129535
		or p >= 127462 and p <= 127487
		or p >= 127344 and p <= 127569
		or p >= 129536 and p <= 129791
end

local function getStringHasEmoji(contactName: string): boolean -- 2 equivalent calls inferred from this helper
	for _, v in utf8.codes(contactName) do
		if isEmoji(v) then
			return true
		end
	end

	return false
end

local function uprankContactsWithEmoji(p)
	return Cryo.List.sort(p, function(p2, p3)
		if p2.contactName and p3.contactName then
			local stringHasEmoji = getStringHasEmoji(p2.contactName) -- inferred equivalent call

			if stringHasEmoji ~= getStringHasEmoji(p3.contactName) then -- inferred equivalent call
				return stringHasEmoji
			end

			if p2.contactName ~= p3.contactName then
				return string.upper(p2.contactName) < string.upper(p3.contactName)
			end
		end

		return (p2.contactId or "") < (p3.contactId or "")
	end)
end

return uprankContactsWithEmoji
