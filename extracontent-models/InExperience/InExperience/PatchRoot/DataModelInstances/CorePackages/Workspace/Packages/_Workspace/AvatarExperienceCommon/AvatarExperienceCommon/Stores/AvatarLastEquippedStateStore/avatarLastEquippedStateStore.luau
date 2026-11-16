local v = nil
local v2 = false
local v3 = true
local AvatarLastEquippedStateStore = {}

function AvatarLastEquippedStateStore.getAvatarLastEquippedState()
	return v
end

function AvatarLastEquippedStateStore.setAvatarLastEquippedState(p)
	v = p
end

function AvatarLastEquippedStateStore.getChangedLayeredMakeupSorting()
	return v2
end

function AvatarLastEquippedStateStore.setChangedLayeredMakeupSorting(flag: boolean)
	v2 = flag
end

function AvatarLastEquippedStateStore.getShouldRevertLastEquippedState()
	return v3
end

function AvatarLastEquippedStateStore.setShouldRevertLastEquippedState(flag: boolean)
	v3 = flag
end

return AvatarLastEquippedStateStore
