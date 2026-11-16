local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local GetFFlagMomentsCreationAccurateDirtyTracking = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsCreationAccurateDirtyTracking")

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
	local signal, v5 = createSignal(nil)
	local signal2, v6 = createSignal(false)
	local v7 = nil

	local function begin(p2)
		v7 = p2
		v5(p2)
		v6(false)
	end

	local function update(p2)
		v5(p2)

		if GetFFlagMomentsCreationAccurateDirtyTracking then
			v6(not draftsEqual(p2, v7))
		else
			v6(true)
		end
	end

	local function commit()
		local v8 = signal(false)
		v7 = v8
		v6(false)
		return v8
	end

	local function discard()
		v5(v7)
		v6(false)
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
