local CorePackages = game:GetService("CorePackages")
local module = require("@luauforge/bundled/dwM")
local t = require(CorePackages.Packages.t)

local v5 = {}

local interface = t.interface({ bundleId = t.number, userOutfitId = t.number })

function v5.new()
	return { bundleId = "", userOutfitId = "" }
end

function v5.mock()
	local v6 = v5.new()

	v6.bundleId = "23452"
	v6.userOutfitId = "65234"

	return v6
end

function v5.fromData(p2)
	local v6 = v5.new()

	local v7, v8 = interface(p2)

	if not v7 then
		module.assert(false, v8)

		return v6
	end

	v6.bundleId = tostring(p2.bundleId)
	v6.userOutfitId = tostring(p2.userOutfitId)
	return v6
end

return v5
