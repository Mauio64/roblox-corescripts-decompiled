local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local t1 = {}

if require(script.Parent.Flags.FFlagEnableNextUpImageLatencyTelemetry) then
	local u4 = nil
	local u5 = nil
	local u6 = nil

	function t1.getNextUpComponentSortLatency() -- line: 14
		-- upvalues: u6 (ref)
		return u6
	end
	function t1.nextUpComponentShown() -- line: 18
		-- upvalues: u4 (ref)
		u4 = time()
	end
	function t1.nextUpComponentSortDataLoaded() -- line: 22
		-- upvalues: u5 (ref), u6 (ref), u4 (ref)
		if u5 then
			return
		end

		local v9 = time()

		u5 = v9
		u6 = not u4 and 0 or v9 - u4
	end

	local t2 = {}

	function t1.getNextUpTileImageTextureLatencies() -- line: 35
		-- upvalues: Cryo (copy), t2 (ref)
		return Cryo.Dictionary.values(t2)
	end
	function t1.nextUpTileImageTextureLoaded(n1: number) -- line: 39
		-- upvalues: t2 (ref), u5 (ref)
		local str = tostring(n1)

		if t2[str] then
			return
		end

		t2[str] = not u5 and 0 or time() - u5
	end
	function t1.resetNextUpLatencyTelemetry() -- line: 50
		-- upvalues: u5 (ref), t2 (ref), u4 (ref), u6 (ref)
		u5 = nil
		t2 = {}
		u4 = nil
		u6 = nil
	end

	return t1
end

local u8 = false

function t1.setNextUpTilesLoaded(b1: boolean) -- line: 58
	-- upvalues: u8 (ref)
	u8 = b1
end
function t1.getNextUpTilesLoaded() -- line: 62
	-- upvalues: u8 (ref)
	return u8
end

return t1
