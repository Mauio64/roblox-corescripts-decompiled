local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
require("@luauforge/bundled/dHL")

local module = require("@luauforge/bundled/dTb")
local module2 = require("@luauforge/bundled/dTc")

local module3 = require("@luauforge/bundled/dTd")
local module4 = require("@luauforge/bundled/dTe")
local module5 = require("@luauforge/bundled/dTf")
local module6 = require("@luauforge/bundled/dTg")
local module7 = require("@luauforge/bundled/dTh")
local module8 = require("@luauforge/bundled/dCn")

return Rodux.createReducer({
	lastSuccessfulPoseEmoteAssetId = nil,
	emoteAssetId = nil,
	fieldOfViewDeg = nil,
	ppeVersion = { [module7.Closeup] = 0, [module7.FullBody] = 0 },
	ppeEmoteLoadingCount = 0
}, {
	[module5.name] = function(p2, p3)
		local v8 = p2.ppeEmoteLoadingCount + 1
		return Cryo.Dictionary.join(p2, { ppeEmoteLoadingCount = v8 })
	end,
	[module4.name] = function(p2, p3)
		local v8 = p2.ppeEmoteLoadingCount - 1

		if v8 < 0 then
			module8("newPPEEmoteLoadingCount is less than 0")
		end

		return Cryo.Dictionary.join(p2, { ppeEmoteLoadingCount = v8 })
	end,
	[module3.name] = function(p2, p3)
		local lastSuccessfulPoseEmoteAssetId = p3.lastSuccessfulPoseEmoteAssetId or Cryo.None
		return Cryo.Dictionary.join(p2, {
			lastSuccessfulPoseEmoteAssetId = lastSuccessfulPoseEmoteAssetId
		})
	end,
	[module.name] = function(p2, p3)
		local emoteAssetId = p3.emoteAssetId or Cryo.None
		return Cryo.Dictionary.join(p2, { emoteAssetId = emoteAssetId })
	end,
	[module2.name] = function(p2, p3)
		local fieldOfViewDeg = p3.fieldOfViewDeg or Cryo.None
		return Cryo.Dictionary.join(p2, { fieldOfViewDeg = fieldOfViewDeg })
	end,
	[module6.name] = function(p2, p3)
		local v9 = Cryo.Dictionary.join(p2.ppeVersion, {
			[p3.thumbnailType] = p2.ppeVersion[p3.thumbnailType] + 1
		})

		return Cryo.Dictionary.join(p2, { ppeVersion = v9 })
	end
})
