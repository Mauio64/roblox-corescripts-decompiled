local IXPService = game:GetService("IXPService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation

local v5 = {}

v5.ExposureKind = {
	FlagLinked = "FlagLinked",
	BrowserTracker = "BrowserTracker",
	UserLayer = "UserLayer",
	Creator = "Creator"
}

local v6 = {
	remove = function() end
}

local v7 = {
	[v5.ExposureKind.FlagLinked] = "LogFlagLinkedUserLayerExposure",
	[v5.ExposureKind.BrowserTracker] = "LogBrowserTrackerLayerExposure",
	[v5.ExposureKind.UserLayer] = "LogUserLayerExposure",
	[v5.ExposureKind.Creator] = "LogCreatorLayerExposure"
}

local v8 = IXPService

local function normalizeLayers(value)
	if type(value) == "string" then
		return { value }
	end

	return value
end

local function isAnyFlagEnabled(items)
	if items == nil then
		return true
	end

	if type(items) == "boolean" then
		return items
	end

	for k, item in items do
		if item then
			return true
		end
	end

	return false
end

local function logExposure(items, kind)
	local v9 = kind or v5.ExposureKind.FlagLinked

	for k, item in items do
		local v10 = v7[v9]
		local v11 = if v10 then v8[v10] else nil

		if v11 then
			v11(v8, item)
		end
	end
end

function v5.createExposureHandler(value, p2)
	local v9 = type(value) == "string" and { value } or value

	local flags = if p2 then p2.flags else nil
	local kind = if p2 then p2.kind else nil

	return function()
		local v10 = flags

		if v10 == nil then
			v10 = true
		elseif type(v10) ~= "boolean" then
			local flag = true

			for k, v11 in v10 do
				if v11 then
					v10 = true
					flag = false
					break
				end
			end

			if flag then
				v10 = false
			end
		end

		if v10 then
			logExposure(v9, kind)
		end
	end
end

function v5.useExposureOnFocus(p2, p3)
	local v9 = useNavigation()
	local flags = if p3 then p3.flags else nil
	local kind = if p3 then p3.kind else nil

	React.useEffect(function()
		if not v9 then
			return nil
		end

		local v10 = flags

		if v10 == nil then
			v10 = true
		elseif type(v10) ~= "boolean" then
			local flag = true

			for k, v11 in v10 do
				if v11 then
					v10 = true
					flag = false
					break
				end
			end

			if flag then
				v10 = false
			end
		end

		if not v10 then
			return nil
		end

		local exposureHandler = v5.createExposureHandler(p2, {
			flags = flags,
			kind = kind
		})

		local v11 = v9.addListener(RoactNavigation.Events.WillFocus, exposureHandler)

		if v9.isFocused and v9.isFocused() then
			exposureHandler()
		end

		return function()
			v11.remove()
		end
	end, { v9, p2, flags, kind })
end

function v5.registerExposureOnFocus(p2, p3, p4)
	if not p2 then
		return v6
	end

	local v9 = if p4 then p4.flags else nil

	if v9 == nil then
		v9 = true
	elseif type(v9) ~= "boolean" then
		local flag = true

		for k, v10 in v9 do
			if v10 then
				v9 = true
				flag = false
				break
			end
		end

		if flag then
			v9 = false
		end
	end

	if v9 then
		return p2.addListener(RoactNavigation.Events.WillFocus, v5.createExposureHandler(p3, p4))
	end

	return v6
end

function v5.setMocksForTesting(p2)
	v8 = p2 or v8
end

function v5.restoreDefaultsAfterTesting()
	v8 = IXPService
end

return v5
