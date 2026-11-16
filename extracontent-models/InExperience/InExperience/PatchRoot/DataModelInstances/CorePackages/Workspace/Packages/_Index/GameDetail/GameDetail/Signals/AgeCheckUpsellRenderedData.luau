local parent = script:FindFirstAncestor("GameDetail").Parent
local Signals = require(parent.Signals)

local AgeCheckUpsellDismissedData = require(script.Parent.AgeCheckUpsellDismissedData)

local v = {}

local function getOrCreate(p: string) -- 2 equivalent calls inferred from this helper
	local v2 = v[p]

	if not v2 then
		local signal, set = Signals.createSignal(false)
		v2 = { get = signal, set = set }
		v[p] = v2
	end

	return v2
end

local AgeCheckUpsellRenderedData = {}

function AgeCheckUpsellRenderedData.getIsAgeCheckUpsellRendered(p, p2: string?)
	if p2 == nil or p2 == "" or AgeCheckUpsellDismissedData.getIsAgeCheckUpsellDismissed(p) then
		return false
	end

	return getOrCreate(p2).get(p) -- inferred equivalent call
end

function AgeCheckUpsellRenderedData.setAgeCheckUpsellRendered(p: string, flag: boolean)
	if p == nil or p == "" then
		return
	end

	getOrCreate(p).set(flag) -- inferred equivalent call
end

return AgeCheckUpsellRenderedData
