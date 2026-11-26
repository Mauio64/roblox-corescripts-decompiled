local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/AppCommonLib").Signal

local v5 = nil
local v6 = nil

local function getOpenProfileRequested()
	local v7 = v5

	if v7 ~= nil then
		return v7
	end

	local v8 = signal.new()
	v5 = v8
	return v8
end

local function getOpenAddFriendsRequested()
	local v7 = v6

	if v7 ~= nil then
		return v7
	end

	local v8 = signal.new()
	v6 = v8
	return v8
end

return {
	requestOpenProfile = function(p2, p3)
		local v7 = v5

		if v7 == nil then
			v7 = signal.new()
			v5 = v7
		end

		v7:fire({ userId = p2, extraProps = p3 })
	end,
	subscribeOpenProfile = function(p2)
		local v7 = v5

		if v7 == nil then
			v7 = signal.new()
			v5 = v7
		end

		return v7:connect(p2)
	end,
	requestOpenAddFriends = function()
		local v7 = v6

		if v7 == nil then
			v7 = signal.new()
			v6 = v7
		end

		v7:fire()
	end,
	subscribeOpenAddFriends = function(p2)
		local v7 = v6

		if v7 == nil then
			v7 = signal.new()
			v6 = v7
		end

		return v7:connect(p2)
	end
}
