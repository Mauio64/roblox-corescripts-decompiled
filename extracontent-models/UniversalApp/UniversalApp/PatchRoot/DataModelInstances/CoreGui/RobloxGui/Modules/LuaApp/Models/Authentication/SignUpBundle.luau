local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local t = require(CorePackages.Packages.t)
local t1 = {}
local v5 = t.interface({
	bundleId = t.number,
	userOutfitId = t.number
})

function t1.new() -- line: 20
	return {
		bundleId = "",
		userOutfitId = ""
	}
end
function t1.mock() -- line: 27
	-- upvalues: t1 (copy)
	local v6 = t1.new()

	v6.bundleId = "23452"
	v6.userOutfitId = "65234"

	return v6
end
function t1.fromData(p1) -- line: 36
	-- upvalues: t1 (copy), v5 (copy), ArgCheck (copy)
	local v8 = t1.new()
	local v9, v10 = v5(p1)

	if v9 then
		v8.bundleId = tostring(p1.bundleId)
		v8.userOutfitId = tostring(p1.userOutfitId)

		return v8
	end

	ArgCheck.assert(false, v10)

	return v8
end

return t1
