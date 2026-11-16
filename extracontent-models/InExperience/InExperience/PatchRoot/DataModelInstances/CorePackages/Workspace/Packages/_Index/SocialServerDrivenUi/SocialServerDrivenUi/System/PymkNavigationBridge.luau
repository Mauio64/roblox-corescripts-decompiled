local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

local v = nil
local v2 = nil

local function getOpenProfileRequested()
	local v3 = v

	if v3 ~= nil then
		return v3
	end

	local v4 = Signal.new()
	v = v4
	return v4
end

local function getOpenAddFriendsRequested()
	local v3 = v2

	if v3 ~= nil then
		return v3
	end

	local v4 = Signal.new()
	v2 = v4
	return v4
end

local PymkNavigationBridge = {}

function PymkNavigationBridge.requestOpenProfile(userId: string, extraProps)
	local v3 = v

	if v3 == nil then
		v3 = Signal.new()
		v = v3
	end

	v3:fire({ userId = userId, extraProps = extraProps })
end

function PymkNavigationBridge.subscribeOpenProfile(callback)
	local v3 = v

	if v3 == nil then
		v3 = Signal.new()
		v = v3
	end

	return v3:connect(callback)
end

function PymkNavigationBridge.requestOpenAddFriends()
	local v3 = v2

	if v3 == nil then
		v3 = Signal.new()
		v2 = v3
	end

	v3:fire()
end

function PymkNavigationBridge.subscribeOpenAddFriends(callback)
	local v3 = v2

	if v3 == nil then
		v3 = Signal.new()
		v2 = v3
	end

	return v3:connect(callback)
end

return PymkNavigationBridge
