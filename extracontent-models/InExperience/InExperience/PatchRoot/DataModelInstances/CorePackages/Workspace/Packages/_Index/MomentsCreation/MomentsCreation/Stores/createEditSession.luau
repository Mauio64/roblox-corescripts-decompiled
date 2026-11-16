local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Signals = require(parent.Signals)

require(MomentsCreation.Types.CreationFlowTypes)

local GetFFlagMomentsCreationAccurateDirtyTracking = require(MomentsCreation.Flags.GetFFlagMomentsCreationAccurateDirtyTracking)

local createSignal = Signals.createSignal

local function draftsEqual(items, items2): boolean
	if items == items2 then
		return true
	end

	if type(items) ~= "table" or type(items2) ~= "table" then
		return false
	end

	for k, item in items do
		if items2[k] ~= item then
			return false
		end
	end

	for k, item in items2 do
		if items[k] ~= item then
			return false
		end
	end

	return true
end

local function createEditSession()
	local signal, v = createSignal(nil)
	local signal2, v2 = createSignal(false)
	local v3 = nil

	local function begin(p)
		v3 = p
		v(p)
		v2(false)
	end

	local function update(p)
		v(p)

		if GetFFlagMomentsCreationAccurateDirtyTracking then
			v2(not draftsEqual(p, v3))
		else
			v2(true)
		end
	end

	local function commit()
		local v4 = signal(false)
		v3 = v4
		v2(false)
		return v4
	end

	local function discard()
		v(v3)
		v2(false)
	end

	return {
		getDraft = signal,
		getIsDirty = signal2,
		begin = begin,
		update = update,
		commit = commit,
		discard = discard
	}
end

return createEditSession
