local MemStorageService = game:GetService("MemStorageService")
local HttpService = game:GetService("HttpService")
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 14
	-- upvalues: t1 (copy)
	return (setmetatable({
		memStorageKey = p1
	}, t1))
end
function t1.getItem(p2) -- line: 21
	-- upvalues: MemStorageService (copy), HttpService (copy)
	local ok, result = pcall(function() -- line: 22
		-- upvalues: MemStorageService (copy), p2 (copy), HttpService (copy)
		local Item = MemStorageService:GetItem(p2.memStorageKey)

		if Item and Item ~= "" then
			return HttpService:JSONDecode(Item)
		end

		return nil
	end)

	if ok then
		return result
	end

	return nil
end
function t1.setItem(p3, p4) -- line: 35
	-- upvalues: MemStorageService (copy), HttpService (copy)
	local ok, _ = pcall(function() -- line: 36
		-- upvalues: MemStorageService (copy), p3 (copy), p4 (copy), HttpService (copy)
		MemStorageService:SetItem(p3.memStorageKey, (not p4 or p4 == "") and "" or HttpService:JSONEncode(p4))
	end)

	return ok
end
function t1.bindAndFire(p5, p6) -- line: 42
	-- upvalues: MemStorageService (copy), HttpService (copy)
	return (MemStorageService:BindAndFire(p5.memStorageKey, function(p7) -- line: 43
		-- upvalues: HttpService (copy), p6 (copy)
		local data = nil

		if p7 and p7 ~= "" then
			data = HttpService:JSONDecode(p7)
		end

		if p6 then
			p6(data)
		end
	end))
end

return t1
