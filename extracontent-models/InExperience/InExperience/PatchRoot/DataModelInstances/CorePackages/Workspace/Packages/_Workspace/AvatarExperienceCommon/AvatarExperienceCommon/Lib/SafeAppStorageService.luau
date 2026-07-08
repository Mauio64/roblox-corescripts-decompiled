local AppStorageService = game:GetService("AppStorageService")
local v2 = _G.__DEV__ or false
local t1 = {}

return {
	getItem = function(s1: string, b1: boolean?) -- line: 25
		-- upvalues: v2 (copy), t1 (ref), AppStorageService (copy)
		if v2 or b1 then
			return t1[s1] or ""
		end

		local ok, result = pcall(function() -- line: 30
			-- upvalues: AppStorageService (copy), s1 (copy)
			return AppStorageService:GetItem(s1)
		end)

		if ok then
			return result
		end

		return t1[s1] or ""
	end,
	setItem = function(s2: string, s3: string, b2: boolean?) -- line: 42
		-- upvalues: v2 (copy), t1 (ref), AppStorageService (copy)
		if v2 or b2 then
			t1[s2] = s3

			return
		end

		if not pcall(function() -- line: 48
			-- upvalues: AppStorageService (copy), s2 (copy), s3 (copy)
			AppStorageService:SetItem(s2, s3)
		end) then
			t1[s2] = s3
		end
	end,
	flush = function() -- line: 56
		-- upvalues: AppStorageService (copy)
		pcall(function() -- line: 57
			-- upvalues: AppStorageService (copy)
			AppStorageService:Flush()
		end)
	end,
	_resetMemStorageForTesting = function(t2: {[any]: any}?) -- line: 20
		-- upvalues: t1 (ref)
		t1 = t2 or {}
	end
}
